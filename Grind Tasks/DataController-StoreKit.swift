//
//  DataController-StoreKit.swift
//  Grind Tasks
//
//  Created by Ethan Phillips on 1/24/24.
//

import Foundation
import StoreKit

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
}
