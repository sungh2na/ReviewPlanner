# Local Notification

- Step 1: Ask for permission
``` Swift
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print(" User gave permissions for local notifications")
            }
        }
```

- Step 2: Create the notification content
```Swift
let content = UNMutableNotificationContent()
        content.title = "Notification on a certain date"
        content.body = "This is a local notification on certain date"
        content.sound = .default
        content.userInfo = ["value": "Data with local notification"]
```

- Step 3: Create the notification trigger
```Swift
var dateComponents = DateComponents()
        dateComponents.hour = 2
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
```

- Step 4: Create the request
```Swift
let request = UNNotificationRequest(identifier: "reminder" , content: content, trigger: trigger)
```

- Step 5: Register the request
```Swift
center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }

```
