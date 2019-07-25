//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport


typealias RegisteredItem = (object: AnyObject, action: (String)->Void)


class FunkyNotificationCenter {
    
    /**
     The default FunkyNotificationCenter singleton
     */
    static var defaultCenter = FunkyNotificationCenter()
    
    private var registeredItems = [String:[RegisteredItem]]()
    
    /**
     Add the given observer object to the notification name. When the given notification name
     is posted, the given `using` closure should be executed.
     
     - Parameters:
     - forName: The notification name the object is observing
     - object: The observer object that is requesting to listen to the notification
     - using: Closure to be executed when the notification is posted
     */
    func add(forName name: String, object: AnyObject, using: @escaping (String) -> Void) {
        let item: RegisteredItem = (object: object, action: using)
        if var items = registeredItems[name] {
            // TODO: -  come back to this
            items.append(item)
            registeredItems[name] = items
        }
        else {
            registeredItems[name] = [item]
        }
        print("in add")
    }
    
    /**
     Post a notification with the given name.
     
     - Parameters:
     - name: The notification to post
     */
   func post(name: String) {
        if let items = registeredItems[name] {
            for item in items {
                print(item)
                let action = item.action
                action(name)
            print(name)
            }
            
        }
        print("post")
    }
 
    /**
     Remove the observer object from the given notification name
     
     - Parameters:
     - forName: The notification name the object is observing
     - object: The observer object that is requesting to no longer listen to the notification
     */
    func remove(forName name: String, object: AnyObject) {
        if let items = registeredItems[name] {
            var temp = [RegisteredItem]()
            for item in items {
                if !(item.object === object) {
                    temp.append(item)
                }
            }
            registeredItems[name] = temp
        }
    }
    
}




/*******************************************************************************
 Example Usage
 *******************************************************************************/

class SomeObject {
}

let center = FunkyNotificationCenter.defaultCenter

let objectA = SomeObject()


center.add(forName: "notificationEvent1", object: objectA) { _ in
    print("Object A Event 1 happened")
}
center.add(forName: "notificationEvent2", object: objectA) { _ in
    print("Object A Event 2 happened")
}

let objectB = SomeObject()
center.add(forName: "notificationEvent2", object: objectB) { _ in
    print("Object B Event 2 happened")
}
center.add(forName: "notificationEvent3", object: objectB) { _ in
    print("Object B Event 3 happened")
}

let objectC = SomeObject()
center.add(forName: "notificationEvent3", object: objectC) { _ in
    print("Object C Event 3 happened")
}
center.add(forName: "notificationEvent1", object: objectC) { _ in
    print("Object C Event 1 happened")
}

print("Before remove Object C Event 1")
center.post(name: "notificationEvent1")

center.remove(forName: "notificationEvent1", object: objectC)
print("After remove Object C Event 1")
center.post(name: "notificationEvent1")

/*
 Desired output:
 
 Before remove Object C Event 1
 Object A Event 1 happened
 Object C Event 1 happened
 After remove Object C Event 1
 Object A Event 1 happened
 */
