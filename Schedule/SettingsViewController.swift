//
//  SettingsViewController.swift
//  Schedule
//
//  Created by Oussama Ayed on 18/04/2018.
//  Copyright © 2018 Oussama Ayed. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
class SettingsViewController: UITableViewController {
    var tasks = [NSManagedObject]()
    var nbNotification = 0
    @IBOutlet weak var notificationSwith: UISwitch!
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
    override func viewWillAppear(_ animated: Bool) {
        
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            self.nbNotification = requests.count
          DispatchQueue.main.async {
            if ( self.nbNotification > 0 )
            {
                self.notificationSwith.isOn = true
            }else{
                self.notificationSwith.isOn = false
            }
            }
        })
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTasks()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func switchAction(_ sender: UISwitch) {
        if notificationSwith.isOn{
            let content = UNMutableNotificationContent()
            for t in tasks {
            let deadline = t.value(forKey: "taskDate") as! NSDate
            
            if ( deadline as Date > Date() as Date){
            content.title = "Schedule"
            content.subtitle = "\(t.value(forKey: "title") as! String) is done"
            content.body = "time out !!"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval:deadline.timeIntervalSinceNow.rounded(),
                                                            repeats: false)
            
            let requestIdentifier = t.value(forKey: "id") as! String
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request,withCompletionHandler: { (error) in})
                
                }
                
            }
        }else{
            let alertController = UIAlertController(title: "Notifications", message: "Are you sure that you want remove all the notifications ?", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "yes", style: UIAlertActionStyle.default) {
                UIAlertAction in
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
