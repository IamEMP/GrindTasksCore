//
//  SidebarView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/14/23.
//

import SwiftUI
import RealityKit

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController
    let smartFilters: [Filter] = [.all, .recent]
    
    @State private var tagToRename: Tag?
    @State private var renamingTag = false
    @State private var tagName = ""
    @State private var showingAwards = false
    @State private var tasks: TaskItem?

    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
    var tagFilters: [Filter] {
        tags.map { tag in
            Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
        }
    }
    
    var body: some View {
                List(selection: $dataController.selectedFilter) {
                    Section("Filters") {
                            ForEach(smartFilters, content: SmartFilterRow.init)
                    }
#if os(iOS)
                    .listRowBackground(Color(.systemBlue).opacity(0.4))
#endif
                    Section("Tags") {
                        ForEach(tagFilters) { filter in
                           UserFilterRow(filter: filter, rename: rename, delete: delete)
                        }
                        .onDelete(perform: delete)
                    }
#if os(iOS)
                    .listRowBackground(Color(.systemBlue).opacity(0.4))
#endif
                }
                .toolbar {
                        SidebarViewToolbar(showingAwards: $showingAwards)
                }
                .alert("Rename tag", isPresented: $renamingTag) {
                    Button("OK", action: completeRename)
                    Button("Cancel", role: .cancel) { }
                    TextField("New name", text: $tagName)
                }
                .sheet(isPresented: $showingAwards, content: AwardsView.init)
                .navigationTitle("Filters")
            }
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tags[offset]
            dataController.delete(item)
        }
    }
    
    func delete(_ filter: Filter) {
        guard let tag = filter.tag else { return }
        dataController.delete(tag)
        dataController.save()
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
