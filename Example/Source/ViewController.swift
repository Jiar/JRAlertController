//
//  ViewController.swift
//  Example
//
//  Created by Jiar on 2016/11/2.
//  Copyright © 2016年 Jiar. All rights reserved.
//

import JRAlertController
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    /******************** JRAlertController -start ********************/
    
    @IBAction func alertSimple(_ sender: Any) {
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
        alertController.jr_show(onRootView: self)
    }

    @IBAction func alertMultiple(_ sender: Any) {
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
        alertController.jr_show(onRootView: self)
    }
    
    @IBAction func sheetSimple(_ sender: Any) {
        let alertController = JRAlertController(title: "blog tip", message: "Please select the option to use the corresponding option to operate your blog", preferredStyle: .actionSheet)
//        let alertController = JRAlertController(title: "blog tip")
//        let alertController = JRAlertController(message: "Please select the option to use the corresponding option to operate your blog")
//        let alertController = JRAlertController()
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
        alertController.jr_show(onRootView: self)
    }
    
    @IBAction func sheetMultiple(_ sender: Any) {
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
        alertController.jr_show(onRootView: self)
    }
    
    /******************** JRAlertController -end ********************/
    
    
    /******************** UIAlertController -start ********************/
    
    @IBAction func UIAlertControllerAlertSimple(_ sender: Any) {
        let alertController = UIAlertController(title: "login tip", message: "please input account and password", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler:  {
            (action: UIAlertAction!) -> Void in
            print("cancel")
        })
        let loginAction = UIAlertAction(title: "login", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
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
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func UIAlertControllerAlertMultiple(_ sender: Any) {
        let alertController = UIAlertController(title: "I am title,I am title,I am title,I am title,I am title", message: "I am message, I am message, I am message, I am message, I am message, I am message, I am message, I am message, I am message", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler:  {
            (action: UIAlertAction!) -> Void in
            print("cancel")
        })
        let deleteAction = UIAlertAction(title: "delete", style: .destructive, handler: {
            (action: UIAlertAction!) -> Void in
            print("delete")
        })
        let archiveAction = UIAlertAction(title: "archive", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive")
        })
        let archiveAction1 = UIAlertAction(title: "archive1", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive1")
        })
        let archiveAction2 = UIAlertAction(title: "archive2", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive2")
        })
        let archiveAction3 = UIAlertAction(title: "archive3", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive3")
        })
        let archiveAction4 = UIAlertAction(title: "archive4", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive4")
        })
        let archiveAction5 = UIAlertAction(title: "archive5", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive5")
        })
        let archiveAction6 = UIAlertAction(title: "archive6", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
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
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func UIAlertControllerSheetSimple(_ sender: Any) {
        let alertController = UIAlertController(title: "blog tip", message: "Please select the option to use the corresponding option to operate your blog", preferredStyle: .actionSheet)
        let addAction = UIAlertAction(title: "add", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("add blog")
        })
        let modifyAction = UIAlertAction(title: "modify", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("modify blog")
        })
        let deleteAction = UIAlertAction(title: "delete", style: .destructive, handler: {
            (action: UIAlertAction!) -> Void in
            print("delete blog")
        })
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler:  {
            (action: UIAlertAction!) -> Void in
            print("cancel")
        })
        alertController.addAction(addAction)
        alertController.addAction(modifyAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func UIAlertControllerSheetMultiple(_ sender: Any) {
        let alertController = UIAlertController(title: "I am title,I am title,I am title,I am title,I am title", message: "I am message, I am message, I am message, I am message, I am message, I am message, I am message, I am message, I am message", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "delete", style: .destructive, handler: nil)
        let archiveAction = UIAlertAction(title: "archive", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive")
        })
        let archiveAction1 = UIAlertAction(title: "archive1", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive1")
        })
        let archiveAction2 = UIAlertAction(title: "archive2", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive2")
        })
        let archiveAction3 = UIAlertAction(title: "archive3", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive3")
        })
        let archiveAction4 = UIAlertAction(title: "archive4", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive4")
        })
        let archiveAction5 = UIAlertAction(title: "archive5", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            print("archive5")
        })
        let archiveAction6 = UIAlertAction(title: "archive6", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
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
        self.present(alertController, animated: true, completion: nil)
    }
    
    /******************** UIAlertController -end ********************/
    
    
    @IBAction func Jiar(_ sender: Any) {
        UIApplication.shared.openURL(NSURL.init(string: "http://weibo.com/u/2268197591/")! as URL)
    }
        
    @IBAction func Github(_ sender: Any) {
        UIApplication.shared.openURL(NSURL.init(string: "https://github.com/Jiar/")! as URL)
    }
    
    @IBAction func Blog(_ sender: Any) {
        UIApplication.shared.openURL(NSURL.init(string: "http://blog.jiar.vip/")! as URL)
    }
    
}

