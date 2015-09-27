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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
