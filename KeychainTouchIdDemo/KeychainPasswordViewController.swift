//
//  KeychainPasswordViewController.swift
//  KeychainTouchIdDemo #2
//
//  Demo Code - Intertech - http://www.intertech.com
//  Generic Password CRUD (Retrieve single "secret")

import UIKit
import Security

class KeychainPasswordViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var keychainField: UITextField!

    @IBAction func textFieldLoad(sender: AnyObject) {
        if let password = retrievePassword() {
            keychainField.text = password;
        }
    }
    
    @IBAction func textFieldSave(sender: AnyObject) {

        let passwordData: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        let attrs : [NSObject : AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : "Intertech",
            kSecAttrAccount : "Instructor",
            kSecValueData : passwordData
        ]
        
        SecItemDelete(attrs)
        let resultCode = SecItemAdd(attrs as CFDictionaryRef, nil)
        if resultCode != errSecSuccess {
            print("Unable to Add Password to Keychain.  Error Code: \(resultCode)")
        }
        passwordField.text = ""
    }
    
    @IBAction func deleteEntry(sender: AnyObject) {
        
        let attrs : [NSObject : AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : "Intertech",
            kSecAttrAccount : "Instructor"
        ]
        
        SecItemDelete(attrs)
    }
    
    func retrievePassword() -> String? {
        let attrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : "Intertech",
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}