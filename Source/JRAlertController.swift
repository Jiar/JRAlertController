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
public enum JRAlertActionStyle: Int {
    case `default`
    case cancel
    case destructive
}

/// Constants indicating the type of alert to display.
public enum JRAlertControllerStyle: Int {
    case actionSheet
    case alert
}

/// A JRAlertAction object represents an action that can be taken when tapping a button in an alert. You use this class to configure information about a single action, including the title to display in the button, any styling information, and a handler to execute when the user taps the button. After creating an alert action object, add it to a JRAlertController object before displaying the corresponding alert to the user.
public class JRAlertAction: NSObject, NSCopying {
    
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
        _title = title
        _style = style
        _handler = handler
    }
    
    /// The title of the action’s button.
    /// This property is set to the value you specified in the init(title:style:handler:) method.
    public var title: String? {
        get {
            return _title
        }
    }
    
    /// The style that is applied to the action’s button.
    /// This property is set to the value you specified in the init(title:style:handler:) method.
    public var style: JRAlertActionStyle {
        get {
            return _style
        }
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let title = _title
        let style = _style
        let handler = _handler
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
/// present(alertController, animated: true, completion: nil)
/// ```
/// When configuring an alert with the alert style, you can also add text fields to the alert interface. The alert controller lets you provide a block for configuring your text fields prior to display. The alert controller maintains a reference to each text field so that you can access its value later.
public class JRAlertController: UIViewController {
    
    /**************************** open api -start ****************************/
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        assert(false, "use \"public init(title: String? = default, message: String? = default, preferredStyle: JRAlertControllerStyle = default)\" to replace")
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
    public init(title: String? = nil, message: String? = nil, preferredStyle: JRAlertControllerStyle = .actionSheet) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        transitioningDelegate = self
        _title = title
        _message = message
        _preferredStyle = preferredStyle
    }
    
    /// Attaches an action object to the alert or action sheet.
    /// If your alert has multiple actions, the order in which you add those actions determines their order in the resulting alert or action sheet.
    /// - Parameter action:
    /// The action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
    public func addAction(_ action: JRAlertAction) {
        assert(_haveAddCancel == false || action.style != .cancel, "Have added action that the style is cancel")
        if _actions == nil {
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
    public var actions: [JRAlertAction] {
        get {
            return _actions ?? []
        }
    }
    
    /// The preferred action for the user to take from an alert.
    ///
    /// The preferred action is relevant for the alert style only; it is not used by action sheets. When you specify a preferred action, the alert controller highlights the text of that action to give it emphasis. (If the alert also contains a cancel button, the preferred action receives the highlighting instead of the cancel button.) If the iOS device is connected to a physical keyboard, pressing the Return key triggers the preferred action.
    ///
    /// The action object you assign to this property must have already been added to the alert controller’s list of actions. Assigning an object to this property before adding it with the addAction(_:) method is a programmer error.
    ///
    /// The default value of this property is nil.
    public var preferredAction: JRAlertAction? {
        set {
            assert(_preferredStyle == .alert, "The 'preferredStyle' property must be alert.")
            _preferredAction = newValue
            guard let actions = _actions, let newValue = newValue, let index = actions.index(of: newValue) else {
                return
            }
            let action = actions[index]
            action._isPreferredAction = true
            _actions?[index] = action
        }
        get {
            return _preferredAction
        }
    }
    
    /// Adds a text field to an alert.
    ///
    /// Calling this method adds an editable text field to the alert. You can call this method more than once to add additional text fields. The text fields are stacked in the resulting alert.
    ///
    /// You can add a text field only if the preferredStyle property is set to alert.
    ///
    /// - Parameter configurationHandler: A block for configuring the text field prior to displaying the alert. This block has no return value and takes a single parameter corresponding to the text field object. Use that parameter to change the text field properties.
    public func addTextField(configurationHandler: ((UITextField) -> Swift.Void)? = nil) {
        assert(_preferredStyle == .alert, "The 'preferredStyle' property must be alert.")
        if _textFields == nil {
            _textFields = []
        }
        let textField = UITextField()
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
    public var textFields: [UITextField]? {
        get {
            return _textFields
        }
    }
    
    /// The title of the alert.
    ///
    /// The title string is displayed prominently in the alert or action sheet. You should use this string to get the user’s attention and communicate the reason for displaying the alert.
    public override var title: String? {
        set {
            _title = newValue
        }
        get {
            return _title
        }
    }
    
    /// Descriptive text that provides more details about the reason for the alert.
    ///
    /// The message string is displayed below the title string and is less prominent. Use this string to provide additional context about the reason for the alert or about the actions that the user might take.
    public var message: String? {
        set {
            _message = newValue
        }
        get {
            return _message
        }
    }
    
    /// The style of the alert controller.
    ///
    /// The value of this property is set to the value you specified in the init(title:message:preferredStyle:) method. This value determines how the alert is displayed onscreen.
    public var preferredStyle: JRAlertControllerStyle {
        get {
            return _preferredStyle
        }
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
    private var _oldShowViewY: CGFloat?
    private var _keyboardHeight: CGFloat?
    
    /**************************** private var -end ****************************/
    
    
    /**************************** achieve func -start ****************************/
    
    private let DivideHeight: CGFloat = 4
    private let tableView: UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let showView: UIView = UIView()
    private var titleLable: UILabel?
    private var messageLabel: UILabel?
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initShowView()
        initGestures()
        initRegistering()
    }
    
    private func initShowView() {
        let topBottom = initTop()
        let tableBottom = initTable(topBottom)
        let showViewHeight = initBottom(tableBottom)
        switch preferredStyle {
        case .actionSheet:
            if #available(iOS 11.0, *) {
                showView.frame = CGRect(x: 0, y: view.bounds.height-view.safeAreaInsets.bottom-showViewHeight, width: view.bounds.width, height: showViewHeight)
            } else {
                showView.frame = CGRect(x: 0, y: view.bounds.height-bottomLayoutGuide.length-showViewHeight, width: view.bounds.width, height: showViewHeight)
            }
        case .alert:
            showView.frame = CGRect(x: (DeviceWidth()-MAXWidth())/2, y: (DeviceHeight()-showViewHeight)/2, width: MAXWidth(), height: showViewHeight)
            showView.layer.masksToBounds = true
        }
        showView.backgroundColor = .white
        showState()
        view.addSubview(showView)
    }
    
    private func initTop() -> CGFloat {
        var topHeight: CGFloat = 0
        var haveTitle = false
        var haveMessage = false
        if let title = _title {
            switch preferredStyle {
            case .actionSheet:
                titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: DeviceWidth(), height: 44))
            case .alert:
                titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: MAXWidth(), height: 44))
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
            var width: CGFloat
            switch preferredStyle {
            case .actionSheet:
                width = DeviceWidth()
            case .alert:
                width = MAXWidth()
            }
            var messageLabelHeight = message.height(withFont: font, fixedWidth: width)
            if messageLabelHeight > MAXHeight()/8 {
                messageLabelHeight = MAXHeight()/8
            }
            var y: CGFloat = 0
            if let titleLable = titleLable {
                y = titleLable.bottom()
            }
            if !haveTitle {
                messageLabelHeight += 24
            }
            messageLabel = UILabel(frame: CGRect(x: 0, y: y, width: width, height: messageLabelHeight))
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
    
    private func initTable(_ y: CGFloat) -> CGFloat {
        var actionsCount = actions.count
        if _haveAddCancel {
            actionsCount -= 1
        }
        switch preferredStyle {
        case .actionSheet:
            let tableHeight = CGFloat(actionsCount)*JRAlertControllerCellRowHeight(byStyle: .action)
            tableView.frame = CGRect(x: 0, y: y, width: DeviceWidth(), height: tableHeight)
        case .alert:
            var textFieldsCount = 0
            if let textFields = _textFields {
                textFieldsCount = textFields.count
            }
            let tableHeight = CGFloat(actionsCount)*JRAlertControllerCellRowHeight(byStyle: .action)+CGFloat(textFieldsCount)*JRAlertControllerCellRowHeight(byStyle: .textField)
            tableView.frame = CGRect(x: 0, y: y, width: MAXWidth(), height: tableHeight)
        }
        tableView.backgroundColor = .white
        let null = UIView(frame: CGRect(x: 0, y: 0, width: DeviceWidth(), height: 0.01))
        tableView.tableHeaderView = null
        tableView.tableFooterView = null
        tableView.delegate = self
        tableView.dataSource = self
        showView.addSubview(tableView)
        return tableView.bottom()
    }
    
    private func initBottom(_ y: CGFloat) -> CGFloat {
        var showViewHeight: CGFloat
        if _haveAddCancel {
            switch preferredStyle {
            case .actionSheet:
                cutLine = UIView(frame: CGRect(x: 0, y: y, width: DeviceWidth(), height: 6))
            case .alert:
                cutLine = UIView(frame: CGRect(x: 0, y: y, width: MAXWidth(), height: 6))
            }
            cutLine!.backgroundColor = RGBA(r: 240, g: 240, b: 240)
            showView.addSubview(cutLine!)
            switch preferredStyle {
            case .actionSheet:
                cancelbtn = UIButton(frame: CGRect(x: 0, y: cutLine!.bottom(), width: DeviceWidth(), height: JRAlertControllerCellRowHeight(byStyle: .action)))
            case .alert:
                cancelbtn = UIButton(frame: CGRect(x: 0, y: cutLine!.bottom(), width: MAXWidth(), height: JRAlertControllerCellRowHeight(byStyle: .action)))
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
    
    private func initGestures() {
        initCancelGesture()
        initResignGesture()
        _cancelGesture.require(toFail: _resignGesture)
    }
    
    private func initCancelGesture() {
        _cancelGesture = UITapGestureRecognizer(target: self, action: #selector(cancelAction))
        _cancelGesture.delegate = self
        view.addGestureRecognizer(_cancelGesture)
    }
    
    private func initResignGesture() {
        _resignGesture = UITapGestureRecognizer(target: self, action: #selector(resignAction))
        _resignGesture.delegate = self
        showView.addGestureRecognizer(_resignGesture)
    }
    
    private func initFirstResponder() {
        if preferredStyle == .alert {
            guard let textFields = _textFields else {
                return
            }
            textFields.first?.becomeFirstResponder()
        }
    }
    
    @objc private func highlightedAction() {
        cancelbtn?.backgroundColor = RGBA(r: 217, g: 217, b: 217)
    }
    
    @objc private func normalAction() {
        cancelbtn?.backgroundColor = .white
    }
    
    @objc private func cancelAction() {
        cancelbtn?.backgroundColor = .white
        dismiss(animated: true, completion: {
            guard let action = self._cancelAction else {
                return
            }
            action._handler?(action)
        })
    }
    
    @objc private func resignAction() {
        if let textField = _openTextField {
            textField.resignFirstResponder()
        }
    }
    
    /**************************** achieve func -end ****************************/
    
}

// MARK: UIGestureRecognizerDelegate
extension JRAlertController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchView = touch.view, touchView != tableView else {
            return false
        }
        guard !touchView.isKind(of: NSClassFromString("UITableViewCellContentView")!), !touchView.isKind(of: NSClassFromString("UITableView")!), !touchView.isKind(of: NSClassFromString("UITextField")!) else {
            return false
        }
        if gestureRecognizer == _cancelGesture {
            if touchView == view {
                return true
            }
            if touchView == showView {
                return false
            }
        } else if gestureRecognizer == _resignGesture {
            if touchView == view {
                return false
            }
            if touchView == showView {
                return true
            }
        }
        return true
    }
    
}

// MARK: UITextFieldDelegate
extension JRAlertController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textFields = _textFields, let index = textFields.index(of: textField) else {
            return true
        }
        if index == textFields.count-1 {
            textFields[index].resignFirstResponder()
            dismiss(animated: true, completion: {
                guard let preferredAction = self._preferredAction else {
                    return
                }
                preferredAction._handler?(preferredAction)
            })
        } else {
            textFields[index+1].becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: index+1, section: 0), at: .none, animated: false)
        }
        return true
    }
    
}

