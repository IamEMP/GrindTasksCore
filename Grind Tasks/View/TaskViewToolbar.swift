//
//  TaskViewToolbar.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 8/13/23.
//

import SwiftUI

struct TaskViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var task: TaskItem
    
    var body: some View {
        Menu {
            Button {
                UIPasteboard.general.string = task.title
            } label: {
                Label("Copy Task Title", systemImage: "doc.on.doc")
            }
            
            Button {
                UIPasteboard.general.string = task.content
            } label: {
                Label("Copy Task Description", systemImage: "doc.on.doc")
            }

            Button {
                task.completed.toggle()
                dataController.save()
            } label: {
                Label(task.completed ? "Re-open Task" : "Complete Task", systemImage: "checkmark.circle")
            }
            Divider()
            
            Section("Tags") {
                TagsMenuView(task: task)
            }
            
        } label: {
            Label("Actions", systemImage: "ellipsis.circle")
        }
    }
}

struct TaskViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        TaskViewToolbar(task: TaskItem.example)
    }
}
