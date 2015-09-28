//
//  LAContextDemoViewController.swift
//  KeychainTouchIdDemo #1
//
//  Demo Code - Intertech - http://www.intertech.com
//  Local Authentication

import UIKit
// LAContext requires the LocalAuthentication framework
// (don't forget to add this in the Target -> General -> Linked Frameworks & Libraries)
import LocalAuthentication

class LAContextDemoViewController: UIViewController {

    @IBOutlet weak var status: UILabel!
    
    @IBAction func loginChallenge(sender: AnyObject) {
        let localAuthContext = LAContext()
        var error : NSError?
        
        // Check to see if the device has Passcode/Touch ID enabled.  
        // LAPolicy.DeviceOwnerAuthentication (added in iOS 9)
        // includes both Passcode & Touch ID, where as
        // LAPolicy.DeviceOwnerAuthenticationWithBiometrics (added in iOS 8) 
        // only includes Touch ID.
        if localAuthContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthentication, error: &error) {
            // Evaluate the policy - The callback ("reply") is executed outside the main
            // thread, so no GUI changes should be executed directly in this context.
            // Instead, wrap this code in dispatch_async(dispatch_get_main_queue(), ...)
            // to ensure GUI calls are handled in the proper, main thread.
            localAuthContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthentication, localizedReason: "Touch ID Demo", reply: {(success: Bool, error: NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    if success {self.status.text = "Success!"}
                    else { self.status.text = error!.localizedDescription }
                })
            })
            
        } else {
            print("Passcode and TouchID not enabled")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
