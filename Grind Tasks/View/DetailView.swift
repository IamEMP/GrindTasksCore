//
//  DetailView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/14/23.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        VStack {
            if let task = dataController.selectedTask {
                TaskView(task: task)
            } else {
                NoTaskView()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
            .environmentObject(DataController.preview)
    }
}
