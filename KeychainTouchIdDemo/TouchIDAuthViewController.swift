//
//  TouchIDAuthViewController.swift
//  KeychainTouchIdDemo #4
//
//  Demo Code - Intertech - http://www.intertech.com
//  ACL on Keychain Item which forces Touch ID / Passcode authentication
//  (if the user has either enabled)

import UIKit
import Security

class TouchIDAuthViewController: UIViewController {
    @IBOutlet weak var passwordField: UITextField!
    
        @IBOutlet weak var keychainField: UITextField!

    @IBAction func loadPassword(sender: UIButton) {
        if let password = retrievePassword() {
            keychainField.text = password;
        }
    }
    
    
    @IBAction func savePassword(sender: UIButton) {
        let secAC = SecAccessControlCreateWithFlags(kCFAllocatorDefault,kSecAttrAccessibleWhenUnlocked, .UserPresence, nil)
        
        let passwordData: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        let attrs : [NSObject : AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : "IntertechSecure",
            kSecAttrAccount : "Instructor",
            kSecValueData : passwordData,
            kSecAttrAccessControl : secAC!,
            kSecUseOperationPrompt : "Touch ID Demo"

        ]
        
        SecItemDelete(attrs)
        let resultCode = SecItemAdd(attrs as CFDictionaryRef, nil)
        if resultCode != errSecSuccess {
            print("Unable to Add Password to Keychain.  Error Code: \(resultCode)")
        } else {
            print("Successfully added \(passwordField.text!)")
        }
        passwordField.text = ""
    }
    
    @IBAction func deletePassword(sender: UIButton) {
        let attrs : [NSObject : AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : "IntertechSecure",
            kSecAttrAccount : "Instructor"
        ]
        
        SecItemDelete(attrs)
    }
    
    func retrievePassword() -> String? {
        let attrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : "IntertechSecure",
            kSecAttrAccount : "Instructor",
            kSecReturnData : kCFBooleanTrue
        ]
        var passwordData:AnyObject?
        SecItemCopyMatching(attrs, &passwordData)
        let password = String(data: (passwordData as? NSData) ?? NSData(), encoding: NSUTF8StringEncoding)
        return password
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
