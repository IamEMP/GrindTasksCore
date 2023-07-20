//
//  ContentView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/12/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
    var tasks: [TaskItem] {
        let filter = dataController.selectedFilter ?? .all
        var allTasks: [TaskItem]

        if let tag = filter.tag {
            allTasks = tag.tasks?.allObjects as? [TaskItem] ?? []
        } else {
            let request = TaskItem.fetchRequest()
            request.predicate = NSPredicate(format: "assignedDate > %@", filter.minAssignedDate as NSDate)
            allTasks = (try? dataController.container.viewContext.fetch(request)) ?? []
        }

        return allTasks.sorted()
    }
    
    var body: some View {
        List(selection: $dataController.selectedTask) {
            ForEach(tasks) { task in
                TaskRowView(tasks: task)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Tasks")
    }
    
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tasks[offset]
            dataController.delete(item)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataController.preview)
    }
}
