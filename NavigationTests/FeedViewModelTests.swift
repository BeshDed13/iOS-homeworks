//
//  FeedViewModelTests.swift
//  NavigationTests
//
//  Created by Дмитрий Ильинский on 10.03.2026.
//

import XCTest
@testable import Navigation

final class FeedViewModelTests: XCTestCase {
    
    var viewModel: FeedViewModel!
    var result: Bool?
    
    override func setUp() {
        super.setUp()
        viewModel = FeedViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        result = nil
        super.tearDown()
    }
    
    func testCheckWordCorrect() {
        let expectation = expectation(description: "Correct word")
        
        viewModel.onResult = { value in
            self.result = value
            expectation.fulfill()
        }
        
        viewModel.checkWord("Secret word")
        waitForExpectations(timeout: 1)
        
        XCTAssertTrue(result ?? false)
        }
    
    func testCheckWordIncorrect() {
        let expectation = expectation(description: "Incorrect word")
        
        viewModel.onResult = { value in
            self.result = value
            expectation.fulfill()
        }
        
        viewModel.checkWord("incorrect")
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse(result ?? true)
    }
    
    func testCheckWordEmpty() {
        let expectation = expectation(description: "Empty word")
        
        viewModel.onResult = { value in
            self.result = value
            expectation.fulfill()
        }
        
        viewModel.checkWord("")
        waitForExpectations(timeout: 1)
        
        XCTAssertFalse(result ?? true)
    }
}
