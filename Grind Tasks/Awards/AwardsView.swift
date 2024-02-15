//
//  AwardView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 7/24/23.
//

import SwiftUI

struct AwardsView: View {
    @EnvironmentObject var dataController: DataController
    
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false
   
    @Environment(\.dismiss) private var dismiss
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(color(for: award))
                        }
                        .accessibilityLabel(
                            label(for: award)
                        )
                        .accessibilityHint(award.description)
                    }
                }
            }
            .navigationTitle("Awards")
            
            Button("Close") {
                dismiss()
            }
            .padding()
            
        }
        .alert(awardTitle, isPresented: $showingAwardDetails) {
        } message: {
            Text(selectedAward.description)
        }
        #if os(macOS)
        .frame(minWidth: 100, idealWidth: 500, maxWidth: 1000,
               minHeight: 100, idealHeight: 550, maxHeight: 1000,
               alignment: .center)
        #endif
    }
    
    var awardTitle: String {
        if dataController.hasEarned(award: selectedAward) {
            return "Unlocked: \(selectedAward.name)"
        } else {
            return "Locked: \(selectedAward.name)"
        }
    }
    
    func color(for award: Award) -> Color {
        dataController.hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5)
    }
    func label(for award: Award) -> LocalizedStringKey {
        dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked"
    }
}

struct AwardView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
            .environmentObject(DataController.preview)

    }
}
