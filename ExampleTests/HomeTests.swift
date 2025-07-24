//
//  ViperitTests.swift
//  ViperitTests
//
//  Created by Ferran on 17/09/2016.
//  Copyright © 2016 Ferran Abelló. All rights reserved.
//

@testable import Example
import Viperit
import XCTest

class HomeMockView: UserInterface, HomeViewInterface {
    
    //TEST PROPERTIES
    var expectation: XCTestExpectation!
    var expectedMessage: String!
    
    func showInfo(message: String) {
        print("EXPECTED MESSAGE : \(expectedMessage!)")
        XCTAssert(message == expectedMessage)
        expectation.fulfill()
    }
    
    func showLoading() {
        //
    }
}

struct HomeMockModuleComponents {
    let view: HomeMockView
    let presenter: HomePresenter
}

@MainActor
class HomeTests: XCTestCase, Sendable {

    private(set) var mockModuleComponents: HomeMockModuleComponents!

    override func setUp() async throws {
        try await super.setUp()
        await buildMockComponents()
    }

    private func buildMockComponents() async {
        var mod = AppModules.home.build()
        mockModuleComponents = .init(view: HomeMockView(), presenter: (mod.presenter as? HomePresenter)!)
        mockModuleComponents.view.expectation = expectation(description: "Test expectation description")
        mod.injectMock(view: mockModuleComponents.view)
    }

    func expect(timeout: TimeInterval = 5, errorMessage: String = "TIMEOUT") {
        waitForExpectations(timeout: 5) { error in
            guard error != nil else { return }
            XCTFail(errorMessage)
        }
    }

    func testShowInfo1() {
        print("---RUNNING TEST1---")
        mockModuleComponents.view.expectedMessage = "CONTENT_LOADED"
        mockModuleComponents.presenter.loadContent()
        expect()
    }

    func testShowInfo2() {
        print("---RUNNING TEST2---")
        mockModuleComponents.view.expectedMessage = "CONTENT_LOADED"
        mockModuleComponents.presenter.loadContent()
        expect()
    }
}
