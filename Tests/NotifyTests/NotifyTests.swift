import UIKit
import XCTest
@testable import Notify

final class NotifyTests: XCTestCase {
    
    let eventName = "Test"
    
    class MockViewController: UIViewController, Observer {
        var eventReceived = false
        func didRecieveNotification(event: Event) {
            eventReceived = true
        }
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAddObserver() {
        let mockViewController = MockViewController()
        let n = Notify.shared
        
        let token = n.addObserver(mockViewController, for: eventName)

        XCTAssert(n.activeObservers[eventName]?.first === mockViewController)
        XCTAssert(token.observer === mockViewController)
        XCTAssert(token.event == eventName)
    }
    
    func testPostNotification() {
        let mockViewController = MockViewController()
        let n = Notify.shared
        let token = n.addObserver(mockViewController, for: eventName)

        n.postNotification(with: eventName)

        XCTAssert(mockViewController.eventReceived == true)
        XCTAssert(token.observer === mockViewController)
    }
    
    func testRemoveObserver() {
        let mockViewController = MockViewController()
        let n = Notify.shared
        let token = n.addObserver(mockViewController, for: eventName)
        
        n.removeObserver(mockViewController, for: eventName)

        XCTAssert(n.activeObservers.isEmpty)
        XCTAssert(token.observer === mockViewController)
    }
    
    func testRemoveObserverDeinit() {
        let mockViewController: MockViewController? = MockViewController()
        let n = Notify.shared
        var token: ObserverToken? = n.addObserver(mockViewController!, for: eventName)

        XCTAssert(n.activeObservers[eventName]?.first === mockViewController)
        XCTAssert(token?.observer === mockViewController)
        
        token = nil

        XCTAssert(n.activeObservers.isEmpty)
    }
}
