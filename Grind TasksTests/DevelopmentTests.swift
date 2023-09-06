//
//  DevelopmentTests.swift
//  Grind TasksTests
//
//  Created by Ethan Phillips on 8/28/23.
//

import CoreData
import XCTest
@testable import Grind_Tasks

final class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() {
        dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 5, "There should be 5 sample tags.")
        XCTAssertEqual(dataController.count(for: TaskItem.fetchRequest()), 50, "There should be 50 sample tasks.")
    }
    
    func testDeleteAllClearsEverything() {
        dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 0, "deleteAll() should leave 0 tags.")
        XCTAssertEqual(dataController.count(for: TaskItem.fetchRequest()), 0, "deleteAll() should leave 0 issues.")
    }
    func testExampleTagHasNoTasks() {
        let tag = Tag.example
        XCTAssertEqual(tag.tasks?.count, 0, "The example tag should have 0 issues.")
    }
}
