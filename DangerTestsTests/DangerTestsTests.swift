//
//  DangerTestsTests.swift
//  DangerTestsTests
//
//  Created by Philipp Schmid on 04.08.22.
//

import XCTest
@testable import DangerTests

class DangerTestsTests: XCTestCase {

    func testExample() throws {
        let service = ExampleService()
        service.bar()
    }

    func testFoo() throws {
        let service = ExampleService()
        service.foo()
    }
}
