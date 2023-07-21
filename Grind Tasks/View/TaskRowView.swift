//
//  TaskRowView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/17/23.
//

import SwiftUI

struct TaskRowView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var tasks: TaskItem
    @State private var isPastAssignedDate = false
    
    var body: some View {
        NavigationLink(value: tasks) {
            HStack {
                
                if isPastAssignedDate {
                    Image(systemName: "exclamationmark.circle")
                        .imageScale(.large)
                } else {
                    Image(systemName: "exclamationmark.circle")
                        .imageScale(.large)
                        .opacity(0)
                }

                
                    
                VStack(alignment: .leading) {
                    Text(tasks.taskTitle)
                        .font(.headline)
                        .lineLimit(1)

                    Text(tasks.taskTagsList)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text(tasks.taskAssignedDate.formatted(date: .numeric, time: .shortened))
                        .font(.subheadline)

                    if tasks.completed {
                        Text("Completed")
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
            
        }
        .onAppear {
            let currentDate = Date()
            isPastAssignedDate = currentDate > tasks.taskAssignedDate
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(tasks: .example)
        
    }
}