// MARK: UITableViewDataSource
extension JRAlertController: UITableViewDataSource {
    
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
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cell: JRAlertControllerCell!
        var style: JRAlertControllerCell.JRAlertControllerCellStyle = .action
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
                    cell = JRAlertControllerCell(style: style, action: action)
                }
                cell.load(action: action, controllerStyle: preferredStyle)
            }
        case .textField:
            if let textFields = _textFields {
                let textField = textFields[row]
                textField.frame = CGRect(x: 8, y: 6, width: MAXWidth()-16, height: JRAlertControllerCellRowHeight(byStyle: .textField)-12)
                _textFields?[row] = textField
                cell = JRAlertControllerCell(style: style, textField: textField)
                cell.accessoryType = .none
                cell.selectionStyle = .none
            }
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension JRAlertController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if let textFields = _textFields {
            guard row >= textFields.count else {
                return
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let textFieldsCount: Int
        if let textFields = _textFields {
            textFieldsCount = textFields.count
        } else {
            textFieldsCount = 0
        }
        guard let actions = _actions else {
            return
        }
        var index = row-textFieldsCount
        if _haveAddCancel {
            if index >= _cancelActionIndex! {
                index += 1
            }
        }
        dismiss(animated: true, completion: {
            let action = actions[index]
            action._handler?(action)
        })
    }
    
}

