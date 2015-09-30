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
    
    @IBAction func loadPassword(sender: AnyObject) {
        if let password = retrievePassword() {
            keychainField.text = password;
        }
    }
    
    @IBAction func savePassword(sender: AnyObject) {

        // The secret is passed to the API as NSData
        let passwordData: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        // A dictionary of attributes for our Keychain Item.
        var searchAttrs : [NSObject : AnyObject] = [
            kSecClass: kSecClassGenericPassword, // Keychain Item's Class: Generic Password
            kSecAttrService : "Intertech", // Arbitrary service name
            kSecAttrAccount : "Instructor", // User ID
            kSecReturnAttributes : kCFBooleanTrue
        ]

        // First attempt to retrieve the Keychain Item. If something is returned
        // use that dictionary to do an Update.  If not, do an Add.
        var returnedAttrsRef:AnyObject?
        if SecItemCopyMatching(searchAttrs, &returnedAttrsRef) == errSecSuccess {
            var returnedAttrs : [NSObject : AnyObject]! = returnedAttrsRef as? [NSObject : AnyObject]
            // The "search" dictionary cannot contain any "Return" keys.
            searchAttrs[kSecReturnAttributes] = nil
            // Add the password value we are updating
            returnedAttrs[kSecValueData] = passwordData
            let resultCode = SecItemUpdate(searchAttrs, returnedAttrs)
            if resultCode != errSecSuccess {
                keychainField.text = "Unable to Update Password in Keychain.  Error Code: \(resultCode)"
            }
        } else {
            // Add the Keychain Item by passing in the Dictionary of attributes.
            // The second parameter is a reference that can be used to 
            // contain the new values added to Keychain.
            // Since we're doing an 'add,' we don't really need this (so we'll pass in 'nil').
            // The return value is an OSStatus code.  Possible codes include:
            // errSecSuccess, errSecParam (one or more of the attributes is invalid for
            // this type of class), etc.
            searchAttrs[kSecReturnAttributes] = nil
            searchAttrs[kSecValueData] = passwordData
            let resultCode = SecItemAdd(searchAttrs, nil)
            if resultCode != errSecSuccess {
                keychainField.text = "Unable to Add Password to Keychain.  Error Code: \(resultCode)"
            }
        }
        passwordField.text = ""
        passwordField.resignFirstResponder()
    }
    
    @IBAction func deletePassword(sender: AnyObject) {
        
        // A dictionary of attributes for our Keychain Item.
        let attrs : [NSObject : AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : "Intertech",
            kSecAttrAccount : "Instructor"
        ]
        
        // Delete any Keychain Item(s) that match our attributes above.
        let resultCode = SecItemDelete(attrs)

        if resultCode != errSecSuccess {
            keychainField.text = "Unable to Update Password in Keychain.  Error Code: \(resultCode)"
        } else {
            keychainField.text = ""
        }
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