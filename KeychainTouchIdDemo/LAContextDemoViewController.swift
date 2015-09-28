//
//  LAContextDemoViewController.swift
//  KeychainTouchIdDemo #1
//
//  Demo Code - Intertech - http://www.intertech.com
//  Local Authentication

import UIKit
import LocalAuthentication

class LAContextDemoViewController: UIViewController {

    @IBOutlet weak var status: UILabel!
    
    @IBAction func loginChallenge(sender: AnyObject) {
        let localAuthContext = LAContext()
        var error : NSError?
        if localAuthContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthentication, error: &error) {
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
