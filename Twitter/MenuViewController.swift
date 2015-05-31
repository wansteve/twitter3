//
//  MenuViewController.swift
//  Twitter
//
//  Created by Steve Wan on 5/30/15.
//  Copyright (c) 2015 Steve Wan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    
    private var viewControllerArray: [UIViewController] = []

    
    @IBOutlet weak var tableViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var activeViewContainer: UIView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    /* FIXED
    required init(coder aDecoder: NSCoder) { // this calls app delegate causes problem
        super.init(nibName: "MenuViewController", bundle: nil)
    }
    */
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if isViewLoaded() {
            if let inActiveVC = inactiveViewController {
                inActiveVC.willMoveToParentViewController(nil)
                inActiveVC.view.removeFromSuperview()
                inActiveVC.removeFromParentViewController()
            }
        }
    }
    
    private func updateActiveViewController() {
        if isViewLoaded() {
            if let activeVC = activeViewController {
                addChildViewController(activeVC)
                activeVC.view.frame = activeViewContainer.bounds
                activeViewContainer.addSubview(activeVC.view)
                navItem.title = activeVC.title
                activeVC.didMoveToParentViewController(self)
            }
        }
    }
    
    var viewControllers: [UIViewController]  {
        get { // getter returns read only copy
            let immutableCopy = viewControllerArray
            return immutableCopy
        }
        set {
            viewControllerArray = newValue
            
            // set the active view controller to the first one in the new array if the current one is not in there
            if activeViewController == nil || find(viewControllerArray, activeViewController!) == nil {
                activeViewController = viewControllerArray.first
            }
        }
    } // viewControllers
    
    
    @IBAction func didTapMenuButton(sender: AnyObject) {
        if (tableViewWidthConstraint.constant == 0) {
            showMenu()
        } else {
            hideMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.rowHeight =  50
        // menu is hidden to start
        self.tableViewWidthConstraint.constant = 0
        updateActiveViewController()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func hideMenu() {
        UIView .animateWithDuration(0.3, animations: { () -> Void in
            self.tableViewWidthConstraint.constant = 0
            self.tableView.layoutIfNeeded()
        });
    }
    
    private func showMenu() {
        UIView .animateWithDuration(0.3, animations: { () -> Void in
            // let totalHeight = self.tableView.rowHeight * CGFloat(self.tableView.numberOfRowsInSection(0))
            let totalWidth = 160.0 as CGFloat
            self.tableViewWidthConstraint.constant = totalWidth
            self.tableView.layoutIfNeeded()
        });
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllerArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = viewControllerArray[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        activeViewController = viewControllerArray[indexPath.row]
        hideMenu()
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
