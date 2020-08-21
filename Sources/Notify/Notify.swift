
typealias Event = String

final class Notify {
    /**
     Holds objects that are currently listening for notifications, grouped by Event.
     */
    private(set) public var activeObservers = [Event: [Observer]]()

    static let shared: Notify = {
        let notify = Notify()
        return notify
    }()
    
    private init() {}

    // MARK: Public Methods

    /**
     Adds the class to the list of active observers.
     - Parameter observer: The object that is listening for the notification. Typically `self`.
     Must conform to the observer protocol.
     - Parameter event: The event the object is listening for.
     */
    public func addObserver(_ observer: Observer,
                                   for event: Event) {
        if var existingObservers = activeObservers[event] {
            existingObservers.append(observer)
            activeObservers[event] = existingObservers
        } else {
            activeObservers[event] = [observer]
        }
    }

    /**
     Posts a notification with a specificed event. All classes that are listening for the event will be notified.
     - Parameter event: The event to post to all observers.
     */
    public func postNotification(with event: Event) {
        // If there are no active observers for the posted
        // event, return immediately.
        guard let observers = activeObservers[event] else {
            return
        }

        for observer in observers {
            observer.didRecieveNotification(event: event)
        }
    }
}

protocol Observer {
    func didRecieveNotification(event:Event)
}
