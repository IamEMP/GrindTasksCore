//
//  StoreView.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 1/26/24.
//

import SwiftUI
import StoreKit

struct StoreView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    @State private var products = [Product]()
    
    var body: some View {
        NavigationStack {
            if let product = products.first {
                VStack(alignment: .center) {
                    Text(product.displayName)
                        .font(.title)
                    
                    Text(product.description)
                    
                    Button("Buy Now") {
                        purchase(product)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .padding()
                }
            }
        }
        .onChange(of: dataController.fullVersionUnlocked) {
            checkForPurchase()
        }
        .task {
            await load()
        }
    }
    
    func checkForPurchase() {
        if dataController.fullVersionUnlocked {
            dismiss()
        }
    }
    
    func purchase(_ product: Product) {
        Task { @MainActor in
            try await dataController.purchase(product)
        }
    }
    
    func load() async {
        do {
            products = try await Product.products(for: [DataController.proUnlockProductID])
        } catch {
            print("Failed to load products: \(error.localizedDescription)")
        }
    }
}

#Preview {
    StoreView()
        .environmentObject(DataController.preview)
}
