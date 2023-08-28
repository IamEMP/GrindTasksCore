//
//  AwardsTest.swift
//  Grind TasksTests
//
//  Created by Ethan Phillips on 8/28/23.
//

import CoreData
import XCTest
@testable import Grind_Tasks

final class AwardsTest: BaseTestCase {
    let awards = Award.allAwards
    
    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
        }
    }
    
    func testNewUserHasUnlockedNoAwards() {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards")
        }
    }
    
    func testCreatingTasksUnlocksAwards() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {
            var tasks = [TaskItem]()

            for _ in 0..<value {
                let task = TaskItem(context: managedObjectContext)
                tasks.append(task)
            }

            let matches = awards.filter { award in
                award.criterion == "tasks" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Adding \(value) tasks should unlock \(count + 1) awards.")

            dataController.deleteAll()
        }
    }
    
    func testClosedTasksUnlocksAwards() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000, 100000]

        for (count, value) in values.enumerated() {
            var tasks = [TaskItem]()

            for _ in 0..<value {
                let task = TaskItem(context: managedObjectContext)
                task.completed = true
                tasks.append(task)
            }

            let matches = awards.filter { award in
                award.criterion == "completed" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Completing \(value) tasks should unlock \(count + 1) awards.")

            dataController.deleteAll()
        }
    }
}
