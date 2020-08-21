import UIKit
import XCTest
@testable import Notify

final class NotifyTests: XCTestCase {
    
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
        let eventName = "Test"
        let n = Notify.shared
        
        n.addObserver(mockViewController, for: eventName)
    
        XCTAssertNotNil(n.activeObservers[eventName])
    }
    
    func testPostNotification() {
        let mockViewController = MockViewController()
        let n = Notify.shared
        let eventName = "Test"

        n.addObserver(mockViewController, for: eventName)
        n.postNotification(with: eventName)
        XCTAssert(mockViewController.eventReceived == true)
    }
}
