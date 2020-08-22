
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

    // MARK: Public

    /**
     Adds the class to the list of active observers.
     - Parameter observer: The object that is listening for the notification. Typically `self`.
     Must conform to the observer protocol.
     - Parameter event: The event the object is listening for.
     */
    public func addObserver(_ observer: Observer, for event: Event) -> ObserverToken {
        if var observers = observersForEvent(event)  {
            observers.append(observer)
            activeObservers[event] = observers
        } else {
            activeObservers[event] = [observer]
        }

        return ObserverToken(observer: observer, event: event)
    }

    /**
     Posts a notification with a specificed event. All classes that are listening for the event will be notified.
     - Parameter event: The event to post to all observers.
     */
    public func postNotification(with event: Event) {
        guard let observers = observersForEvent(event) else {
            return
        }

        for observer in observers {
            observer.didRecieveNotification(event: event)
        }
    }
    
    /**
     Removes a notification observer. Note that observers are automatically removed upon deinit.
     This means that classes must hold on to observation tokens outside of local scope to receive
     notifications.
     */
    public func removeObserver(_ observer: Observer, for event: Event) {
        guard var observers = observersForEvent(event) else {
            return
        }

        observers.removeAll { $0 === observer }
        
        if observers.isEmpty {
            activeObservers.removeValue(forKey: event)
        } else {
            activeObservers[event] = observers
        }
    }
    
    // MARK: Private
    
    private func observersForEvent(_ e: Event) -> [Observer]? {
        if let observers = activeObservers[e], observers.count > 0 {
            return observers
        }

        return nil
    }
}

final class ObserverToken {
    let observer: Observer
    let event: Event
    
    init(observer: Observer, event: Event) {
        self.observer = observer
        self.event = event
    }

    deinit {
        Notify.shared.removeObserver(observer, for: event)
    }
}

protocol Observer: AnyObject {
    func didRecieveNotification(event:Event)
}
