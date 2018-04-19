//
//  AddTaskViewController.swift
//  Schedule
//
//  Created by Oussama Ayed on 16/04/2018.
//  Copyright © 2018 Oussama Ayed. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
class AddTaskViewController: UITableViewController , UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var txtTitle: UITextField!
    var name = ""
    var deadline = NSDate()
    var category = ""
    var categories = [NSManagedObject]()
    var pickerData: [String] = [String]()
    func fetchCategories()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            self.categories = result as! [NSManagedObject]
            
        }
        catch let error as NSError {
            let alert = UIAlertController(title: "Fetch tasks", message: "Could not fetch \(error)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .sound, .badge]], completionHandler: { (granted, error) in
        })
        UNUserNotificationCenter.current().delegate = self
        fetchCategories()
        self.categoryPicker.dataSource = self
        self.categoryPicker.delegate = self
        datePicker.minimumDate = NSDate().addingTimeInterval(60) as Date
        // I added A minute to the date because of the local notification
        category = categories[0].value(forKey: "name") as! String
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        category = categories[row].value(forKey: "name") as! String
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].value(forKey: "name")! as? String
    }
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        name = txtTitle.text!
        let uuid = UUID().uuidString
        if (name == "")
        {
            let alert = UIAlertController(title: "Missing title", message: "enter your title", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else{
            deadline = datePicker.date as NSDate
            // local notification begin
            
            let content = UNMutableNotificationContent()
            content.title = "Your App"
            content.subtitle = "\(name) is done"
            content.body = "time out !!"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval:deadline.timeIntervalSinceNow.rounded(),
                                                            repeats: false)
            
            let requestIdentifier = uuid
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request,
                                                   withCompletionHandler: { (error) in
            })
            // local notification End
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: managedContext)!
            let task = NSManagedObject(entity: entity, insertInto: managedContext)
            task.setValue(uuid, forKey: "id")
            task.setValue(name, forKey: "title")
            task.setValue(deadline, forKey: "taskDate")
            task.setValue(category, forKey: "category")
            do {
                try managedContext.save()
            } catch let error as NSError {
                let alert = UIAlertController(title: "Add tasks", message: "Could not save. \(error), \(error.userInfo)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    

    // MARK: - Table view data source

   

    /*
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