// MARK: Registering
extension JRAlertController {
    
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
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldViewDidBeginEditing(_:)), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldViewDidEndEditing(_:)), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
            // Registering for keyboard notification.
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        }
        //  Registering for orientation changes notification
        NotificationCenter.default.addObserver(self, selector: #selector(willChangeStatusBarOrientation(_:)), name: NSNotification.Name.UIApplicationWillChangeStatusBarOrientation, object: UIApplication.shared)
        //  Registering for status bar frame change notification
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeStatusBarFrame(_:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarFrame, object: UIApplication.shared)
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
    
    @objc private func textFieldViewDidBeginEditing(_ notification:Notification) {
        if let textField = notification.object as? UITextField {
            _openTextField = textField
        }
    }
    
    @objc private func textFieldViewDidEndEditing(_ notification:Notification) {
        
    }
    
    @objc private func keyboardWillShow(_ notification: Notification?) -> Void {
        if let info = (notification as NSNotification?)?.userInfo {
            if let kbFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                _keyboardHeight = kbFrame.height
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
    
    @objc private func keyboardDidShow(_ notification: Notification?) -> Void {
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification?) -> Void {
        guard let showViewY = _oldShowViewY else {
            return
        }
        if _changeKeep {
            _changeKeep = false
            UIView.animate(withDuration: 0.2, animations: {
                self.showView.y(showViewY)
            }, completion: { (finish) in
                guard finish, let textField = self._openTextField, let textFields = self._textFields, let index = textFields.index(of: textField) else {
                    return
                }
                // will call keyboardWillShow
                textField.becomeFirstResponder()
                self.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .none, animated: false)
            })
        } else {
            _openTextField = nil
            UIView.animate(withDuration: 0.2, animations: {
                self.showView.y(showViewY)
            })
        }
        
    }
    
    @objc private func keyboardDidHide(_ notification:Notification) {
        
    }
    
    @objc private func willChangeStatusBarOrientation(_ notification:Notification) {
        if let _ = _openTextField {
            _changeKeep = true
        }
    }
    
    @objc private func didChangeStatusBarFrame(_ notification: Notification?) -> Void {
        
    }
    
    @objc private func deviceOrientationDidChange(_ interfaceOrientation: UIInterfaceOrientation) {
        reloadFrame()
    }
    
    private func reloadFrame() {
        var topHeight: CGFloat = 0
        var haveTitle = false
        var haveMessage = false
        if let _ = _title {
            switch preferredStyle {
            case .actionSheet:
                titleLable!.width(DeviceWidth())
            case .alert:
                titleLable!.width(MAXWidth())
            }
            topHeight = titleLable!.bottom()
            haveTitle = true
        }
        if let message = _message {
            var width:CGFloat
            switch preferredStyle {
            case .actionSheet:
                width = DeviceWidth()
            case .alert:
                width = MAXWidth()
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
        
        var actionsCount = actions.count
        if _haveAddCancel {
            actionsCount -= 1
        }
        switch preferredStyle {
        case .actionSheet:
            let tableHeight = CGFloat(actionsCount)*JRAlertControllerCellRowHeight(byStyle: .action)
            tableView.frame = CGRect(x: 0, y: tableTop, width: DeviceWidth(), height: tableHeight)
        case .alert:
            var textFieldsCount = 0
            if let textFields = _textFields {
                textFieldsCount = textFields.count
            }
            let tableHeight = CGFloat(actionsCount)*JRAlertControllerCellRowHeight(byStyle: .action)+CGFloat(textFieldsCount)*JRAlertControllerCellRowHeight(byStyle: .textField)
            tableView.frame = CGRect(x: 0, y: tableTop, width: MAXWidth(), height: tableHeight)
        }
        let tableBottom = tableView.bottom()
        
        var showViewHeight: CGFloat
        if _haveAddCancel {
            switch preferredStyle {
            case .actionSheet:
                cutLine!.y(tableBottom)
                cutLine!.width(DeviceWidth())
            case .alert:
                cutLine!.y(tableBottom)
                cutLine!.width(MAXWidth())
            }
            switch preferredStyle {
            case .actionSheet:
                cancelbtn!.y(cutLine!.bottom())
                cancelbtn!.width(DeviceWidth())
            case .alert:
                cancelbtn!.y(cutLine!.bottom())
                cancelbtn!.width(MAXWidth())
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
            showView.frame = CGRect(x: 0, y: DeviceHeight()-showViewHeight, width: DeviceWidth(), height: showViewHeight)
            if #available(iOS 11.0, *) {
                showView.y(view.bounds.height-view.safeAreaInsets.bottom-showView.height())
            } else {
                showView.y(view.bounds.height-bottomLayoutGuide.length-showView.height())
            }
        case .alert:
            showView.frame = CGRect(x: (DeviceWidth()-MAXWidth())/2, y: (DeviceHeight()-showViewHeight)/2, width: MAXWidth(), height: showViewHeight)
        }
        _oldShowViewY = showView.y()
        if let _ = _openTextField {
            _changeKeep = true
        }
        // It will hide keyboard, if exist textField that is responder
        tableView.reloadData()
    }
    
}

// MARK: UIViewControllerTransitioningDelegate
extension JRAlertController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}

// MARK: UIViewControllerAnimatedTransitioning
extension JRAlertController: UIViewControllerAnimatedTransitioning {
    
    fileprivate func showState() {
        view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
        switch preferredStyle {
        case .actionSheet:
            if #available(iOS 11.0, *) {
                showView.y(view.bounds.height-view.safeAreaInsets.bottom-showView.height())
            } else {
                showView.y(view.bounds.height-bottomLayoutGuide.length-showView.height())
            }
        case .alert:
            showView.alpha = 1
            initFirstResponder()
        }
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let isPresenting = view.superview == nil
        let transitionContainerView = transitionContext.containerView
        
        if isPresenting {
            transitionContainerView.addSubview(view)
            switch preferredStyle {
            case .actionSheet:
                view.backgroundColor = RGBA(r: 255, g: 255, b: 255, a: 0)
                showView.y(DeviceHeight())
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    self.showState()
                }, completion: { finished in
                    transitionContext.completeTransition(true)
                })
            case .alert:
                view.backgroundColor = RGBA(r: 255, g: 255, b: 255, a: 0)
                showView.alpha = 0
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    self.showState()
                }, completion: { finished in
                    transitionContext.completeTransition(true)
                })
            }
        } else {
            switch preferredStyle {
            case .actionSheet:
                view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    self.view.backgroundColor = RGBA(r: 255, g: 255, b: 255, a: 0)
                    self.showView.y(DeviceHeight())
                }, completion: { finished in
                    self.view.removeFromSuperview()
                    transitionContext.completeTransition(true)
                })
            case .alert:
                view.backgroundColor = RGBA(r: 0, g: 0, b: 0, a: 0.4)
                showView.alpha = 1
                UIView.animate(withDuration: 0.3, animations: {
                    self.showView.alpha = 0
                    self.view.backgroundColor = RGBA(r: 255, g: 255, b: 255, a: 0)
                }, completion: { finished in
                    self.view.removeFromSuperview()
                    transitionContext.completeTransition(true)
                })
            }
        }
    }
    
}

