//
//  ContentViewToolbar.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 8/13/23.
//

import SwiftUI

struct ContentViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    
    @Binding var showingThemes: Bool
    
    var body: some View {
        HStack {
            Button {
                showingThemes.toggle()
            } label: {
                Label("Themes", systemImage: "paintpalette")
            }
            
            Menu {
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
}

struct ContentViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewToolbar(showingThemes: .constant(true))
            .environmentObject(DataController.preview)
    }
}
