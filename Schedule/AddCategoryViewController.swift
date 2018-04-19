//
//  AddCategoryViewController.swift
//  Schedule
//
//  Created by Oussama Ayed on 18/04/2018.
//  Copyright © 2018 Oussama Ayed. All rights reserved.
//

import UIKit
import CoreData
import ChromaColorPicker
class AddCategoryViewController: UIViewController {
    
    
    @IBOutlet weak var txtCategory: UITextField!
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        let name = txtCategory.text!
        if (name == "")
        {
            let alert = UIAlertController(title: "Missing category name", message: "enter your category name", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else{
            let categoryColor = colorPicker.hexLabel.text!
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "Categories", in: managedContext)!
            
            let category = NSManagedObject(entity: entity, insertInto: managedContext)
            
            category.setValue(name, forKey: "name")
            category.setValue(categoryColor, forKey: "color")
            
            do {
                try managedContext.save()
                
                
            } catch let error as NSError {
                let alert = UIAlertController(title: "Add category", message: "Could not save. \(error), \(error.userInfo)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
   
    
    var colorPicker: ChromaColorPicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Calculate relative size and origin in bounds */
        let pickerSize = CGSize(width: view.bounds.width*0.8, height: view.bounds.width*0.8)
        let pickerOrigin = CGPoint(x: view.bounds.midX - pickerSize.width/2, y: view.bounds.midY - pickerSize.height/2)
        
        /* Create Color Picker */
        colorPicker = ChromaColorPicker(frame: CGRect(origin: pickerOrigin, size: pickerSize))
        colorPicker.delegate = self as? ChromaColorPickerDelegate
        
        /* Customize the view (optional) */
        colorPicker.padding = 10
        colorPicker.stroke = 3 //stroke of the rainbow circle
        colorPicker.currentAngle = Float.pi
        
        /* Customize for grayscale (optional) */
        colorPicker.supportsShadesOfGray = true // false by default
        
        
        
        colorPicker.hexLabel.textColor = UIColor.black
        
        
        
        self.view.addSubview(colorPicker)
    }
}

