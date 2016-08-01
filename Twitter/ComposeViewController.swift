//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Saumeel Gajera on 7/31/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    
    @IBOutlet weak var composeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func composeButtonTapped(sender: AnyObject) {
        
        if composeTextView.text.isEmpty {
            
            let OKAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                // no action for now!
//                self.dismissViewControllerAnimated(true, completion: nil)
            }
            let alertController = UIAlertController(title: "Compose Error", message: "Compose Message can not be empty!", preferredStyle: .Alert)
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion:  nil)
        }else{
            TwitterClient.sharedInstance.postTweet(composeTextView.text!)
        }
        
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
