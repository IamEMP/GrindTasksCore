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
        assignedDate ?? .now
    }
    
    var taskScheduleTime: Bool {
        scheduleTime
    }
    
    var taskTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
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


