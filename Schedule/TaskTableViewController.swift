//
//  TaskTableViewController.swift
//  Schedule
//
//  Created by Oussama Ayed on 18/04/2018.
//  Copyright © 2018 Oussama Ayed. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController {
    let sections = ["Done", "To Do"]
    
    var tasks = [NSManagedObject]()
    var doneTasks = [NSManagedObject]()
    var toDoTasks = [NSManagedObject]()
    var categoryData = NSManagedObject()
    var sortedTasks = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        toDoTasks.removeAll()
        doneTasks.removeAll()
        tasks.removeAll()

        let defaults = UserDefaults.standard
        
        if !UserDefaults.standard.bool(forKey: "HasLaunchedOnce") {
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            UserDefaults.standard.synchronize()
            
            getCategories()
            // false for sort by ABC
            defaults.set(false, forKey: "sort")
            
        }
        
        fetchTasks()
        if(tasks.isEmpty == false){
            
            sortedTasks = tasks.sorted(by: { ($0.value(forKey: "taskDate") as? Date)!.compare($1.value(forKey: "taskDate") as! Date) == .orderedDescending  })
            
        }
        for s in sortedTasks {
            if (isOverdue(date: s.value(forKey: "taskDate") as! NSDate)) {
                doneTasks.append(s)
            } else {
                toDoTasks.append(s)
            }
        }
        
        
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    func getCategories()  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let dataHelp = DataHelperCategories(context: managedContext)
        dataHelp.seedCategories()
        
        
    }
    func getCategoryColor(category : String) -> String{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        fetchRequest.predicate = NSPredicate(format: "%K == %@","name","\(category)")
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            self.categoryData = result.first as! NSManagedObject
            
        }
        catch let error as NSError {
            let alert = UIAlertController(title: "Fetch Categories", message: "Could not fetch \(error)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            
        }
        let color = categoryData.value(forKey: "color")! as! String
        return color
    }
    func fetchTasks()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            self.tasks = result as! [NSManagedObject]
            
        }
        catch let error as NSError {
            let alert = UIAlertController(title: "Fetch tasks", message: "Could not fetch \(error)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section)
        {
        case 0:
            return doneTasks.count
        case 1:
            return toDoTasks.count
        default:
            return 0
        }
    }

    func isOverdue(date:NSDate) -> Bool {
        return (Date().compare(date as Date) == ComparisonResult.orderedDescending)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDone", for: indexPath)

        switch (indexPath.section) {
        case 0:
            let todoItem = doneTasks[(indexPath as NSIndexPath).row] as! Tasks
            let lblTask:UILabel = cell.viewWithTag(1) as! UILabel
            let lblDate:UILabel = cell.viewWithTag(2) as! UILabel
            lblTask.text = todoItem.title as String!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = " MMM dd yyyy 'at' h:mm a"
            lblDate.text = dateFormatter.string(from: todoItem.taskDate! as Date)
            let c = todoItem.value(forKey: "category") as! String
            let categoryColor = getCategoryColor(category: c )
            cell.backgroundColor = hexStringToUIColor(hex: categoryColor)
        case 1:
            let todoItem = toDoTasks[(indexPath as NSIndexPath).row] as! Tasks
            let lblTask:UILabel = cell.viewWithTag(1) as! UILabel
            let lblDate:UILabel = cell.viewWithTag(2) as! UILabel
            lblTask.text = todoItem.title as String!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = " MMM dd yyyy 'at' h:mm a"
            lblDate.text = dateFormatter.string(from: todoItem.taskDate! as Date)
            let c = todoItem.value(forKey: "category") as! String
            let categoryColor = getCategoryColor(category: c )
            cell.backgroundColor = hexStringToUIColor(hex: categoryColor)
        default: break
            //nothing to do
        }
        
        return cell
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // all cells are editable
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        switch (indexPath.section) {
        case 0:
            if editingStyle == .delete {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                managedContext.delete(doneTasks[indexPath.row])
                self.doneTasks.remove(at: (indexPath as NSIndexPath).row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case 1:
            if editingStyle == .delete {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                managedContext.delete(toDoTasks[indexPath.row])
                self.toDoTasks.remove(at: (indexPath as NSIndexPath).row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default: break
            //nothing to do
        }
       
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? EditTaskViewController {
            let path = self.tableView.indexPathForSelectedRow!
           
            let selectedRow:NSManagedObject = sortedTasks[path.row]
                destination.idTask = selectedRow.value(forKey: "id") as! String
            
            
        }
    }
}


