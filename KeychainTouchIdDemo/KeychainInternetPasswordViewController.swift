//
//  KeychainInternetPasswordViewController.swift
//  KeychainTouchIdDemo #3
//
//  Demo Code - Intertech - http://www.intertech.com
//  Internet Password CRUD (Retrieve all attributes and "secret")

import UIKit
// The SecItem API requires the Security framework
// (don't forget to add this in the Target -> General -> Linked Frameworks & Libraries)
import Security

class KeychainInternetPasswordViewController: UIViewController {
    @IBOutlet weak var protocolField: UITextField!
    @IBOutlet weak var serverField: UITextField!
    @IBOutlet weak var pathField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var displayField: UITextField!
    
    @IBAction func save(sender: AnyObject) {
        
        // The secret is passed to the API as NSData
        let passwordData: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        // A dictionary of attributes to delete our Keychain Item(s).
        // The fewer the attributes, the more items you could (unintentionally) match,
        // so be careful!
        let delAttrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassInternetPassword,
            kSecAttrAccount : "Intertech"
        ]
        
        // TODO: A best practice is to update an existing Keychain item,
        // rather than delete -> add.  Rewrite to follow this pattern.
        //
        // To delete any existing Keychain Item for this Service/Account combination,
        // pass in the Dictionary of attributes to SecItemDelete
        SecItemDelete(delAttrs)
        
        // A dictionary of attributes that comprise our Keychain Item.
        let attrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassInternetPassword,
            kSecAttrAccount : "Intertech",
            kSecAttrProtocol : protocolField.text!, // i.e. http://
            kSecAttrServer : serverField.text!, // i.e. intertech.com
            kSecAttrPath : pathField.text!, // i.e. /training/ios
            kSecValueData : passwordData // the password for this resource.
        ]
        
        let resultCode = SecItemAdd(attrs, nil)
        if resultCode != errSecSuccess {
            print("Unable to Add Internet Data to Keychain.  Error Code: \(resultCode)")
        } else {
            print("Successfully Added Internet Data")
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
            let password = String(data: (passwordData as! NSData) ?? NSData(), encoding: NSUTF8StringEncoding)
            displayField.text = "\(protocolStr!)\(serverStr!)\(pathStr!) : \(password!)"
        }
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
        let dictionary = dictionaryRef as! NSDictionary
        return dictionary
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
