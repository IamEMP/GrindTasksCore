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
    
    @State private var showingNotificationsError = false
    @Environment(\.openURL) var openURL
    
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField(
                        "Title",
                        text: $task.taskTitle,
                        prompt: Text("Enter the task title here")
                    )
                                .font(.title)
                            
                    DatePicker(
                        "Task due by",
                        selection: $task.taskAssignedDate)
                                .datePickerStyle(GraphicalDatePickerStyle()
                                )
                            
                    Text("**Status:** \(task.taskStatus)")
                                .foregroundStyle(.secondary)
                }
                        
                TagsMenuView(task: task)
            }
            
            Section("Reminders") {
                Toggle("Daily Notifications", isOn: $task.reminderEnabled.animation())
                
                if task.reminderEnabled {
                    DatePicker(
                        "Reminder time", selection: $task.taskReminderTime
                    )
                }
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
        .alert("Something's Wrong!", isPresented: $showingNotificationsError) {
            #if os(iOS)
            Button("Check Settings", action: showAppSettings)
            #elseif os(macOS)
            Text("To enable notifications for this app open settings > notifications > then toggle Grind Tasks to ON.")
            #endif
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("There was a problem setting your notification. Please make sure you have notifications enabled.")
        }
        .onChange(of: task.reminderEnabled) {
            updateReminder()
        }
        .onChange(of: task.reminderTime) {
            updateReminder()
        }
    }
#if os(iOS)
    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openNotificationSettingsURLString) else {
            return
        }
        
        openURL(settingsURL)
    } #endif
    
    func updateReminder() {
        dataController.removeReminders(for: task)
        
        Task { @MainActor in
            if task.reminderEnabled {
                let success = await dataController.addReminder(for: task)
                
                if success == false {
                    task.reminderEnabled = false
                    showingNotificationsError = true
                }
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(task: .example)
            .environmentObject(DataController.preview)
    }
}
