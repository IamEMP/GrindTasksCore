//
//  ContentView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/12/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    @State private var showingThemes = false
    
    var body: some View {
        ZStack {
            
            VStack {
                List(selection: $dataController.selectedTask) {
                    ForEach(dataController.taskforSelectedFilter()) { task in
                        TaskRowView(tasks: task)
                    }
                    .onDelete(perform: delete)
#if os(iOS)
                    .listRowBackground(LinearGradient(colors: [dataController.storedColor, dataController.storedColor2,], startPoint: .topLeading, endPoint: .bottomTrailing))
                   // .listRowBackground(Color(dataController.storedColor))
                    .listRowInsets(.init(top: 15, leading: 15, bottom: 15, trailing: 15))
                    .listRowSpacing(20)
                    .listRowSeparatorTint(.white, edges: .all)
#endif
                }
#if os(iOS)
                .listStyle(.insetGrouped)
#endif
                Button(action: dataController.newTask) {
                    Label("New Task", systemImage: "plus")
                }
                .tint(.lightBlue)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .shadow(radius: 20)
                .controlSize(.extraLarge)
                
                .navigationTitle("Tasks")
                .searchable(text: $dataController.filterText,
                            tokens: $dataController.filterTokens,
                            suggestedTokens: .constant(dataController.suggestedFilterTokens),
                            prompt: "Search tasks...") { tag in
                    Text(tag.tagName)
                }
                #if os(iOS)
                            .sheet(isPresented: $showingThemes, content: ThemeView.init)
                #endif
                
#if os(macOS) || os(iOS)
                            .toolbar {
                                ContentViewToolbar.init(showingThemes: $showingThemes)
                            }
#else
                            .ornament(attachmentAnchor: .scene(.top)) {
                                ContentViewToolbar.init()
                                    .glassBackgroundEffect()
                            }
#endif
            }
            .background(.ultraThinMaterial.opacity(1))
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
