//
//  TagsMenuView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 8/13/23.
//

import SwiftUI

struct TagsMenuView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var task: TaskItem
    
    var body: some View {
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
}

struct TagsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TagsMenuView(task: TaskItem.example)
            .environmentObject(DataController.preview)
    }
}
