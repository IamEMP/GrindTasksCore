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
#if os(iOS)
                    .listRowBackground(Color(.systemBlue).opacity(0.4))
#endif
                }
#if os(iOS)
                .listStyle(.insetGrouped)
#endif
                .navigationTitle("Tasks")
                .searchable(text: $dataController.filterText,
                            tokens: $dataController.filterTokens,
                            suggestedTokens: .constant(dataController.suggestedFilterTokens),
                            prompt: "Search tasks...") { tag in
                    Text(tag.tagName)
                }
                .toolbar(content: ContentViewToolbar.init)
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
