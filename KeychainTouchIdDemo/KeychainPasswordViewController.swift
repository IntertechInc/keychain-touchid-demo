//
//  KeychainPasswordViewController.swift
//  KeychainTouchIdDemo #3
//
//  Demo Code - Intertech - http://www.intertech.com

import UIKit
import Security

class KeychainPasswordViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!


    @IBAction func textFieldLoad(sender: AnyObject) {
        if let password = loadKeychainItem() {
            passwordField.text = password;
        }
    }
    
    @IBAction func textFieldSave(sender: AnyObject) {
        
        let itemValueData: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        let touchIDAttributes : [NSObject : AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : "Intertech",
            kSecAttrAccount : "Instructor",
            kSecValueData : itemValueData
        ]
        
        SecItemDelete(touchIDAttributes)
        let touchResultCode = SecItemAdd(touchIDAttributes as CFDictionaryRef, nil)
        if touchResultCode != errSecSuccess {
            print("Unable to Add Credentials to Keychain.  Error Code: \(touchResultCode)")
        }
    }
    
    func loadKeychainItem() -> String? {
        let attrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : "Intertech",
            kSecAttrAccount : "Instructor",
            kSecReturnData : kCFBooleanTrue
        ]
        var passwordData:AnyObject?
        SecItemCopyMatching(attrs, &passwordData)
        let password = String(data: (passwordData as! NSData) ?? NSData(), encoding: NSUTF8StringEncoding)
        return password
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}