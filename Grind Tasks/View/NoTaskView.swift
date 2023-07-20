//
//  NoTaskView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/19/23.
//

import SwiftUI

struct NoTaskView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        Text("No Task Selected")
            .font(.title)
            .foregroundStyle(.secondary)

        Button("Create Task") {
            // make a new issue
        }
    }
}

struct NoTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NoTaskView()
    }
}
