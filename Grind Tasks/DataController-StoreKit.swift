//
//  DataController-StoreKit.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 1/24/24.
//

import Foundation
import StoreKit

/*
 extension DataController {
 /// Product ID for unlocking the pro version of the app.
 static let proUnlockProductID = "com.ethanphillips.GrindTasksCore.proUnlock"
 
 // Loads and saves when the pro version is purchased.
 var fullVersionUnlocked: Bool {
 get {
 defaults.bool(forKey: "fullVersionUnlocked")
 }
 set {
 defaults.set(newValue, forKey: "fullVersionUnlocked")
 }
 }
 
 func monitorTransaction() async {
 // Check for previous purchases.
 for await entitlement in Transaction.currentEntitlements {
 if case let .verified(transaction) = entitlement {
 await finalize(transaction)
 }
 }
 
 // watch for future transactions coming in.
 for await update in Transaction.updates {
 if let transaction = try? update.payloadValue {
 await finalize(transaction)
 }
 }
 }
 #if os(macOS) || os(iOS)
 func purchase(_ product: Product) async throws {
 let result = try await product.purchase()
 
 if case let .success(validation) = result {
 try await finalize(validation.payloadValue)
 }
 }
 #endif
 
 @MainActor
 func finalize(_ transaction: Transaction) async {
 if transaction.productID == Self.proUnlockProductID {
 objectWillChange.send()
 fullVersionUnlocked = transaction.revocationDate == nil
 await transaction.finish()
 }
 }
 
 }
 */
