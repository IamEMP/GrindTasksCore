//
//  Grind_TasksApp.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/12/23.
//

import SwiftUI

@main
struct Grind_TasksApp: App {
    @StateObject var dataController = DataController()
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            
            NavigationSplitView {
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .onChange(of: scenePhase) { phase in
                if phase != .active {
                    dataController.save()
                }
            }
            
        }
    }
}
