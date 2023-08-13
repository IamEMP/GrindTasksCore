//
//  UserFilterRow.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 8/13/23.
//

import SwiftUI

struct UserFilterRow: View {
    var filter: Filter
    var rename: (Filter) -> Void
    var delete: (Filter) -> Void
    
    var body: some View {
        NavigationLink(value: filter) {
            Label(filter.name, systemImage: filter.icon)
                .badge(filter.activeTasksCount)

                .contextMenu {
                    Button {
                        rename(filter)
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        delete(filter)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .accessibilityElement()
                .accessibilityLabel(filter.name)
                .accessibilityHint("\(filter.activeTasksCount) tasks")
        }
    }
}

struct UserFilterRow_Previews: PreviewProvider {
    static var previews: some View {
        UserFilterRow(filter:.all, rename: { _ in }, delete: { _ in })
    }
}
