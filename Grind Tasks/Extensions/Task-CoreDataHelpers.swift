//
//  Extensions.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/17/23.
//

import Foundation
import CoreData


extension TaskItem {
    var taskTitle: String {
        get { title ?? "" }
        set { title = newValue }
    }

    var taskContent: String {
        get { content ?? "" }
        set { content = newValue }
    }

    var taskAssignedDate: Date {
        get { assignedDate ?? .now }
        set { assignedDate = newValue}
    }
    
    var taskScheduleTime: Bool {
        scheduleTime
    }
    
    var taskTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
    }
    
    var taskStatus: String {
        if completed {
            return "Completed"
        } else {
            return "Incomplete"
        }
    }
    
    var taskFormattedScheduledDate: String {
        taskAssignedDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    var taskTagsList: String {
        guard let tags else { return "No tags" }

        if tags.count == 0 {
            return "No tags"
        } else {
            return taskTags.map(\.tagName).formatted()
        }
    }
    
    var taskReminderTime: Date {
        get { reminderTime ?? .now }
        set { reminderTime = newValue }
    }
    
    static var example: TaskItem {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let task = TaskItem(context: viewContext)
        task.title = "Example Issue"
        task.content = "This is an example issue."
        task.completed = Bool.random()
        task.assignedDate = .now
        task.scheduleTime = false
        return task
    }
}


extension TaskItem: Comparable {
    public static func <(lhs: TaskItem, rhs: TaskItem) -> Bool {
        let left = lhs.taskTitle.localizedLowercase
        let right = rhs.taskTitle.localizedLowercase

        if left == right {
            return lhs.taskAssignedDate < rhs.taskAssignedDate
        } else {
            return left < right
        }
    }
}


