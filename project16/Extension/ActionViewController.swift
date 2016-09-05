//
//  ActionViewController.swift
//  Extension
//
//  Created by kimihito on 2016/08/26.
//  Copyright © 2016年 minotake. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(done))
        let notifcationCenter = NSNotificationCenter.defaultCenter()
        notifcationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
        notifcationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIKeyboardWillHideNotification, object: nil)
        
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
                itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil) { [unowned self] (dict, error) in
                    let itemDictionary = dict as! NSDictionary
                    let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as!NSDictionary
                    self.pageTitle = javaScriptValues["title"] as! String
                    self.pageURL = javaScriptValues["URL"] as! String
                    dispatch_async(dispatch_get_main_queue()) {
                        self.title = self.pageTitle
                    }
                }
            }
        }
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        
        if notification.name == UIKeyboardWillHideNotification {
            script.contentInset = UIEdgeInsetsZero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let webDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: ["customJavaScript" : script.text]]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext!.completeRequestReturningItems([item], completionHandler: nil)
    }

}