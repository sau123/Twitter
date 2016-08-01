//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Saumeel Gajera on 7/31/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit

@objc protocol ComposeViewControllerDelegate: class{
    optional func getTweetDetails(tweetsViewController: TweetsViewController, tweetDetails tweetID: String, userWhoPosted: String)
}

class ComposeViewController: UIViewController, ComposeViewControllerDelegate {

    @IBOutlet weak var composeTextView: UITextView!
    var _userWhoPosted: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if _userWhoPosted != nil{
            composeTextView.text = "@\(_userWhoPosted!)"
        }
        _userWhoPosted = nil

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //delegate method implementation
    func getTweetDetails(tweetsViewController: TweetsViewController, tweetDetails tweetID: String, userWhoPosted: String){
        print("in compose view controller, got details from tweets view controller to compose view controller")
        print("tweedID received : "+tweetID)
        print("userScreenNameWhoPosted : "+userWhoPosted)
        _userWhoPosted = userWhoPosted
        print()
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
            dismissViewControllerAnimated(true, completion: nil)
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