class JRAlertControllerCell: UITableViewCell {
    
    public enum JRAlertControllerCellStyle: String {
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
    
    public var jr_rowHeight: CGFloat {
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
    
    public func load(action: JRAlertAction, controllerStyle: JRAlertControllerStyle = .actionSheet) {
        if let label = _jr_label {
            switch controllerStyle {
            case .actionSheet:
                _jr_label?.frame = CGRect(x: 0.0, y: 0.0, width: DeviceWidth(), height: jr_rowHeight)
            case .alert:
                _jr_label?.frame = CGRect(x: 0.0, y: 0.0, width: MAXWidth(), height: jr_rowHeight)
            }
            switch action.style {
            case .default:
                _jr_label!.font = UIFont.systemFont(ofSize: 16)
                _jr_label!.textColor = .black
            case .cancel:
                _jr_label!.font = UIFont.boldSystemFont(ofSize: 16)
                _jr_label!.textColor = .darkGray
            case .destructive:
                _jr_label!.font = UIFont.systemFont(ofSize: 16)
                _jr_label!.textColor = .red
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
            _jr_label = UILabel()
            _jr_label!.textAlignment = .center
            contentView.addSubview(_jr_label!)
        case .textField:
            if let textField = _jr_textField {
                contentView.addSubview(textField)
            }
        }
    }
    
}

/**************************** tools func -start ****************************/

fileprivate func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) -> UIColor { return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }

fileprivate func DeviceHeight() -> CGFloat { return UIScreen.main.bounds.size.height }

fileprivate func DeviceWidth() -> CGFloat { return UIScreen.main.bounds.size.width }

fileprivate func MAXHeight() -> CGFloat { return DeviceHeight()/5.0*3.6 }

fileprivate func MAXWidth() -> CGFloat { return DeviceWidth()/6.0*5.0 }

fileprivate func JRAlertControllerCellRowHeight(byStyle style: JRAlertControllerCell.JRAlertControllerCellStyle) -> CGFloat {
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
    
    func x() -> CGFloat {
        return frame.origin.x
    }
    
    func y() -> CGFloat {
        return frame.origin.y
    }
    
    func width() -> CGFloat {
        return frame.size.width
    }
    
    func height() -> CGFloat {
        return frame.size.height
    }
    
    func left() -> CGFloat {
        return x()
    }
    
    func right() -> CGFloat {
        return x() + width()
    }
    
    func top() -> CGFloat {
        return y()
    }
    
    func bottom() -> CGFloat {
        return y() + height()
    }
    
    func x(_ x: CGFloat) {
        frame = CGRect(x: x, y: y(), width: width(), height: height())
    }
    
    func y(_ y: CGFloat) {
        frame = CGRect(x: x(), y: y, width: width(), height: height())
    }
    
    func width(_ width: CGFloat) {
        frame = CGRect(x: x(), y: y(), width: width, height: height())
    }
    
    func height(_ height: CGFloat) {
        frame = CGRect(x: x(), y: y(), width: width(), height: height)
    }
    
    func left(_ left: CGFloat, keepWidth: Bool = true) {
        if !keepWidth {
            let difference = x()-left
            width(width()+difference)
        }
        x(left)
    }
    
    func right(_ right: CGFloat, keepWidth: Bool = true) {
        if !keepWidth {
            let difference = x()+width()-right
            width(width()-difference)
        }
        x(right-width())
    }
    
    func top(_ top: CGFloat, keepHeight: Bool = true) {
        if !keepHeight {
            let difference = y()-top
            height(height()+difference)
        }
        y(top)
    }
    
    func bottom(_ bottom: CGFloat, keepHeight: Bool = true) {
        if !keepHeight {
            let difference = y()+height()-bottom
            height(height()-difference)
        }
        y(bottom-height())
    }
    
    func origin(_ origin: CGPoint) {
        x(origin.x)
        y(origin.y)
    }
    
    func size(_ size: CGSize) {
        width(size.width)
        height(size.height)
    }
    
    func center(_ center: CGPoint) {
        origin(CGPoint(x: center.x-width()/2.0, y: center.y-height()/2.0))
    }

    func fixBlackLine() {
        let width = Int(self.width()+1)
        let height = Int(self.height()+1)
        size(CGSize(width: width, height: height))
    }

}

extension String {
    
