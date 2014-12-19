//
//  TaskModel.swift
//  TaskIt
//
//  Created by Luc on 10/11/14.
//  Copyright (c) 2014 lcj. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskModel)
class TaskModel: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var subtask: String
    @NSManaged var task: String

}
