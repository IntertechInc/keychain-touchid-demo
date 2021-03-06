//
//  TouchIDAuthViewController.swift
//  KeychainTouchIdDemo #4
//
//  Demo Code - Intertech - http://www.intertech.com
//  ACL on Keychain Item which forces Touch ID / Passcode authentication
//  (if the user has either enabled)

import UIKit
// The SecItem API requires the Security framework
import Security

// A Keychain Item with ACL flags.  Requires the user to use Touch ID / Passcode.
class TouchIDAuthViewController: UIViewController {
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var keychainField: UITextField!

    @IBAction func loadPassword(sender: UIButton) {
        if let password = retrievePassword() {
            keychainField.text = password;
        }
    }
    
    @IBAction func savePassword(sender: UIButton) {
        // The ACL configuration for a Keychain Item.
        // The 1st param specifies what allocator to use (the default is typically used).
        // The 2nd param specifies what type of protection...
        //   kSecAttrAccessibleWhenUnlocked only allows the retrieval of the Keychain Item
        //   when the device is unlocked.
        // The 3rd param is a flag that causes the Touch ID / Passcode challenge to execute.
        // The 4th param is used to pass in the address of an Error object.
        let secAC = SecAccessControlCreateWithFlags(kCFAllocatorDefault,kSecAttrAccessibleWhenUnlocked, .UserPresence, nil)
        // Convert the secret from String to NSData
        let passwordData: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        // A dictionary of attributes to describe our Keychain Item(s).
        let attrs : [NSObject : AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : "IntertechSecure",
            kSecAttrAccount : "Instructor",
            kSecValueData : passwordData,
            kSecAttrAccessControl : secAC!, // The ACL created above
            kSecUseOperationPrompt : "Touch ID Demo" // Message to be displayed to user

        ]
        
        // Although it is better to do an update than a Delete -> Add,
        // The ACL used would make the workflow a bit odd in this example
        // (i.e. a user would be challenged to authenticate when they
        // update a key).  In some cases that might be exactly what you
        // want to happen (in which case, you should use the Update pattern
        // used in KeychainPasswordViewController.
        SecItemDelete(attrs)
        let resultCode = SecItemAdd(attrs, nil)
        if resultCode != errSecSuccess {
            keychainField.text = "Unable to Add Password to Keychain.  Error Code: \(resultCode)"
        } else {
            keychainField.text = "Successfully added \(passwordField.text!)"
        }
        passwordField.text = ""
        passwordField.resignFirstResponder()
    }
    
    @IBAction func deletePassword(sender: UIButton) {
        let delAttrs : [NSObject : AnyObject] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService : "IntertechSecure",
            kSecAttrAccount : "Instructor"
        ]
        // Delete any Keychain Item(s) that match our attributes above.
        // For the simplicity of this demo, we'll ignore error codes
        // ...something as simple as hitting the delete button twice
        // will cause an error, which we don't need to worry about.
        SecItemDelete(delAttrs)
        keychainField.text = ""
    }
    
    func retrievePassword() -> String? {
        // A dictionary of attributes for our Keychain Item.
        let attrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrService : "IntertechSecure",
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
