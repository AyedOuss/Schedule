//
//  Tasks+CoreDataProperties.swift
//  Schedule
//
//  Created by Oussama Ayed on 16/04/2018.
//  Copyright © 2018 Oussama Ayed. All rights reserved.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var taskDate: NSDate?
    @NSManaged public var category: String?

}
