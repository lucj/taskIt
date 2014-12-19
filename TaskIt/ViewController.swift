//
//  ViewController.swift
//  TaskIt
//
//  Created by Luc on 31/10/2014.
//  Copyright (c) 2014 lcj. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, TaskDetailViewControllerDelegate, AddTaskViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    var fetchedResultsController:NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let date1 = Date.from(year: 2014, month: 05, day: 20)
//        let date2 = Date.from(year: 2014, month: 03, day: 3)
//        let date3 = Date.from(year: 2014, month: 12, day: 13)
//        
//        let task1 = TaskModel(task: "Study Chinese", subtask: "Hanzi", date: date1, completed: false)
//        let task2 = TaskModel(task:"Eat dinner", subtask:"Burgers", date: date2, completed: false)
//        let task3 = TaskModel(task:"Gym", subtask:"Abs", date: date3, completed: false)
//        
//        let taskArray = [task1, task2, task3]
//        var completedArray = [TaskModel(task:"Code", subtask: "Task project", date: date2, completed: true)]
//        
//        baseArray = [taskArray, completedArray]
//        
//        tableView.reloadData()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        
        fetchedResultsController = getFetchedResultsController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        func sortByDate (taskOne:TaskModel, taskTwo: TaskModel) -> Bool {
//            return taskOne.date.timeIntervalSince1970 < taskTwo.date.timeIntervalSince1970
//        }
//        
//        taskArray = taskArray.sorted(sortByDate)
//        baseArray[0] = baseArray[0].sorted{(taskOne:TaskModel, taskTwo: TaskModel) -> Bool in
//            // Comparison logic here
//            return taskOne.date.timeIntervalSince1970 < taskTwo.date.timeIntervalSince1970
//        }
//        self.tableView.reloadData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTaskDetail" {
            let detailVC: TaskDetailViewController = segue.destinationViewController as TaskDetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()
            let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as TaskModel
            detailVC.detailTaskModel = thisTask
            detailVC.delegate = self
        } else if segue.identifier == "showTaskAdd" {
            let addTaskVC: AddTaskViewController = segue.destinationViewController as AddTaskViewController
            //addTaskVC.mainVC = self
            addTaskVC.delegate = self
        }
    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showTaskAdd", sender: self)
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println(indexPath.row)
        var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("myCell") as TaskCell
        
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        
        cell.taskLabel.text = thisTask.task
        cell.descriptionLabel.text = thisTask.subtask
        cell.dateLabel.text = Date.toString(date: thisTask.date)
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        if fetchedResultsController.sections?.count == 1 {
            let fetchedObjects = fetchedResultsController.fetchedObjects!
            let testTask:TaskModel = fetchedObjects[0] as TaskModel
            if testTask.completed == true {
                return "Completed"
            }
            else {
                return "To do"
            }
        }
        else {
            if section == 0 {
                return "To do"
            }
            else {
                return "Completed"
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        
        if thisTask.completed == true {
            thisTask.completed = false
        } else {
            thisTask.completed = true
        }
        
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completedDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [completedDescriptor, sortDescriptor]
        return fetchRequest
    }
    
    func getFetchedResultsController() -> NSFetchedResultsController {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: "Completed", cacheName: nil)
        return fetchedResultsController
    }
    
    // MARK: - TaskDetailViewController delegate
    
    func taskDetailEdited() {
        showAlert()
    }
    
    func showAlert(message: String = "Congratulations"){
        var alert = UIAlertController(title: "Change made!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // AddTaskViewControllerDelegate
    
    func addTaskCanceled(message: String) {
        showAlert(message: message)
    }
    
    func addTask(message: String) {
        showAlert(message: message)
    }
    
}

