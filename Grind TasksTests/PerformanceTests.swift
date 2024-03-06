//
//  PerformanceTests.swift
//  Grind TasksTests
//
//  Created by Ethan Phillips on 9/6/23.
//

import XCTest
@testable import Grind_Tasks

final class PerformanceTests: BaseTestCase {
    func testAwardCalculationPerformance() {
        // Create a significant amount of test data
        for _ in 1...100 {
            
        }
        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 575, "This checks the awards count is constant. Change this if you add awards.")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}
