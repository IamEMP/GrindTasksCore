//
//  SidebarView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/14/23.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController
    let smartFilters: [Filter] = [.all, .recent]
    
    @State private var tagToRename: Tag?
    @State private var renamingTag = false
    @State private var tagName = ""
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
    var tagFilters: [Filter] {
        tags.map { tag in
            Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
        }
    }
    
    var body: some View {
                List(selection: $dataController.selectedFilter) {
                    Section("Filters") {
                        ForEach(smartFilters) { filter in
                            NavigationLink(value: filter) {
                                Label(filter.name, systemImage: filter.icon)
                            }
                        }
                    }
                    .listRowBackground(Color(.systemBlue).opacity(0.4))
                    Section("Tags") {
                        ForEach(tagFilters) { filter in
                            NavigationLink(value: filter) {
                                Label(filter.name, systemImage: filter.icon)
                                    .badge(filter.tag?.tagActiveTasks.count ?? 0)
                
                                    .contextMenu {
                                        Button {
                                            rename(filter)
                                        } label: {
                                            Label("Rename", systemImage: "pencil")
                                        }
                                    }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .listRowBackground(Color(.systemBlue).opacity(0.4))
                    
                }
                .toolbar {
                    Button(action: dataController.newTag) {
                        Label("Add tag", systemImage: "plus")
                    }
                    #if DEBUG
                    Button {
                        dataController.deleteAll()
                        dataController.createSampleData()
                    } label: {
                        Label("ADD SAMPLES", systemImage: "flame")
                    }
                    #endif
                }
                .alert("Rename tag", isPresented: $renamingTag) {
                    Button("OK", action: completeRename)
                    Button("Cancel", role: .cancel) { }
                    TextField("New name", text: $tagName)
                }
            }
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tags[offset]
            dataController.delete(item)
        }
    }
    
    func rename(_ filter: Filter) {
        tagToRename = filter.tag
        tagName = filter.name
        renamingTag = true
    }
    
    func completeRename() {
        tagToRename?.name = tagName
        dataController.save()
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
            .environmentObject(DataController.preview)
    }
}
