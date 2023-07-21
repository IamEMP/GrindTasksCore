//
//  ContentView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/12/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
 
                List(selection: $dataController.selectedTask) {
                    ForEach(dataController.taskforSelectedFilter()) { task in
                        TaskRowView(tasks: task)
                    }
                    .onDelete(perform: delete)
                    .listRowBackground(Color(.systemBlue).opacity(0.4))

                }
                .listStyle(.insetGrouped)
        
                .navigationTitle("Tasks")
                .searchable(text: $dataController.filterText, tokens: $dataController.filterTokens, suggestedTokens: .constant(dataController.suggestedFilterTokens), prompt: "Search tasks, or type # to filter by tags") { tag in
                    Text(tag.tagName)
                }
        
                .toolbar {
                    Menu {
                        Button(dataController.filterEnabled ? "Turn Filter Off" : "Turn Filter On") {
                            dataController.filterEnabled.toggle()
                            
                        }
                        Divider()

                        Picker("Status", selection: $dataController.filterStatus) {
                            Text("All").tag(Status.all)
                            Text("Incomplete").tag(Status.incomplete)
                            Text("Completed").tag(Status.completed)
                        }

                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                            .symbolVariant(dataController.filterEnabled ? .fill : .none)
                    }
                }
            }
    
    func delete(_ offsets: IndexSet) {
        let tasks = dataController.taskforSelectedFilter()
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