    /**
     Get the height with the string.
     
     - parameter attributes: The string attributes.
     - parameter fixedWidth: The fixed width.
     
     - returns: The height.
     */
    func height(withStringAttributes attributes: [NSAttributedStringKey: Any], fixedWidth: CGFloat) -> CGFloat {
        guard count > 0 && fixedWidth > 0 else {
            return 0
        }
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return CGFloat(rect.size.height)
    }
    
    /**
     Get the height with font.
     
     - parameter font:       The font.
     - parameter fixedWidth: The fixed width.
     
     - returns: The height.
     */
    func height(withFont font: UIFont = UIFont.systemFont(ofSize: 16), fixedWidth: CGFloat) -> CGFloat {
        guard count > 0 && fixedWidth > 0 else {
            return 0
        }
        let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context:nil)
        return CGFloat(rect.size.height)
    }
    
    /**
     Get the width with the string.
     
     - parameter attributes: The string attributes.
     
     - returns: The width.
     */
    func width(withStringAttributes attributes: [NSAttributedStringKey: Any]) -> CGFloat {
        guard count > 0 else {
            return 0
        }
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return CGFloat(rect.size.width)
    }
    
    /**
     Get the width with the string.
     
     - parameter font: The font.
     
     - returns: The string's width.
     */
    func width(withFont font: UIFont = UIFont.systemFont(ofSize: 16)) -> CGFloat {
        guard count > 0 else {
            return 0
        }
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context:nil)
        return CGFloat(rect.size.width)
    }
    
}

/**************************** extension -end ****************************/
