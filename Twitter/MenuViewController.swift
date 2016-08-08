//
//  MenuViewController.swift
//  Twitter
//
//  Created by Saumeel Gajera on 8/7/16.
//  Copyright © 2016 walmart. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private var profileNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    private var tweetsNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        mentionsNavigationController = storyboard.instantiateViewControllerWithIdentifier("MentionsNavigationController")
        tweetsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController")
        
        viewControllers.append(profileNavigationController)
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        tableView.reloadData()
        
        hamburgerViewController.contentViewController = tweetsNavigationController
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows called !")
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        print("tableview called")
        let titles = ["Profile", "TimeLine", "Notifications"]

        cell.titleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("didSelect : \(indexPath.row)")
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
