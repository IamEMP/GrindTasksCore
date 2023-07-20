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
                
                Menu {
                    // show selected tags first
                    ForEach(task.taskTags) { tag in
                        Button {
                            task.removeFromTags(tag)
                        } label: {
                            Label(tag.tagName, systemImage: "checkmark")
                        }
                    }

                    // now show unselected tags
                    let otherTags = dataController.missingTags(from: task)

                    if otherTags.isEmpty == false {
                        Divider()

                        Section("Add Tags") {
                            ForEach(otherTags) { tag in
                                Button(tag.tagName) {
                                    task.addToTags(tag)
                                }
                            }
                        }
                    }
                } label: {
                    Text(task.taskTagsList)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .animation(nil, value: task.taskTagsList)
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Information")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    TextField("Description", text: $task.taskContent, prompt: Text("Enter the issue description here"), axis: .vertical)
                }
            }
        }
        .disabled(task.isDeleted)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: .example)
            .environmentObject(DataController.preview)
    }
}
