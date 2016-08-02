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

class ComposeViewController: UIViewController, ComposeViewControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var charactersLeft: UILabel!
    @IBOutlet weak var composeTextView: UITextView!
    var _userWhoPosted: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        composeTextView.delegate = self
        
        if _userWhoPosted != nil{
            composeTextView.text = "@\(_userWhoPosted!)"
        }
        _userWhoPosted = nil
    }
    
    func textViewDidChange(textView: UITextView) {
        let charsLeft = 140 - textView.text.characters.count
        
        if charsLeft >= 0{
        charactersLeft.text =  "\(charsLeft)"
            if charsLeft < 10{
                charactersLeft.textColor = UIColor.redColor()
            }else if charsLeft == 10{
                charactersLeft.textColor = UIColor.blackColor()
            }
        }else{
        let alert = UIAlertController(title: "Compose Tweet Error", message: "Tweet can not exceed 140 characters", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//            let msg = textView.text
//            let start = msg.startIndex
//            let end = msg.endIndex.advancedBy(-1) // go one char back.
//            let substring = msg[start..<end]
//            textView.text = substring
            
        self.presentViewController(alert, animated: true, completion: nil)
            
        }
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
