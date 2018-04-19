//
//  EditTaskViewController.swift
//  Schedule
//
//  Created by Oussama Ayed on 18/04/2018.
//  Copyright © 2018 Oussama Ayed. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class EditTaskViewController: UITableViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    var idTask = ""
    var task = NSManagedObject()
    func fetchTaskByName(id:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        fetchRequest.predicate = NSPredicate(format: "%K == %@","id","\(id)")
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            self.task = result.first! as! NSManagedObject
            
        }
        catch let error as NSError {
            let alert = UIAlertController(title: "Fetch tasks", message: "Could not fetch \(error)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            
        }
    }
    @IBAction func notificationAction(_ sender: UISwitch) {
        if notificationSwitch.isOn{
            let content = UNMutableNotificationContent()
           
                let deadline = task.value(forKey: "taskDate") as! NSDate
                
                if ( deadline as Date > Date() as Date){
                    content.title = "Schedule"
                    content.subtitle = "\(task.value(forKey: "title") as! String) is done"
                    content.body = "time out !!"
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval:deadline.timeIntervalSinceNow.rounded(),
                                                                    repeats: false)
                    
                    let requestIdentifier = task.value(forKey: "id") as! String
                    let request = UNNotificationRequest(identifier: requestIdentifier,
                                                        content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request,withCompletionHandler: { (error) in})
                    
                }
                
            
        }else{
            let alertController = UIAlertController(title: "Notification", message: "Are you sure that you want remove it ?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "yes", style: UIAlertActionStyle.default) {
                UIAlertAction in
                let center = UNUserNotificationCenter.current()
                center.removePendingNotificationRequests(withIdentifiers:  [self.idTask] )
            }
            let cancelAction = UIAlertAction(title: "no", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func editTask(_ sender: UIBarButtonItem) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        task.setValue(task.value(forKey: "id"), forKey: "id")
        task.setValue(txtTitle.text!, forKey: "title")
        task.setValue(datePicker.date, forKey: "taskDate")
        task.setValue(task.value(forKey: "category"), forKey: "category")
        
        do {
            try managedContext.save()
            
            
        } catch let error as NSError {
            let alert = UIAlertController(title: "Edit tasks", message: "Could not save : \(error)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        
        fetchTaskByName(id: idTask)
        txtTitle.text = task.value(forKey: "title") as? String
        datePicker.date = task.value(forKey: "taskDate") as! Date
        notificationSwitch.isOn = false
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                DispatchQueue.main.async {
                    let strID = request.identifier
                    if (  strID == self.idTask)
                    {
                        self.notificationSwitch.isOn = true
                    }
                }
            }
        })
        // Do any additional setup after loading the view.
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be     recreated.
    }

    @IBAction func DeleteTask(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(task)
        self.navigationController?.popViewController(animated: true)

    }
    

    /*
     // MARK: - Table view data source
     
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
