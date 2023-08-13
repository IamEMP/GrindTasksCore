//
//  TaskView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/19/23.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var task: TaskItem
    
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Title", text: $task.taskTitle, prompt: Text("Enter the task title here"))
                                .font(.title)
                            
                    DatePicker("Task due by", selection: $task.taskAssignedDate)
                                .datePickerStyle(GraphicalDatePickerStyle())
                            
                    Text("**Status:** \(task.taskStatus)")
                                .foregroundStyle(.secondary)
                            
                    Toggle("Schedule Notifications", isOn: $task.scheduleTime)
                }
                        
                TagsMenuView(task: task)
            }
                    
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                            
                    TextField("Description", text: $task.taskContent, prompt: Text("Enter the task description here"), axis: .vertical)
                }
            }
        }
        .disabled(task.isDeleted)
        .onSubmit(dataController.save)
        .onReceive(task.objectWillChange) { _ in
                    dataController.queueSave()
        }
        .toolbar {
            TaskViewToolbar(task: task)
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: .example)
            .environmentObject(DataController.preview)
    }
}
