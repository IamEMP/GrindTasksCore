//
//  DataController.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/12/23.
//


import Foundation
import CoreData

enum Status {
    case all, incomplete, completed, scheduled
}

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
class DataController: ObservableObject {
    
    /// The CloudKit container used to store all our data.
    let container: NSPersistentCloudKitContainer
    
    var spotlightDelegate: NSCoreDataCoreSpotlightDelegate?
    
    @Published var selectedFilter: Filter? = Filter.all
    @Published var selectedTask: TaskItem?
    @Published var filterText = ""
    @Published var filterTokens = [Tag]()
    @Published var filterEnabled = true
    @Published var filterStatus = Status.incomplete
    @Published var sortNewestFirst = true
    
    private var saveTask: Task<Void, Error>?
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        return dataController
    }()
    var suggestedFilterTokens: [Tag] {
        guard filterText.starts(with: "#") else {
            return []
        }

        let trimmedFilterText = String(filterText.dropFirst()).trimmingCharacters(in: .whitespaces)
        let request = Tag.fetchRequest()

        if trimmedFilterText.isEmpty == false {
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@", trimmedFilterText)
        }

        return (try? container.viewContext.fetch(request).sorted()) ?? []
    }
    
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()
    
    /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
    /// or on permanent storage (for use in regular app runs.) Defaults to permanent storage.
    /// - Parameter inMemory: Whether to store this data in temporary memory or not.
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")

        // For testing and previewing purposes, we create a
        // temporary, in-memory database by writing to /dev/null
        // so our data is destroyed after the app finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        // This code makes sure we watch iCloud for all changes to make
        // sure we keep  our local UI in sync when a
        // remote change happens
        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber,
            forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: container.persistentStoreCoordinator,
            queue: .main,
            using: remoteStoreChanged
        )

        container.loadPersistentStores { [weak self] _, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
            
            if let description = self?.container.persistentStoreDescriptions.first {
                description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
                
                if let coordinator = self?.container.persistentStoreCoordinator {
                    self?.spotlightDelegate = NSCoreDataCoreSpotlightDelegate(
                        forStoreWith: description, 
                        coordinator: coordinator
                    )
                    
                    self?.spotlightDelegate?.startSpotlightIndexing()
                }
            }
        }
    }
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
    /// Saves our Core Data context iff there are changes. This silently ignores
    /// any errors caused by saving, but this should be fine because all of the attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    func queueSave() {
        saveTask?.cancel()

        saveTask = Task { @MainActor in
            print("Queuing save")
            try await Task.sleep(for: .seconds(3))
            save()
            print("Saved!")
        }
    }
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        
        // ⚠️ When performing a batch delete we need to make sure we read the result back
        // then merge all the changes from that result back into our live view context
        // so that the two stay in sync.
        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        delete(request1)

        let request2: NSFetchRequest<NSFetchRequestResult> = TaskItem.fetchRequest()
        delete(request2)

        save()
    }
    func missingTags(from task: TaskItem) -> [Tag] {
        let request = Tag.fetchRequest()
        let allTags = (try? container.viewContext.fetch(request)) ?? []

        let allTagsSet = Set(allTags)
        let difference = allTagsSet.symmetricDifference(task.taskTags)

        return difference.sorted()
    }
    
    /// Runs a fetch request with various predicates that filter the user's tasks based
    /// on tag, title and content text, search tokens, and completion status.
    /// - Returns: An array of all matching tasks.
    func taskforSelectedFilter() -> [TaskItem] {
        let filter = selectedFilter ?? .all
        var predicates = [NSPredicate]()

        if let tag = filter.tag {
            let tagPredicate = NSPredicate(format: "tags CONTAINS %@", tag)
            predicates.append(tagPredicate)
        } else {
            _ = NSPredicate(format: "assignedDate > %@", filter.minAssignedDate as NSDate)
        }
        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)
        if trimmedFilterText.isEmpty == false {
            let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", trimmedFilterText)
            let contentPredicate = NSPredicate(format: "content CONTAINS[c] %@", trimmedFilterText)
            let combinedPredicate = NSCompoundPredicate(
                orPredicateWithSubpredicates: [titlePredicate, contentPredicate]
            )
            predicates.append(combinedPredicate)
        }
        if filterTokens.isEmpty == false {
            for filterToken in filterTokens {
                let tokenPredicate = NSPredicate(format: "tags CONTAINS %@", filterToken)
                predicates.append(tokenPredicate)
            }
        }
        if filterEnabled {
            if filterStatus != .all {
                let lookForCompleted = filterStatus == .completed
                let statusFilter = NSPredicate(format: "completed = %@", NSNumber(value: lookForCompleted))
                predicates.append(statusFilter)
            }
        }
        let request = TaskItem.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
       let allTasks = (try? container.viewContext.fetch(request)) ?? []
        return allTasks
    }
    func newTask() {
        let task = TaskItem(context: container.viewContext)
        task.title = NSLocalizedString("New task", comment: "Create a new task title")
        task.completed = false
        
        // If we're currently browsing a user-created tag, immediately
        // add this new task to the tag otherwise it won't appear in
        // the list of tasks they see.
        if let tag = selectedFilter?.tag {
            task.addToTags(tag)
        }
        save()
        selectedTask = task
    }
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "tasks":
            // returns true if they added a certain number of tasks
            let fetchRequest = TaskItem.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "completed":
            // returns true if they closed a certain number of tasks
            let fetchRequest = TaskItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "tags":
            // return true if they created a certain number of tags
            let fetchRequest = Tag.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        default:
            // an unknown award criterion; this should never be allowed
            // fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
    func newTag() {
        let tag = Tag(context: container.viewContext)
        tag.id = UUID()
        tag.name = NSLocalizedString("New tag", comment: "Create a new tag")
        save()
    }
    
    func task(with uniqueIdentifier: String) -> TaskItem? {
        guard let url = URL(string: uniqueIdentifier) else {
            return nil
        }
        
        guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
            return nil
        }
        
        return try? container.viewContext.existingObject(with: id) as? TaskItem
    }
}
