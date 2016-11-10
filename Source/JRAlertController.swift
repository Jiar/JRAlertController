//
//  JRAlertController.swift
//  JRAlertController
//
//  Created by Jiar on 2016/11/2.
//  Copyright © 2016年 Jiar. All rights reserved.
//

import Foundation
import UIKit

/// Styles to apply to action buttons in an alert.
public enum JRAlertActionStyle : Int {
    
    case `default`
    case cancel
    case destructive
    
}

/// Constants indicating the type of alert to display.
public enum JRAlertControllerStyle : Int {
    
    case actionSheet
    case alert
    
}

/// A JRAlertAction object represents an action that can be taken when tapping a button in an alert. You use this class to configure information about a single action, including the title to display in the button, any styling information, and a handler to execute when the user taps the button. After creating an alert action object, add it to a JRAlertController object before displaying the corresponding alert to the user.
open class JRAlertAction : NSObject, NSCopying {
    
    private var _title: String?
    private var _style: JRAlertActionStyle = .default
    fileprivate var _handler: ((JRAlertAction) -> Swift.Void)?
    fileprivate var _isPreferredAction: Bool = false
    
    private override init() {
        super.init()
    }
    
    /// Create and return an action with the specified title and behavior.
    /// Actions are enabled by default when you create them.
    /// - Parameter title:
    /// The text to use for the button title. The value you specify should be localized for the user’s current language. This parameter must not be nil, except in a tvOS app where a nil title may be used with cancel.
    /// - Parameter style:
    /// Additional styling information to apply to the button. Use the style information to convey the type of action that is performed by the button. For a list of possible values, see the constants in UIAlertActionStyle.
    /// - Parameter handler:
    /// A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
    /// - Returns
    /// A new alert action object.
    public convenience init(title: String?, style: JRAlertActionStyle, handler: ((JRAlertAction) -> Swift.Void)? = nil) {
        self.init()
        self._title = title
        self._style = style
        self._handler = handler
    }
    
    /// The title of the action’s button.
    /// This property is set to the value you specified in the init(title:style:handler:) method.
    open var title: String? {
        get {
            return self._title
        }
    }
    
    /// The style that is applied to the action’s button.
    /// This property is set to the value you specified in the init(title:style:handler:) method.
    open var style: JRAlertActionStyle {
        get {
            return self._style
        }
    }
    
    /// A Boolean value indicating whether the action is currently enabled.
    /// The default value of this property is true. Changing the value to false causes the action to appear dimmed in the resulting alert. When an action is disabled, taps on the corresponding button have no effect.
    open var isEnabled: Bool = true
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let title = self._title
        let style = self._style
        let handler = self._handler
        return JRAlertAction(title: title, style: style, handler: handler)
    }
    
}

