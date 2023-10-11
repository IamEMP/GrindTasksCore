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
    
    var openCloseButtonText: LocalizedStringKey {
        task.completed ? "Re-open Task" : "Complete Task"
    }
    
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
                Label(openCloseButtonText, systemImage: "checkmark.circle")
            }
            .sensoryFeedback(trigger: task.completed) { oldValue, newValue in
                if newValue {
                    .success
                } else {
                    nil
                }
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
