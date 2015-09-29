//
//  KeychainPasswordViewController.swift
//  KeychainTouchIdDemo #2
//
//  Demo Code - Intertech - http://www.intertech.com
//  Generic Password CRUD (Retrieve single "secret")

import UIKit
// The SecItem API requires the Security framework
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

        // The secret is passed to the API as NSData
        let passwordData: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        // A dictionary of attributes for our Keychain Item.
        let attrs : [NSObject : AnyObject] = [
            kSecClass: kSecClassGenericPassword, // Keychain Item's Class: Generic Password
            kSecAttrService : "Intertech", // Arbitrary service name
            kSecAttrAccount : "Instructor", // User ID
            kSecValueData : passwordData // The "secret" passed in as NSData
        ]
        
        // TODO: A best practice is to update an existing Keychain item, 
        // rather than delete -> add.  Rewrite to follow this pattern.
        //
        // To delete any existing Keychain Item for this Service/Account combination,
        // pass in the Dictionary of attributes to SecItemDelete
        SecItemDelete(attrs)
        // Add the Keychain Item by passing in the Dictionary of attributes.
        // The second parameter is a reference to the new values added to Keychain.
        // Since we're doing an 'add,' we don't really need this (so we'll pass in 'nil').
        // The return value is an OSStatus code.  Possible codes include:
        // errSecSuccess, errSecParam (one or more of the attributes is invalid for 
        // this type of class), etc.
        let resultCode = SecItemAdd(attrs, nil)
        if resultCode != errSecSuccess {
            keychainField.text = "Unable to Add Password to Keychain.  Error Code: \(resultCode)"
        }
        passwordField.text = ""
        passwordField.resignFirstResponder()
    }
    
    @IBAction func deleteEntry(sender: AnyObject) {
        
        // A dictionary of attributes for our Keychain Item.
        let attrs : [NSObject : AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : "Intertech",
            kSecAttrAccount : "Instructor"
        ]
        
        // Delete any Keychain Item(s) that match our attributes above.
        SecItemDelete(attrs)
        keychainField.text = ""
    }
    
    func retrievePassword() -> String? {
        // A dictionary of attributes for our Keychain Item.
        let attrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : "Intertech",
            kSecAttrAccount : "Instructor",
            // Add the kSecReturnData attribute, when expecting a secret to be returned.
            kSecReturnData : kCFBooleanTrue
        ]
        
        var passwordData:AnyObject?
        // Retrieve Keychain Item(s) with SecItemCopyMatching.
        // The first parameter is the Dictionary of attributes (above),
        // and the second parameter is a pointer to an object that should
        // store the returned secret.
        SecItemCopyMatching(attrs, &passwordData)
        // The returned secret is in an NSData format; convert to a String.
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