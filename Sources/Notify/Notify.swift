
typealias Event = String

final class Notify {

    /**
        The objects that are currently listening for notifications, grouped by Event.
     */
    private(set) public var activeObservers = [Event: [Observer]]()

    static let shared: Notify = {
        let notify = Notify()
        return notify
    }()
    
    private init() {}

    // MARK: Public Methods

    public func addObserver(_ observer: Observer,
                                   for event: Event) {
        if var existingObservers = activeObservers[event] {
            existingObservers.append(observer)
            activeObservers[event] = existingObservers
        } else {
            activeObservers[event] = [observer]
        }
    }
    
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


/// Whenever a notification is posted, we want to
/// either iterate through all of our observers to see if they match, and then notify.
/// OR, we hold a Dictionary of [Event: [Observer]]


/// Features:
/// obversers are automatically removed on dealloc