/// A JRAlertController object displays an alert message to the user. This class replaces the JRActionSheet and JRAlertView classes for displaying alerts. After configuring the alert controller with the actions and style you want, present it using the present(_:animated:completion:) method.
///
/// In addition to displaying a message to a user, you can associate actions with your alert controller to give the user a way to respond. For each action you add using the addAction(_:) method, the alert controller configures a button with the action details. When the user taps that action, the alert controller executes the block you provided when creating the action object. Listing 1 shows how to configure an alert with a single action.
/// ## Listing 1
/// ##### Configuring and presenting an alert
/// ```
/// let alertController = JRAlertController(title: "title",
///                                         message: "message",
///                                         preferredStyle: .actionSheet)
///
/// let addAction = JRAlertAction(title: "Add", style: .default, handler: {
///     (action: JRAlertAction!) -> Void in
///     print("Add")
/// })
/// let deleteAction = JRAlertAction(title: "Delete", style: .destructive, handler: {
///     (action: JRAlertAction!) -> Void in
///     print("Delete")
/// })
/// let cancelAction = JRAlertAction(title: "Cancel", style: .cancel, handler: {
///     (action: JRAlertAction!) -> Void in
///     print("Cancel")
/// })
/// alertController.addAction(addAction)
/// alertController.addAction(deleteAction)
/// alertController.addAction(cancelAction)
/// alertController.jr_show(onRootView: self)
/// ```
/// When configuring an alert with the alert style, you can also add text fields to the alert interface. The alert controller lets you provide a block for configuring your text fields prior to display. The alert controller maintains a reference to each text field so that you can access its value later.
open class JRAlertController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    /**************************** open api -start ****************************/
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overCurrentContext
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .overCurrentContext
    }
    
    /// Creates and returns a view controller for displaying an alert to the user.
    /// After creating the alert controller, configure any actions that you want the user to be able to perform by calling the addAction(_:) method one or more times. When specifying a preferred style of alert, you may also configure one or more text fields to display in addition to the actions.
    /// - Parameter title:
    /// The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    /// - Parameter message:
    /// Descriptive text that provides additional details about the reason for the alert.
    /// - Parameter preferredStyle:
    /// The style to use when presenting the alert controller. Use this parameter to configure the alert controller as an action sheet or as a modal alert.
    /// - Returns
    /// An initialized alert controller object.
    public convenience init(title: String? = nil, message: String? = nil, preferredStyle: JRAlertControllerStyle = .actionSheet) {
        self.init()
        self._title = title
        self._message = message
        self._preferredStyle = preferredStyle
    }
    
    /// Attaches an action object to the alert or action sheet.
    /// If your alert has multiple actions, the order in which you add those actions determines their order in the resulting alert or action sheet.
    /// - Parameter action:
    /// The action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
    open func addAction(_ action: JRAlertAction) {
        assert(_haveAddCancel == false || action.style != .cancel, "Have added action that the style is cancel")
        if let _ = _actions {
            
        } else {
            _actions = []
        }
        if action.style == .cancel {
            _haveAddCancel = true
            _cancelAction = action
            _cancelActionIndex = _actions?.count
        }
        _actions?.append(action)
    }
    
    /// The actions that the user can take in response to the alert or action sheet.
    ///
    /// The actions are in the order in which you added them to the alert controller. This order also corresponds to the order in which they are displayed in the alert or action sheet. The second action in the array is displayed below the first, the third is displayed below the second, and so on.
    open var actions: [JRAlertAction] {
        get {
            if let actions = _actions {
                return actions
            } else {
                return []
            }
        }
    }
    
    /// The preferred action for the user to take from an alert.
    ///
    /// The preferred action is relevant for the alert style only; it is not used by action sheets. When you specify a preferred action, the alert controller highlights the text of that action to give it emphasis. (If the alert also contains a cancel button, the preferred action receives the highlighting instead of the cancel button.) If the iOS device is connected to a physical keyboard, pressing the Return key triggers the preferred action.
    ///
    /// The action object you assign to this property must have already been added to the alert controller’s list of actions. Assigning an object to this property before adding it with the addAction(_:) method is a programmer error.
    ///
    /// The default value of this property is nil.
    open var preferredAction: JRAlertAction? {
        set {
            assert(_preferredStyle == .alert, "The 'preferredStyle' property must be alert.")
            self._preferredAction = newValue
            if let actions = _actions {
                if let newValue = newValue {
                    let index = actions.index(of: newValue)
                    if let index = index {
                        let action = actions[index]
                        action._isPreferredAction = true
                        _actions?[index] = action
                    }
                }
            }
        }
        get {
            return self._preferredAction
        }
    }
    
    /// Adds a text field to an alert.
    ///
    /// Calling this method adds an editable text field to the alert. You can call this method more than once to add additional text fields. The text fields are stacked in the resulting alert.
    ///
    /// You can add a text field only if the preferredStyle property is set to alert.
    ///
    /// - Parameter configurationHandler: A block for configuring the text field prior to displaying the alert. This block has no return value and takes a single parameter corresponding to the text field object. Use that parameter to change the text field properties.
    open func addTextField(configurationHandler: ((UITextField) -> Swift.Void)? = nil) {
        assert(_preferredStyle == .alert, "The 'preferredStyle' property must be alert.")
        if let _ = _textFields {
            
        } else {
            _textFields = []
        }
        let textField = UITextField.init()
        textField.delegate = self
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .darkText
        if let textFields = _textFields {
            if textFields.count == 0 {
                textField.becomeFirstResponder()
            } else {
                let lastTextField = textFields[textFields.count-1]
                lastTextField.returnKeyType = .next
            }
        }
        if let configurationHandler = configurationHandler {
            configurationHandler(textField)
        }
        _textFields?.append(textField)
    }
    
    /// The array of text fields displayed by the alert.
    ///
    /// Use this property to access the text fields displayed by the alert. The text fields are in the order in which you added them to the alert controller. This order also corresponds to the order in which they are displayed in the alert.
    open var textFields: [UITextField]? {
        get {
            return self._textFields
        }
    }
    
    /// The title of the alert.
    ///
    /// The title string is displayed prominently in the alert or action sheet. You should use this string to get the user’s attention and communicate the reason for displaying the alert.
    open override var title: String? {
        set {
            self._title = newValue
        }
        get {
            return self._title
        }
    }
    
    /// Descriptive text that provides more details about the reason for the alert.
    ///
    /// The message string is displayed below the title string and is less prominent. Use this string to provide additional context about the reason for the alert or about the actions that the user might take.
    open var message: String? {
        set {
            self._message = newValue
        }
        get {
            return self._message
        }
    }
    
    /// The style of the alert controller.
    ///
    /// The value of this property is set to the value you specified in the init(title:message:preferredStyle:) method. This value determines how the alert is displayed onscreen.
    open var preferredStyle: JRAlertControllerStyle {
        get {
            return self._preferredStyle
        }
    }
    
    /// Use this function to show the ViewController
    public func jr_show(onRootView rootView:UIViewController) {
        rootView.present(self, animated: false, completion: nil)
    }
    
    /// Use this function to dissmiss the ViewController
    public func jr_dismiss() {
        self.dismiss(animated: false, completion: nil)
    }
    
    /**************************** open api -end ****************************/
    
    
    /**************************** private var -start ****************************/
    
    private var _title: String?
    private var _message: String?
    private var _preferredStyle: JRAlertControllerStyle = .actionSheet
    private var _actions: Array<JRAlertAction>?
    private var _preferredAction: JRAlertAction?
    private var _textFields: Array<UITextField>?
    
    /********************************************************/
    
    private var _haveAddCancel = false
    private var _cancelAction: JRAlertAction?
    private var _cancelActionIndex: Int?
    
    /********************************************************/
    
    private var _cancelGesture: UITapGestureRecognizer!
    private var _resignGesture: UITapGestureRecognizer!
    
    /********************************************************/
    
    private var _openTextField: UITextField?
    private var _changeKeep: Bool = false
    private var _oldShowViewY: Double?
    private var _keyboardHeight: Double?
    
    /**************************** private var -end ****************************/
    
    
    /**************************** achieve func -start ****************************/
    
    private let DivideHeight:Double = 4
    private let tableView:UITableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    private let showView:UIView = UIView.init()
    private var titleLable:UILabel?
    private var messageLabel:UILabel?
    private var cutLine: UIView?
    private var cancelbtn: UIButton?
    
    deinit {
        //Removing notification observers on dealloc.
        _openTextField = nil
        _oldShowViewY = nil
        _keyboardHeight = nil
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        initShowView()
        initCancelGesture()
        initResignGesture()
        initRegistering()
    }
    
    private func initShowView() {
        let topBottom = initTop()
        let tableBottom = initTable(topBottom)
        let showViewHeight = initBottom(tableBottom)
        switch preferredStyle {
        case .actionSheet:
            showView.frame = CGRect.init(x: 0, y: DeviceHeight()-showViewHeight, width: DeviceWidth(), height: showViewHeight)
            break
        case .alert:
            showView.frame = CGRect.init(x: (DeviceWidth()-MAXWidth())/2, y: (DeviceHeight()-showViewHeight)/2, width: MAXWidth(), height: showViewHeight)
            showView.layer.masksToBounds = true
            break
        }
        showView.backgroundColor = .white
        view.addSubview(showView)
    }
    
    private func initTop() -> Double {
        var topHeight: Double = 0
        var haveTitle = false
        var haveMessage = false
        if let title = _title {
            switch preferredStyle {
            case .actionSheet:
                titleLable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: DeviceWidth(), height: 44))
                break
            case .alert:
                titleLable = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: MAXWidth(), height: 44))
                break
            }
            titleLable!.backgroundColor = .white
            titleLable!.font = UIFont.boldSystemFont(ofSize: 15)
            titleLable!.textColor = .darkGray
            titleLable!.textAlignment = .center
            titleLable!.text = title
            showView.addSubview(titleLable!)
            topHeight = titleLable!.bottom()
            haveTitle = true
        }
        if let message = _message {
            let font = UIFont.systemFont(ofSize: 12)
            var width:Double
            switch preferredStyle {
            case .actionSheet:
                width = DeviceWidth()
                break
            case .alert:
                width = MAXWidth()
                break
            }
            var messageLabelHeight = message.height(withFont: font, fixedWidth: width)
            if messageLabelHeight > MAXHeight()/8 {
                messageLabelHeight = MAXHeight()/8
            }
            var y:Double = 0
            if let titleLable = titleLable {
                y = titleLable.bottom()
            }
            if !haveTitle {
                messageLabelHeight += 24
            }
            messageLabel = UILabel.init(frame: CGRect.init(x: 0, y: y, width: width, height: messageLabelHeight))
            messageLabel!.backgroundColor = .white
            messageLabel!.numberOfLines = 0
            messageLabel!.layer.borderWidth = 0
            messageLabel!.layer.masksToBounds = true
            messageLabel!.font = font
            messageLabel!.textColor = .lightGray
            messageLabel!.textAlignment = .center
            messageLabel!.text = message
            messageLabel!.fixBlackLine()
            showView.addSubview(messageLabel!)
            topHeight = messageLabel!.bottom()
            haveMessage = true
        }
        if haveTitle && haveMessage {
            topHeight += 12
        }
        return topHeight
    }
    
    private func initTable(_ y: Double) -> Double {
        var actionsCount = self.actions.count
        if _haveAddCancel {
            actionsCount -= 1
        }
        switch preferredStyle {
        case .actionSheet:
            let tableHeight = Double(actionsCount)*JRAlertControllerCellRowHeight(byStyle: .action)
            tableView.frame = CGRect.init(x: 0, y: y, width: DeviceWidth(), height: tableHeight)
            break
        case .alert:
            var textFieldsCount = 0
            if let textFields = _textFields {
                textFieldsCount = textFields.count
            }
            let tableHeight = Double(actionsCount)*JRAlertControllerCellRowHeight(byStyle: .action)+Double(textFieldsCount)*JRAlertControllerCellRowHeight(byStyle: .textField)
            tableView.frame = CGRect.init(x: 0, y: y, width: MAXWidth(), height: tableHeight)
            break
        }
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        showView.addSubview(tableView)
        return tableView.bottom()
    }
    
    private func initBottom(_ y: Double) -> Double {
        var showViewHeight: Double
        if _haveAddCancel {
            switch preferredStyle {
            case .actionSheet:
                cutLine = UIView.init(frame: CGRect.init(x: 0, y: y, width: DeviceWidth(), height: 6))
                break
            case .alert:
                cutLine = UIView.init(frame: CGRect.init(x: 0, y: y, width: MAXWidth(), height: 6))
                break
            }
            cutLine!.backgroundColor = RGBA(r: 240, g: 240, b: 240)
            showView.addSubview(cutLine!)
            switch preferredStyle {
            case .actionSheet:
                cancelbtn = UIButton.init(frame: CGRect.init(x: 0, y: cutLine!.bottom(), width: DeviceWidth(), height: JRAlertControllerCellRowHeight(byStyle: .action)))
                break
            case .alert:
                cancelbtn = UIButton.init(frame: CGRect.init(x: 0, y: cutLine!.bottom(), width: MAXWidth(), height: JRAlertControllerCellRowHeight(byStyle: .action)))
                break
            }
            cancelbtn!.backgroundColor = .white
            cancelbtn!.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            cancelbtn!.setTitleColor(.darkGray, for: .normal)
            cancelbtn!.setTitle(_cancelAction!.title, for: .normal)
            cancelbtn!.addTarget(self, action: #selector(highlightedAction), for: .touchDown)
            cancelbtn!.addTarget(self, action: #selector(normalAction), for: .touchUpOutside)
            cancelbtn!.addTarget(self, action: #selector(normalAction), for: .touchCancel)
            cancelbtn!.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            showView.addSubview(cancelbtn!)
            showViewHeight = cancelbtn!.bottom()
        } else {
            showViewHeight = y
        }
        if showViewHeight > MAXHeight() {
            tableView.isScrollEnabled = true
            showViewHeight = MAXHeight()
            if _haveAddCancel {
                tableView.bottom(showViewHeight-cutLine!.height()-cancelbtn!.height(), keepHeight: false)
                cutLine!.top(tableView.bottom())
                cancelbtn!.top(cutLine!.bottom())
            } else {
                tableView.bottom(MAXHeight(), keepHeight: false)
            }
        } else {
            tableView.isScrollEnabled = false
        }
        return showViewHeight
    }
    
    internal func highlightedAction() {
        cancelbtn?.backgroundColor = RGBA(r: 217, g: 217, b: 217)
    }
    
    internal func normalAction() {
        cancelbtn?.backgroundColor = .white
    }
    
    internal func cancelAction() {
        cancelbtn?.backgroundColor = .white
        if let action = _cancelAction {
            if let handler = action._handler {
                handler(action)
            }
        }
        loadDisappearAnimation()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAppearAnimation()
    }
    
    private func loadAppearAnimation() {
        switch preferredStyle {
        case .actionSheet:
            view.backgroundColor = RGBA(r: 255, g: 255, b: 255, a: 0)
            showView.y(DeviceHeight())
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
                if UIApplication.shared.statusBarFrame.height == 40 {
                    // open HOTSPOT
                    self.showView.y(DeviceHeight()-self.showView.height()-20)
                } else {
                    self.showView.y(DeviceHeight()-self.showView.height())
                }
            })
            break
        case .alert:
            view.backgroundColor = RGBA(r: 255, g: 255, b: 255, a: 0)
            showView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: { 
                self.view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
                self.showView.alpha = 1
            })
            break
        }
    }
    
    private func loadDisappearAnimation() {
        switch preferredStyle {
        case .actionSheet:
            view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.backgroundColor = RGBA(r: 255, g: 255, b: 255, a: 0)
                self.showView.y(DeviceHeight())
            }, completion: { (finish) in
                if finish {
                    self.jr_dismiss()
                }
            })
            break
        case .alert:
            view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
            showView.alpha = 1
            UIView.animate(withDuration: 0.3, animations: {
                self.showView.alpha = 0
                self.view.backgroundColor = RGBA(r: 255, g: 255, b: 255, a: 0)
            }, completion: { (finish) in
                if finish {
                    self.jr_dismiss()
                }
            })
            break
        }
    }
    
    private func initCancelGesture() {
        _cancelGesture = UITapGestureRecognizer.init(target: self, action: #selector(cancelAction))
        _cancelGesture.delegate = self
        view.addGestureRecognizer(_cancelGesture)
    }
    
    private func initResignGesture() {
        _resignGesture = UITapGestureRecognizer.init(target: self, action: #selector(resignAction))
        _resignGesture.delegate = self
        showView.addGestureRecognizer(_resignGesture)
    }
        
    internal func resignAction() {
        if let textField = _openTextField {
            textField.resignFirstResponder()
        }
    }
    
    // MARK - UIGestureRecognizerDelegate
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == _cancelGesture {
            if touch.view == showView || touch.view!.isKind(of: NSClassFromString("UITableViewCellContentView")!) || touch.view!.isKind(of: NSClassFromString("UITableView")!) {
                return false
            }
        } else if gestureRecognizer == _resignGesture {
            if touch.view!.isKind(of: NSClassFromString("UITableViewCellContentView")!) || touch.view!.isKind(of: NSClassFromString("UITableView")!) || touch.view!.isKind(of: NSClassFromString("UITextField")!) {
                return false
            }
        }
        return true
    }
    
    /*
     * The following annotation comes from IQKeyboardManager(https://github.com/hackiftekhar/IQKeyboardManager)
     *
     ------------------------------------------------------------
     When UITextField become first responder
     ------------------------------------------------------------
     - UITextFieldTextDidBeginEditingNotification (UITextField)
     - UIKeyboardWillShowNotification
     - UIKeyboardDidShowNotification
     
     ------------------------------------------------------------
     When switching focus from UITextField to another UITextField
     ------------------------------------------------------------
     - UITextFieldTextDidEndEditingNotification (UITextField1)
     - UITextFieldTextDidBeginEditingNotification (UITextField2)
     - UIKeyboardWillShowNotification
     - UIKeyboardDidShowNotification
     
     ------------------------------------------------------------
     On orientation change
     ------------------------------------------------------------
     - UIApplicationWillChangeStatusBarOrientationNotification
     - UIKeyboardWillHideNotification
     - UIKeyboardDidHideNotification
     - UIApplicationDidChangeStatusBarOrientationNotification
     - UIKeyboardWillShowNotification
     - UIKeyboardDidShowNotification
     - UIKeyboardWillShowNotification
     - UIKeyboardDidShowNotification
     
     */
    private func initRegistering() {
        switch preferredStyle {
        case .actionSheet:
            break
        case .alert:
            _oldShowViewY = showView.y()
            // Registering for UITextField notification.
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldViewDidBeginEditing(_:)), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.textFieldViewDidEndEditing(_:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
            // Registering for keyboard notification.
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)),                name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)),                name: NSNotification.Name.UIKeyboardDidShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)),                name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(_:)),                name: NSNotification.Name.UIKeyboardDidHide, object: nil)
            break
        }
        //  Registering for orientation changes notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.willChangeStatusBarOrientation(_:)),          name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation, object: UIApplication.shared)
        //  Registering for status bar frame change notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeStatusBarFrame(_:)),          name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: UIApplication.shared)
        // Registering for orientation notification.
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    /**
     * Flow For Screen Rotation
     *
     
     — #IF Horizontal Vertical Switch (ChangeStatusBar)
     —      1.willChangeStatusBarOrientation
     —      2.didChangeStatusBarFrame(Do nothing)
     — #ELSE
     —      3.keyboardWillHide
     —      4.keyboardDidHide(Do nothing)
     —      5.deviceOrientationDidChange
     —      6.tableView.reloadData()
     —              #IF the _openTextField is not nil
     —                  7.keyboardWillHide
     —                      #IF textField.becomeFirstResponder()
     —                          9.keyboardWillShow
     —                          10.keyboardDidShow(Do nothing)
     —                  8.keyboardDidHide(Do nothing)
     
     *
     */
    
    internal func textFieldViewDidBeginEditing(_ notification:Notification) {
        if let textField = notification.object as? UITextField {
            _openTextField = textField
        }
    }
    
    internal func textFieldViewDidEndEditing(_ notification:Notification) {
        
    }
    
    internal func keyboardWillShow(_ notification : Notification?) -> Void {
        if let info = (notification as NSNotification?)?.userInfo {
            if let kbFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                _keyboardHeight = Double(kbFrame.height)
                let deviceHeight = DeviceHeight()
                let space = deviceHeight-showView.height()-_keyboardHeight!
                if space > 0 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.showView.y(space/2)
                    })
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        if let cancelbtn = self.cancelbtn {
                            self.showView.y(-(self.showView.height()-cancelbtn.height()+self._keyboardHeight!-deviceHeight))
                        } else {
                            self.showView.y(-(self.showView.height()+self._keyboardHeight!-deviceHeight))
                        }
                    })
                }
            }
        }
    }
    
    internal func keyboardDidShow(_ notification : Notification?) -> Void {
        
    }
    
    internal func keyboardWillHide(_ notification : Notification?) -> Void {
        if _changeKeep {
            _changeKeep = false
            if let showViewY = _oldShowViewY {
                UIView.animate(withDuration: 0.2, animations: {
                    self.showView.y(showViewY)
                }, completion: { (finish) in
                    if finish {
                        if let textField = self._openTextField {
                            if let textFields = self._textFields {
                                let index = textFields.index(of: textField)
                                if let index = index {
                                    if self.tableView.isScrollEnabled {
                                        self.tableView.scrollToRow(at: IndexPath.init(row: index, section: 0), at: .none, animated: false)
                                    }
                                    // will call keyboardWillShow
                                    textField.becomeFirstResponder()
                                }
                            }
                        }
                    }
                })
            }
        } else {
            _openTextField = nil
            if let showViewY = _oldShowViewY {
                UIView.animate(withDuration: 0.2, animations: {
                    self.showView.y(showViewY)
                })
            }
        }
        
    }
    
    internal func keyboardDidHide(_ notification:Notification) {
        
    }
    
    internal func willChangeStatusBarOrientation(_ notification:Notification) {
        if let _ = _openTextField {
            _changeKeep = true
        }
    }
    
    internal func didChangeStatusBarFrame(_ notification : Notification?) -> Void {
        
    }
    
    internal func deviceOrientationDidChange(_ interfaceOrientation: UIInterfaceOrientation) {
        reloadFrame()
    }
    
    private func reloadFrame() {
        var topHeight: Double = 0
        var haveTitle = false
        var haveMessage = false
        if let _ = _title {
            switch preferredStyle {
            case .actionSheet:
                titleLable!.width(DeviceWidth())
                break
            case .alert:
                titleLable!.width(MAXWidth())
                break
            }
            topHeight = titleLable!.bottom()
            haveTitle = true
        }
        if let message = _message {
            var width:Double
            switch preferredStyle {
            case .actionSheet:
                width = DeviceWidth()
                break
            case .alert:
                width = MAXWidth()
                break
            }
            var messageLabelHeight = message.height(withFont: messageLabel!.font, fixedWidth: width)
            if messageLabelHeight > MAXHeight()/8 {
                messageLabelHeight = MAXHeight()/8
            }
            if !haveTitle {
                messageLabelHeight += 24
            }
            messageLabel!.width(width)
            messageLabel!.height(messageLabelHeight)
            messageLabel!.fixBlackLine()
            topHeight = messageLabel!.bottom()
            haveMessage = true
        }
        if haveTitle && haveMessage {
            topHeight += 12
        }
        let tableTop = topHeight
        
        var actionsCount = self.actions.count
        if _haveAddCancel {
            actionsCount -= 1
        }
        switch preferredStyle {
        case .actionSheet:
            let tableHeight = Double(actionsCount)*JRAlertControllerCellRowHeight(byStyle: .action)
            tableView.frame = CGRect.init(x: 0, y: tableTop, width: DeviceWidth(), height: tableHeight)
            break
        case .alert:
            var textFieldsCount = 0
            if let textFields = _textFields {
                textFieldsCount = textFields.count
            }
            let tableHeight = Double(actionsCount)*JRAlertControllerCellRowHeight(byStyle: .action)+Double(textFieldsCount)*JRAlertControllerCellRowHeight(byStyle: .textField)
            tableView.frame = CGRect.init(x: 0, y: tableTop, width: MAXWidth(), height: tableHeight)
            break
        }
        let tableBottom = tableView.bottom()
        
        var showViewHeight: Double
        if _haveAddCancel {
            switch preferredStyle {
            case .actionSheet:
                cutLine!.y(tableBottom)
                cutLine!.width(DeviceWidth())
                break
            case .alert:
                cutLine!.y(tableBottom)
                cutLine!.width(MAXWidth())
                break
            }
            switch preferredStyle {
            case .actionSheet:
                cancelbtn!.y(cutLine!.bottom())
                cancelbtn!.width(DeviceWidth())
                break
            case .alert:
                cancelbtn!.y(cutLine!.bottom())
                cancelbtn!.width(MAXWidth())
                break
            }
            showViewHeight = cancelbtn!.bottom()
        } else {
            showViewHeight = tableBottom
        }
        if showViewHeight > MAXHeight() {
            tableView.isScrollEnabled = true
            showViewHeight = MAXHeight()
            if _haveAddCancel {
                tableView.bottom(showViewHeight-cutLine!.height()-cancelbtn!.height(), keepHeight: false)
                cutLine!.top(tableView.bottom())
                cancelbtn!.top(cutLine!.bottom())
            } else {
                tableView.bottom(MAXHeight(), keepHeight: false)
            }
        } else {
            tableView.isScrollEnabled = false
        }
        
        switch preferredStyle {
        case .actionSheet:
            showView.frame = CGRect.init(x: 0, y: DeviceHeight()-showViewHeight, width: DeviceWidth(), height: showViewHeight)
            if UIApplication.shared.statusBarFrame.height == 40 {
                // open HOTSPOT
                self.showView.y(DeviceHeight()-self.showView.height()-20)
            } else {
                self.showView.y(DeviceHeight()-self.showView.height())
            }
            break
        case .alert:
            showView.frame = CGRect.init(x: (DeviceWidth()-MAXWidth())/2, y: (DeviceHeight()-showViewHeight)/2, width: MAXWidth(), height: showViewHeight)
            break
        }
        _oldShowViewY = showView.y()
        if let _ = _openTextField {
            _changeKeep = true
        }
        // It will hide keyboard, if exist textField that is responder
        tableView.reloadData()
    }
    
    // MARK - UITextFieldDelegate
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textFields = _textFields {
            let index = textFields.index(of: textField)
            if let index = index {
                if index == textFields.count-1 {
                    // last one
                    if let preferredAction = _preferredAction {
                        if let handler = preferredAction._handler {
                            handler(preferredAction)
                        }
                    }
                    let tempTextField = textFields[index]
                    tempTextField.resignFirstResponder()
                    jr_dismiss()
                } else {
                    if tableView.isScrollEnabled {
                        tableView.scrollToRow(at: IndexPath.init(row: index+1, section: 0), at: .none, animated: true)
                    }
                    let tempTextField = textFields[index+1]
                    tempTextField.becomeFirstResponder()
                }
            }
        }
        return true
    }
    
    // MARK - UITableViewDelegate, UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let textFields = _textFields {
            count += textFields.count
        }
        if let actions = _actions {
            count += actions.count
            if _haveAddCancel {
                count -= 1
            }
        }
        return count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if let textFields = textFields {
            if row < textFields.count {
                return CGFloat(JRAlertControllerCellRowHeight(byStyle: .textField))
            } else {
                return CGFloat(JRAlertControllerCellRowHeight(byStyle: .action))
            }
        }
        return CGFloat(JRAlertControllerCellRowHeight(byStyle: .action))
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cell:JRAlertControllerCell?
        var style:JRAlertControllerCell.JRAlertControllerCellStyle = .action
        if let textFields = _textFields {
            if row < textFields.count {
                style = .textField
            }
        }
        let identifier = JRAlertControllerCellReuseIdentifier(byStyle: style)
        switch style {
        case .action:
            var textFieldsCount = 0
            if let textFields = _textFields {
                textFieldsCount = textFields.count
            }
            if let actions = _actions {
                var index = row-textFieldsCount
                if _haveAddCancel {
                    if index >= _cancelActionIndex! {
                        index += 1
                    }
                }
                let action = actions[index]
                if let tempCell = tableView.dequeueReusableCell(withIdentifier: identifier) {
                    cell = tempCell as? JRAlertControllerCell
                } else {
                    tableView.register(NSClassFromString("JRAlertControllerCell"), forCellReuseIdentifier: identifier)
                    cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? JRAlertControllerCell
                    cell = JRAlertControllerCell.init(style: style, action: action)
                }
                cell?.load(action: action, style2: preferredStyle)
            }
            break
        case .textField:
            if let textFields = _textFields {
                let textField = textFields[row]
                textField.frame = CGRect.init(x: 8, y: 6, width: MAXWidth()-16, height: JRAlertControllerCellRowHeight(byStyle: .textField)-12)
                _textFields?[row] = textField
                cell = JRAlertControllerCell.init(style: style, textField: textField)
                cell?.accessoryType = .none
                cell?.selectionStyle = .none
            }
            break
        }
        cell?.preservesSuperviewLayoutMargins = false
        cell?.layoutMargins = UIEdgeInsets.zero
        cell?.separatorInset = UIEdgeInsets.zero
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let textFields = _textFields {
            if row < textFields.count {
                return
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        var textFieldsCount = 0
        if let textFields = _textFields {
            textFieldsCount = textFields.count
        }
        if let actions = _actions {
            var index = row-textFieldsCount
            if _haveAddCancel {
                if index >= _cancelActionIndex! {
                    index += 1
                }
            }
            let action = actions[index]
            if let handler = action._handler {
                handler(action)
            }
        }
        loadDisappearAnimation()
    }
    
    /**************************** achieve func -end ****************************/
    
}

