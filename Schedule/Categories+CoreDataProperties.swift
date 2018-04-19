//
//  Categories+CoreDataProperties.swift
//  Schedule
//
//  Created by Oussama Ayed on 16/04/2018.
//  Copyright © 2018 Oussama Ayed. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var name: String?
    @NSManaged public var color: String?

}
