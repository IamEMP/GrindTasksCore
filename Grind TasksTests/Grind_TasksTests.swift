//
//  Grind_TasksTests.swift
//  Grind TasksTests
//
//  Created by Ethan Phillips on 8/23/23.
//

import XCTest
import CoreData
@testable import Grind_Tasks

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
