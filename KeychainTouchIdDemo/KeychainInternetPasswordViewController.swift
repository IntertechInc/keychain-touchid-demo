//
//  KeychainInternetPasswordViewController.swift
//  KeychainTouchIdDemo #3
//
//  Demo Code - Intertech - http://www.intertech.com
//  Internet Password CRUD (Retrieve all attributes and "secret")

import UIKit
import Security

class KeychainInternetPasswordViewController: UIViewController {
    @IBOutlet weak var protocolField: UITextField!

    @IBOutlet weak var serverField: UITextField!
    
    @IBOutlet weak var pathField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var displayField: UITextField!
    
    @IBAction func save(sender: AnyObject) {
        
        let passwordData: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        print(protocolField.text!,serverField.text!,pathField.text!)
        
        let delAttrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassInternetPassword,
            kSecAttrAccount : "Intertech"
        ]
        
        SecItemDelete(delAttrs)
        
        let attrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassInternetPassword,
            kSecAttrAccount : "Intertech",
            kSecAttrProtocol : protocolField.text!,
            kSecAttrServer : serverField.text!,
            kSecAttrPath : pathField.text!,
            kSecValueData : passwordData
        ]
        
        let resultCode = SecItemAdd(attrs as CFDictionaryRef, nil)
        if resultCode != errSecSuccess {
            print("Unable to Add Internet Data to Keychain.  Error Code: \(resultCode)")
        } else {
            print("Successfully Added Internet Data")
        }
        
        
    }
    
    @IBAction func load(sender: AnyObject) {
        
        let dictionary = retrieveInternetData()
        if let internetData = dictionary {
            let protocolStr = internetData[NSString(format:kSecAttrProtocol)]
            let serverStr = internetData[NSString(format: kSecAttrServer)]
            let pathStr = internetData[NSString(format: kSecAttrPath)]
            let passwordData = internetData[NSString(format: kSecValueData)]
            let password = String(data: (passwordData as! NSData) ?? NSData(), encoding: NSUTF8StringEncoding)
            displayField.text = "\(protocolStr!)\(serverStr!)\(pathStr!) : \(password!)"
        }
    }

    func retrieveInternetData() -> NSDictionary? {
        let attrs : [NSObject:AnyObject] = [
            kSecClass : kSecClassInternetPassword,
            kSecAttrAccount : "Intertech",
            kSecReturnAttributes: kCFBooleanTrue,
            kSecReturnData : kCFBooleanTrue
        ]
        var dictionaryRef:AnyObject?
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
