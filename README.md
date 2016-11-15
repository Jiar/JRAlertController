# JRAlertController
Based on Apple's UIAlertController control API, rebuilt it with swift, JRAlertController is more in line with mainstream style of the APP.

![JRAlertController](https://raw.githubusercontent.com/Jiar/JRAlertController/master/JR_clear.png)

## Screenshot

### JRAlertController

##### JRAlertController_Main
![JRAlertController_alert_simple](https://raw.githubusercontent.com/Jiar/JRAlertController/master/Screenshot/JRAlertController_Main.gif)

##### JRAlertController_alert_simple
![JRAlertController_alert_simple](https://raw.githubusercontent.com/Jiar/JRAlertController/master/Screenshot/JRAlertController_alert_simple.gif)

##### JRAlertController_alert_multiple
![JRAlertController_alert_multiple](https://raw.githubusercontent.com/Jiar/JRAlertController/master/Screenshot/JRAlertController_alert_multiple.gif)

##### JRAlertController_sheet_simple
![JRAlertController_sheet_simple](https://raw.githubusercontent.com/Jiar/JRAlertController/master/Screenshot/JRAlertController_sheet_simple.gif)

##### JRAlertController_sheet_multiple
![JRAlertController_sheet_multiple](https://raw.githubusercontent.com/Jiar/JRAlertController/master/Screenshot/JRAlertController_sheet_multiple.gif)

### UIAlertController

##### UIAlertController_alert_simple
![UIAlertController_alert_simple](https://raw.githubusercontent.com/Jiar/JRAlertController/master/Screenshot/UIAlertController_alert_simple.gif)

##### UIAlertController_alert_multiple
![UIAlertController_alert_multiple](https://raw.githubusercontent.com/Jiar/JRAlertController/master/Screenshot/UIAlertController_alert_multiple.gif)

##### UIAlertController_sheet_simple
![UIAlertController_sheet_simple](https://raw.githubusercontent.com/Jiar/JRAlertController/master/Screenshot/UIAlertController_sheet_simple.gif)

##### UIAlertController_sheet_multiple
![UIAlertController_sheet_multiple](https://raw.githubusercontent.com/Jiar/JRAlertController/master/Screenshot/UIAlertController_sheet_multiple.gif)


## Requirements

- iOS 8.0+
- Xcode 8.0+
- Swift 3.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build JRAlertController 1.0.0

To integrate JRAlertController into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'JRAlertController', '~> 1.0.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate JRAlertController into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
$ git init
```

- Add JRAlertController as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
$ git submodule add https://github.com/Jiar/JRAlertController.git
```

- Open the new `JRAlertController` folder, and drag the `JRAlertController.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `JRAlertController.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `JRAlertController.xcodeproj` folders each with two different versions of the `JRAlertController.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `JRAlertController.framework`.

- Select the top `JRAlertController.framework` for iOS.
- And that's it!

  > The `JRAlertController.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

---

## Usage

#### JRAlertController_alert_simple
```swift
        let alertController = JRAlertController(title: "login tip", message: "please input account and password", preferredStyle: .alert)
        let cancelAction = JRAlertAction(title: "cancel", style: .cancel, handler:  {
            (action: JRAlertAction!) -> Void in
            print("cancel")
        })
        let loginAction = JRAlertAction(title: "login", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("login")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(loginAction)
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.keyboardType = .default
            textField.placeholder = "please input account"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.keyboardType = .default
            textField.isSecureTextEntry = true
            textField.placeholder = "please input password"
        })
        // must use this function to show JRAlertController
        // self is a UIControllerView
        alertController.jr_show(onRootView: self)
```

#### JRAlertController_alert_multiple
```swift
        let alertController = JRAlertController(title: "I am title,I am title,I am title,I am title,I am title", message: "I am message, I am message, I am message, I am message, I am message, I am message, I am message, I am message, I am message", preferredStyle: .alert)
        let cancelAction = JRAlertAction(title: "cancel", style: .cancel, handler:  {
            (action: JRAlertAction!) -> Void in
            print("cancel")
        })
        let deleteAction = JRAlertAction(title: "delete", style: .destructive, handler: {
            (action: JRAlertAction!) -> Void in
            print("delete")
        })
        let archiveAction = JRAlertAction(title: "archive", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive")
        })
        let archiveAction1 = JRAlertAction(title: "archive1", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive1")
        })
        let archiveAction2 = JRAlertAction(title: "archive2", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive2")
        })
        let archiveAction3 = JRAlertAction(title: "archive3", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive3")
        })
        let archiveAction4 = JRAlertAction(title: "archive4", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive4")
        })
        let archiveAction5 = JRAlertAction(title: "archive5", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive5")
        })
        let archiveAction6 = JRAlertAction(title: "archive6", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive6")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .black
            textField.text = "black"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .darkGray
            textField.text = "darkGray"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .lightGray
            textField.text = "lightGray"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.backgroundColor = .black
            textField.textColor = .white
            textField.text = "white"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .gray
            textField.text = "gray"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .red
            textField.text = "red"
        })
        alertController.addAction(archiveAction1)
        alertController.addAction(archiveAction2)
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .green
            textField.text = "green"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .blue
            textField.text = "blue"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .cyan
            textField.text = "cyan"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .yellow
            textField.text = "yellow"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .magenta
            textField.text = "magenta"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .orange
            textField.text = "orange"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .purple
            textField.text = "purple"
        })
        alertController.addTextField(configurationHandler: { (textField: UITextField) -> Void in
            textField.textColor = .brown
            textField.text = "brown"
        })
        alertController.addAction(archiveAction3)
        alertController.addAction(archiveAction4)
        alertController.addAction(archiveAction5)
        alertController.addAction(archiveAction6)
        alertController.preferredAction  = archiveAction6
        // must use this function to show JRAlertController
        // self is a UIControllerView
        alertController.jr_show(onRootView: self)
```

#### JRAlertController_sheet_simple
```swift
        let alertController = JRAlertController(title: "blog tip", message: "Please select the option to use the corresponding option to operate your blog", preferredStyle: .actionSheet)
		// let alertController = JRAlertController(title: "blog tip")
		// let alertController = JRAlertController(message: "Please select the option to use the corresponding option to operate your blog")
		// let alertController = JRAlertController()
        let addAction = JRAlertAction(title: "add", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("add blog")
        })
        let modifyAction = JRAlertAction(title: "modify", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("modify blog")
        })
        let deleteAction = JRAlertAction(title: "delete", style: .destructive, handler: {
            (action: JRAlertAction!) -> Void in
            print("delete blog")
        })
        let cancelAction = JRAlertAction(title: "cancel", style: .cancel, handler:  {
            (action: JRAlertAction!) -> Void in
            print("cancel")
        })
        alertController.addAction(addAction)
        alertController.addAction(modifyAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        // must use this function to show JRAlertController
        // self is a UIControllerView
        alertController.jr_show(onRootView: self)
```

#### JRAlertController_sheet_multiple
```swift
        let alertController = JRAlertController(title: "I am title,I am title,I am title,I am title,I am title", message: "I am message, I am message, I am message, I am message, I am message, I am message, I am message, I am message, I am message", preferredStyle: .actionSheet)
        let cancelAction = JRAlertAction(title: "cancel", style: .cancel, handler: nil)
        let deleteAction = JRAlertAction(title: "delete", style: .destructive, handler: nil)
        let archiveAction = JRAlertAction(title: "archive", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive")
        })
        let archiveAction1 = JRAlertAction(title: "archive1", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive1")
        })
        let archiveAction2 = JRAlertAction(title: "archive2", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive2")
        })
        let archiveAction3 = JRAlertAction(title: "archive3", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive3")
        })
        let archiveAction4 = JRAlertAction(title: "archive4", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive4")
        })
        let archiveAction5 = JRAlertAction(title: "archive5", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive5")
        })
        let archiveAction6 = JRAlertAction(title: "archive6", style: .default, handler: {
            (action: JRAlertAction!) -> Void in
            print("archive6")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        alertController.addAction(archiveAction1)
        alertController.addAction(archiveAction2)
        alertController.addAction(archiveAction3)
        alertController.addAction(archiveAction4)
        alertController.addAction(archiveAction5)
        alertController.addAction(archiveAction6)
        // must use this function to show JRAlertController
        // self is a UIControllerView
        alertController.jr_show(onRootView: self)
```


## License

JRAlertController is released under the Apache-2.0 license. See LICENSE for details.