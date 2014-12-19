//
//  SettingsViewController.swift
//  TaskIt
//
//  Created by Luc on 16/12/2014.
//  Copyright (c) 2014 lcj. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var capitalizeTableView: UITableView!
    @IBOutlet weak var completeNewTodoTableView: UITableView!
    @IBOutlet weak var versionLabel: UILabel!
    
    let kVersionNumber = "1.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        // Do any additional setup after loading the view.
        self.capitalizeTableView.delegate = self
        self.capitalizeTableView.dataSource = self
        self.capitalizeTableView.scrollEnabled = false
        
        self.completeNewTodoTableView.delegate = self
        self.completeNewTodoTableView.dataSource = self
        self.completeNewTodoTableView.scrollEnabled = false
        
        self.title = "Settings"
        self.versionLabel.text = kVersionNumber
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneBarButtonItemPressed:"))
        self.navigationItem.leftBarButtonItem = doneButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneBarButtonItemPressed (barButtonItem: UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.capitalizeTableView {
         
            var capitalizeCell: UITableViewCell = (tableView.dequeueReusableHeaderFooterViewWithIdentifier("capitalizeCell") as UITableViewCell?)!
            
            if indexPath.row == 0 {
                capitalizeCell.textLabel!.text = "No do not Capitalize"
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == false {
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.None
                }
            } else {
                capitalizeCell.textLabel!.text = "Yes Capitalize!"
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCapitalizeTaskKey) == true {
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    capitalizeCell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            return capitalizeCell
        }else{
            var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("completeNewTodoCell") as UITableViewCell
            if indexPath.row == 0 {
                cell.textLabel!.text = "Do not complete Task"
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodKey) == false {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            } else {
                cell.textLabel!.text = "Complete Task"
                if NSUserDefaults.standardUserDefaults().boolForKey(kShouldCompleteNewTodKey) == true {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.capitalizeTableView {
            return "Capitalize new Task ?"
        } else {
            return "Complete new Task ?"
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.capitalizeTableView {
            if indexPath.row == 0 {
                NSUserDefaults.standardUserDefaults().setBool(false , forKey: kShouldCapitalizeTaskKey)
            } else {
                NSUserDefaults.standardUserDefaults().setBool(true , forKey: kShouldCapitalizeTaskKey)
            }
        } else {
            if indexPath.row == 0 {
                NSUserDefaults.standardUserDefaults().setBool(false , forKey: kShouldCompleteNewTodKey)
            } else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: kShouldCompleteNewTodKey)
            }
        }
        NSUserDefaults.standardUserDefaults().synchronize()
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate
    
}
