//
//  TagTests.swift
//  Grind TasksTests
//
//  Created by Ethan Phillips on 8/28/23.
//
import CoreData
import XCTest
@testable import Grind_Tasks

final class TagTests: BaseTestCase {
    func testCreatingTagsandTasks() {
        let count = 10
        
        for _ in 0..<count {
            let tag = Tag(context: managedObjectContext)
            
            for _ in 0..<count {
                let task = TaskItem(context: managedObjectContext)
                tag.addToTasks(task)
            }
        }
        
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), count, "Expected \(count) tags.")
        XCTAssertEqual(dataController.count(for: TaskItem.fetchRequest()), count * count, "Expected \(count * count) tags.")
    }
    
    func testDeletingTagDoesNotDeleteTasks() throws {
        dataController.createSampleData()
        
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        let tags = try managedObjectContext.fetch(request)
        
        dataController.delete(tags[0])
        
        XCTAssertEqual(dataController.count(for: Tag.fetchRequest()), 4, "Expected 4 tags after deleting 1.")
        XCTAssertEqual(dataController.count(for: TaskItem.fetchRequest()), 50, "Expected 50 tasks after deleting a tag.")
    }
}
