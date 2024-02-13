//
//  ThemeView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 2/12/24.
//

import SwiftUI
#if os(iOS)
struct ThemeView: View {
    @EnvironmentObject var dataController: DataController
    
    
    var body: some View {
        VStack {
            Text("Custom Theme")
                .font(.largeTitle)
                
            
                Divider()
                
            
            ColorPicker("Theme Color", selection: $dataController.storedColor)
                .padding(.horizontal)
                .font(.title2)
                
            
            ColorPicker("Second Color", selection: $dataController.storedColor2)
                .padding()
                .font(.title2)
                
        }
    }
}

#Preview {
    ThemeView()
        .environmentObject(DataController.preview)
}
#endif
