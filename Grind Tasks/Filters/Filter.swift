//
//  Filter.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/14/23.
//

import Foundation
import CoreData

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minAssignedDate = Date.distantPast
    var tag: Tag?
    
    
    
    var activeTasksCount: Int {
        tag?.tagActiveTasks.count ?? 0
    }
    
    static var all = Filter(
        id: UUID(),
        name: "Current Tasks",
        icon: "tray")
        
    static var recent = Filter(
        id: UUID(),
        name: "Recent Tasks",
        icon: "clock",
        minAssignedDate: .now.addingTimeInterval(86400 * -7))
    
    static var completed = Filter(
        id: UUID(),
        name: "Completed Tasks",
        icon: "checkmark")
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
