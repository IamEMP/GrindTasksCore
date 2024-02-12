//
//  ThemeView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 2/12/24.
//

import SwiftUI

struct ThemeView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        ColorPicker("Theme Color", selection: $dataController.themeColor)
        
            .padding(100)
        
        Button("Save") {
            
        }
        .buttonBorderShape(.capsule)
        .buttonStyle(.borderedProminent)
    }
    

    

}

#Preview {
    ThemeView()
        .environmentObject(DataController.preview)
}
