//
//  KeychainInternetPasswordViewController.swift
//  KeychainTouchIdDemo #3
//
//  Demo Code - Intertech - http://www.intertech.com
//  Internet Password CRUD (Retrieve all attributes and "secret")

import UIKit
// The SecItem API requires the Security framework
import Security

class KeychainInternetPasswordViewController: UIViewController {
    @IBOutlet weak var protocolField: UITextField!
    @IBOutlet weak var serverField: UITextField!
    @IBOutlet weak var pathField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var keychainField: UITextField!
    
    @IBAction func save(sender: AnyObject) {
        
        // The secret is passed to the API as NSData
        let passwordData: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        // A dictionary of attributes to delete our Keychain Item(s).
        // The fewer the attributes, the more items you could (unintentionally) match,
        // so be careful!
        var searchAttrs : [NSObject:AnyObject]! = [
            kSecClass : kSecClassInternetPassword,
            kSecAttrAccount : "Intertech",
            kSecReturnAttributes : kCFBooleanTrue
        ]
        
        // First attempt to retrieve the Keychain Item. If something is returned
        // use that dictionary to do an Update.  If not, do an Add.
        var returnedAttrsRef:AnyObject?
        if SecItemCopyMatching(searchAttrs, &returnedAttrsRef) == errSecSuccess {
            var returnedAttrs : [NSObject : AnyObject]! = returnedAttrsRef as? [NSObject : AnyObject]
            // The "search" dictionary cannot contain any "Return" keys.
            searchAttrs[kSecReturnAttributes] = nil
            // Add the values we are updating
            returnedAttrs[kSecAttrProtocol] = protocolField.text!
            returnedAttrs[kSecAttrServer] = serverField.text!
            returnedAttrs[kSecAttrPath] = pathField.text!
            returnedAttrs[kSecValueData] = passwordData
            let resultCode = SecItemUpdate(searchAttrs, returnedAttrs)
            if resultCode != errSecSuccess {
                keychainField.text = "Error Code: \(resultCode)"
            } else {
                clearFieldsAndRemoveKeyboard()
                keychainField.text = "Successfully Added Internet Data"
            }
        } else {
            // The "search" dictionary cannot contain any "Return" keys.
            searchAttrs[kSecReturnAttributes] = nil
            searchAttrs[kSecAttrProtocol] = protocolField.text!
            searchAttrs[kSecAttrServer] = serverField.text!
            searchAttrs[kSecAttrPath] = pathField.text!
            searchAttrs[kSecValueData] = passwordData
            let resultCode = SecItemAdd(searchAttrs, nil)
            if resultCode != errSecSuccess {
                keychainField.text = "Error Code: \(resultCode)"
            } else {
                clearFieldsAndRemoveKeyboard()
                keychainField.text = "Successfully Added Internet Data"
            }
        }
    }
    
    @IBAction func load(sender: AnyObject) {
        
        let dictionary = retrieveInternetData()
        if let internetData = dictionary {
            // Retrieve attributes; convert CFString values to NSString dictionary keys
            let protocolStr = internetData[NSString(format:kSecAttrProtocol)]
            let serverStr = internetData[NSString(format: kSecAttrServer)]
            let pathStr = internetData[NSString(format: kSecAttrPath)]
            let passwordData = internetData[NSString(format: kSecValueData)]
            // Convert NSData to String
            let password = String(data: (passwordData as? NSData) ?? NSData(), encoding: NSUTF8StringEncoding)
            keychainField.text = "\(protocolStr!)\(serverStr!)\(pathStr!) : \(password!)"
        }
    }

    @IBAction func deleteItem(sender: UIButton) {
        
        // A dictionary of attributes to delete our Keychain Item(s).
        // The fewer the attributes, the more items you could (unintentionally) match,
        // so be careful!
        let delAttrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassInternetPassword,
            kSecAttrAccount : "Intertech"
        ]
        
        // To delete any existing Keychain Item for this Service/Account combination,
        // pass in the Dictionary of attributes to SecItemDelete.
        // For the simplicity of this demo, we'll ignore error codes
        // ...something as simple as hitting the delete button twice
        // will cause an error, which we don't need to worry about.
        SecItemDelete(delAttrs)
        keychainField.text = ""

    }
    
    
    func retrieveInternetData() -> NSDictionary? {
        // A dictionary of attributes to specify the Keychain Item for retrieval.
        let attrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassInternetPassword,
            kSecAttrAccount : "Intertech",
            // kSecReturnAttributes states that we want to retrieve
            // all of the attributes for the Keychain Item
            kSecReturnAttributes: kCFBooleanTrue,
            // In addition to the attributes, we also want the secret.
            // The secret will be included in the dictionary, with
            // the Keychain Item attributes.
            kSecReturnData : kCFBooleanTrue
        ]
        var dictionaryRef:AnyObject?
        // Because we specified that we wanted the attributes, 
        // the address to a dictionary pointer is used instead of an NSData object.
        SecItemCopyMatching(attrs, &dictionaryRef)
        if let dictionary = dictionaryRef as? NSDictionary {
            return dictionary
        } else {
            return nil
        }
    }
    
    func clearFieldsAndRemoveKeyboard() -> Void {
        protocolField.text = ""
        serverField.text = ""
        pathField.text = ""
        passwordField.text = ""
        self.view.endEditing(true)
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