class JRAlertControllerCell : UITableViewCell {

    public enum JRAlertControllerCellStyle : String {
        case action
        case textField
    }
    
    private var _jr_style: JRAlertControllerCellStyle = .action
    private var _jr_action: JRAlertAction?
    private var _jr_textField: UITextField?
    private var _jr_label: UILabel?
    
    public var jr_style: JRAlertControllerCellStyle {
        get {
            return _jr_style
        }
    }
    
    public var jr_action: JRAlertAction? {
        get {
            return _jr_action
        }
    }
    
    public var jr_textField: UITextField? {
        get {
            return _jr_textField
        }
    }
    
    public var jr_rowHeight: Double {
        get {
            return JRAlertControllerCellRowHeight(byStyle: _jr_style)
        }
    }
    
    public init(style: JRAlertControllerCellStyle, action:JRAlertAction? = nil, textField:UITextField? = nil) {
        super.init(style: .default, reuseIdentifier: JRAlertControllerCellReuseIdentifier(byStyle: style))
        accessoryType = .none
        selectionStyle = .default
        _jr_style = style
        _jr_action = action
        _jr_textField = textField
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func load(action: JRAlertAction, style2: JRAlertControllerStyle = .actionSheet) {
        if let label = _jr_label {
            switch style2 {
            case .actionSheet:
                _jr_label?.frame = CGRect.init(x: 0.0, y: 0.0, width: DeviceWidth(), height: jr_rowHeight)
                break
            case .alert:
                _jr_label?.frame = CGRect.init(x: 0.0, y: 0.0, width: MAXWidth(), height: jr_rowHeight)
                break
            }
            switch action.style {
            case .default:
                _jr_label!.font = UIFont.systemFont(ofSize: 16)
                _jr_label!.textColor = .black
                break
            case .cancel:
                _jr_label!.font = UIFont.boldSystemFont(ofSize: 16)
                _jr_label!.textColor = .darkGray
                break
            case .destructive:
                _jr_label!.font = UIFont.systemFont(ofSize: 16)
                _jr_label!.textColor = .red
                break
            }
            _jr_label!.textAlignment = .center
            label.text = action.title
            if action._isPreferredAction {
                _jr_label!.font = UIFont.boldSystemFont(ofSize: 16)
            }
        }
    }
    
    private func initView() {
        contentView.backgroundColor = .white
        switch _jr_style {
        case .action:
            _jr_label = UILabel.init()
            _jr_label!.textAlignment = .center
            contentView.addSubview(_jr_label!)
            break
        case .textField:
            if let textField = _jr_textField {
                contentView.addSubview(textField)
            }
            break
        }
    }
    
}


/**************************** tools func -start ****************************/

fileprivate func RGBA(r:Float, g:Float, b:Float, a:Float = 1) -> UIColor { return UIColor.init(colorLiteralRed: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }

fileprivate func DeviceHeight() -> Double { return Double(UIScreen.main.bounds.size.height) }

fileprivate func DeviceWidth() -> Double { return Double(UIScreen.main.bounds.size.width) }

fileprivate func MAXHeight() -> Double { return DeviceHeight()/5.0*3.6 }

fileprivate func MAXWidth() -> Double { return DeviceWidth()/6.0*5.0 }

fileprivate func JRAlertControllerCellRowHeight(byStyle style: JRAlertControllerCell.JRAlertControllerCellStyle) -> Double {
    switch style {
        case .action:
            return 54
        case .textField:
            return 44
    }
}

fileprivate func JRAlertControllerCellReuseIdentifier(byStyle style: JRAlertControllerCell.JRAlertControllerCellStyle) -> String {
    switch style {
    case .action:
        return "JRAlertControllerCellReuseIdentifierByAction"
    case .textField:
        return "JRAlertControllerCellReuseIdentifierByTextField"
    }
}

/**************************** tools func -end ****************************/


/**************************** extension -start ****************************/

extension UIView {
    
    func x() -> Double {
        return Double(self.frame.origin.x)
    }
    
    func y() -> Double {
        return Double(self.frame.origin.y)
    }
    
    func width() -> Double {
        return Double(self.frame.size.width)
    }
    
    func height() -> Double {
        return Double(self.frame.size.height)
    }
    
    func left() -> Double {
        return x()
    }
    
    func right() -> Double {
        return x() + width()
    }
    
    func top() -> Double {
        return y()
    }
    
    func bottom() -> Double {
        return y() + height()
    }
    
    func x(_ x: Double) {
        self.frame = CGRect.init(x: x, y: self.y(), width: self.width(), height: self.height())
    }
    
    func y(_ y: Double) {
        self.frame = CGRect.init(x: self.x(), y: y, width: self.width(), height: self.height())
    }
    
    func width(_ width: Double) {
        self.frame = CGRect.init(x: self.x(), y: self.y(), width: width, height: self.height())
    }
    
    func height(_ height: Double) {
        self.frame = CGRect.init(x: self.x(), y: self.y(), width: self.width(), height: height)
    }
    
    func left(_ left: Double, keepWidth: Bool = true) {
        if !keepWidth {
            let difference = self.x()-left
            self.width(self.width()+difference)
        }
        self.x(left)
    }
    
    func right(_ right: Double, keepWidth: Bool = true) {
        if !keepWidth {
            let difference = self.x()+self.width()-right
            self.width(self.width()-difference)
        }
        self.x(right-self.width())
    }
    
    func top(_ top: Double, keepHeight: Bool = true) {
        if !keepHeight {
            let difference = self.y()-top
            self.height(self.height()+difference)
        }
        self.y(top)
    }
    
    func bottom(_ bottom: Double, keepHeight: Bool = true) {
        if !keepHeight {
            let difference = self.y()+self.height()-bottom
            self.height(self.height()-difference)
        }
        self.y(bottom-self.height())
    }
    
    func origin(_ origin: CGPoint) {
        self.x(Double(origin.x))
        self.y(Double(origin.y))
    }
    
    func size(_ size: CGSize) {
        self.width(Double(size.width))
        self.height(Double(size.height))
    }
    
    func center(_ center: CGPoint) {
        self.origin(CGPoint.init(x: Double(center.x)-self.width()/2.0, y: Double(center.y)-self.height()/2.0))
    }

    func fixBlackLine() {
        let width = Double(Int(self.width()+1))
        let height = Double(Int(self.height()+1))
        size(CGSize.init(width: width, height: height))
    }

}

extension String {
    
    /**
     Get the height with the string.
     
     - parameter attributes: The string attributes.
     - parameter fixedWidth: The fixed width.
     
     - returns: The height.
     */
    func height(withStringAttributes attributes : [String : AnyObject], fixedWidth : Double) -> Double {
        guard self.characters.count > 0 && fixedWidth > 0 else {
            return 0
        }
        let size = CGSize.init(width: fixedWidth, height: Double.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return Double(rect.size.height)
    }
    
    /**
     Get the height with font.
     
     - parameter font:       The font.
     - parameter fixedWidth: The fixed width.
     
     - returns: The height.
     */
    func height(withFont font : UIFont = UIFont.systemFont(ofSize: 16), fixedWidth : Double) -> Double {
        guard self.characters.count > 0 && fixedWidth > 0 else {
            return 0
        }
        let size = CGSize.init(width: fixedWidth, height: Double.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context:nil)
        return Double(rect.size.height)
    }
    
    /**
     Get the width with the string.
     
     - parameter attributes: The string attributes.
     
     - returns: The width.
     */
    func width(withStringAttributes attributes : [String : AnyObject]) -> Double {
        guard self.characters.count > 0 else {
            return 0
        }
        let size = CGSize.init(width: Double.greatestFiniteMagnitude, height: 0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return Double(rect.size.width)
    }
    
    /**
     Get the width with the string.
     
     - parameter font: The font.
     
     - returns: The string's width.
     */
    func width(withFont font : UIFont = UIFont.systemFont(ofSize: 16)) -> Double {
        guard self.characters.count > 0 else {
            return 0
        }
        let size = CGSize.init(width: Double.greatestFiniteMagnitude, height: 0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context:nil)
        return Double(rect.size.width)
    }
    
}

/**************************** extension -end ****************************/
