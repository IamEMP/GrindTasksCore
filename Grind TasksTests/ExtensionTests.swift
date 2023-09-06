//
//  ExtensionTests.swift
//  Grind TasksTests
//
//  Created by Ethan Phillips on 8/29/23.
//

import CoreData
import XCTest
@testable import Grind_Tasks

final class ExtensionTests: BaseTestCase {
    func testTaskTitleUnwrap() {
        let task = TaskItem(context: managedObjectContext)

        task.title = "Example task"
        XCTAssertEqual(task.taskTitle, "Example task", "Changing title should also change taskTitle.")

        task.taskTitle = "Updated task"
        XCTAssertEqual(task.title, "Updated task", "Changing taskTitle should also change title.")
    }
    
    func testTaskContentUnwrap() {
        let task = TaskItem(context: managedObjectContext)

        task.content = "Example task"
        XCTAssertEqual(task.taskContent, "Example task", "Changing content should also change taskContent.")

        task.taskContent = "Updated task"
        XCTAssertEqual(task.content, "Updated task", "Changing taskContent should also change content.")
    }
    func testTaskTagsUnwrap() {
        let tag = Tag(context: managedObjectContext)
        let task = TaskItem(context: managedObjectContext)

        XCTAssertEqual(task.taskTags.count, 0, "A new task should have no tags.")
        task.addToTags(tag)

        XCTAssertEqual(task.taskTags.count, 1, "Adding 1 tag to a task should result in taskTags having count 1.")
    }

    func testIssueTagsList() {
        let tag = Tag(context: managedObjectContext)
        let task = TaskItem(context: managedObjectContext)

        tag.name = "My Tag"
        task.addToTags(tag)

        XCTAssertEqual(task.taskTagsList, "My Tag", "Adding 1 tag to an task should make taskTagsList be My Tag.")
    }
}
