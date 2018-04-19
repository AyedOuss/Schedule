//
//  DataHelperCategories.swift
//  Schedule
//
//  Created by Oussama Ayed on 16/04/2018.
//  Copyright © 2018 Oussama Ayed. All rights reserved.
//

import Foundation
import CoreData
class DataHelperCategories {
    let categories = [ "Ruby" , "iOS" , "Android" , "J2EE" , "Git" , "C#" ]
    let colors = ["#F5522D", "#F68B2C", "#79A700", "#FF6E83" , "#C6DA02" , "#E2B400" ]
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    internal func seedCategories() {
        
        for i in 0 ..< categories.count{
            let category = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context) as! Categories
            category.name = categories[i] as String
            category.color = colors[i] as String
        }
        do {
            try context.save()
        } catch _ {}
    }
    
    
}

