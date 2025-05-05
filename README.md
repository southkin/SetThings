# SetThings
>“Spend less time on setting screens. Spend more time on meaning.” — Aristotle

A lightweight, flexible preference/settings view builder for SwiftUI.
Supports text, numbers, switches, dates, pickers, custom views and nesting.
Runs on iOS and macOS

## ✨ Features
- Simple API, fully SwiftUI-native
- Supports grouped layout and sectioned form structure
- Built-in support for:
    - .text
    - .number
    - .bool
    - .date
    - .time
    - .dateAndTime
    - .password
    - .selectString
    - .color
    - .view
    - .block
    - .group
    - .section
- Live value updates via onEdited
- Supports custom views via .view or .block

## 📦 Installation
```swift
.package(url: "https://github.com/southpiece/SetThings.git", from: "1.0.0")
```

## 🚀 Usage
```swift
SetThings(items: [
    MinimalThingItem(
        key: "userID",
        name: "User ID",
        type: .text(placeholder: "Enter ID", defaultValue: "testUser")
    ),
    MinimalThingItem(
        key: "enable",
        name: "Enable",
        type: .bool(true)
    )
])
.onEdited { key, value in
    print("User changed \(key): \(String(describing: value))")
}
```

## 🧱 Available Types

| Type | Description |
| --- | --- |
| .text | Plain text input |
| .number | Decimal input (filtered) |
| .bool | Toggle switch |
| .password | Secure input |
| .selectString | Menu picker |
| .date | Date only (DateOnly) |
| .time | Time only (TimeOnly) |
| .dateAndTime | Full DatePicker |
| .color | Color picker |
| .view | Static view (no interactivity) |
| .block | Dynamic view with access to live values |
| .group | Indented group (can be nested) |
| .section | Section header (like a form section) |

## 📷 Screenshots
- iOS
    ![images](./images/ios.png)
- macOS
    ![images](./images/macos.png)
