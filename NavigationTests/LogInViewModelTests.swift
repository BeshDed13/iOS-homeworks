//
//  LogInViewModelTests.swift
//  NavigationTests
//
//  Created by Дмитрий Ильинский on 10.03.2026.
//

import XCTest
import FirebaseAuth
@testable import Navigation

final class LogInViewModelTests: XCTestCase {
    
    var viewModel: LogInViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = LogInViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testUserNotFoundError() {
        let error = NSError(
            domain: AuthErrorDomain,
            code: AuthErrorCode.userNotFound.rawValue
        )
        let message = viewModel.handleAuthError(error)
        
        XCTAssertEqual(message, "alert_user_not_found".localized)
    }
    
    func testWrongPasswordError() {
        let error = NSError(
            domain: AuthErrorDomain,
            code: AuthErrorCode.wrongPassword.rawValue
        )
        let message = viewModel.handleAuthError(error)
        
        XCTAssertEqual(message, "alert_wrong_password".localized)
    }
    
    func testUnknownError() {
        let error = NSError(domain: "unknown", code: 123)
        let message = viewModel.handleAuthError(error)
        
        XCTAssertEqual(message, error.localizedDescription)
    }
}
