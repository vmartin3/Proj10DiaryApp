//
//  CoreDataController.swift
//  Proj10DiaryApp
//
//  Created by Vernon G Martin on 5/2/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import CoreData
class CoreDataController: NSObject {

    static let sharedInstance = CoreDataController()
    
    enum DiaryKeys:String {
        case post = "post"
        case date = "date"
        case mood = "mood"
        case location = "location"
    }
    
    var managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        return managedContext!
    }()
    
    func save(postText: String, postDate: String, imageData: Data, location: String) {
        let entity = NSEntityDescription.entity(forEntityName: "DiaryPost", in: managedObjectContext)!
        let diaryEntry = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        diaryEntry.setValue(postText, forKeyPath: "post")
        diaryEntry.setValue(postDate, forKey: "date")
        diaryEntry.setValue(imageData, forKey: "mood")
        diaryEntry.setValue(location, forKey: "location")
        
        do {
            try managedObjectContext.save()
            DiaryTableView.diaryPosts.append(diaryEntry)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetch(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DiaryPost")
        
        do {
            
            DiaryTableView.diaryPosts = try managedContext.fetch(fetchRequest)
//            for managedObject in DiaryTableView.diaryPosts
//            {
//                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                managedContext.delete(managedObjectData)
//                DiaryTableView.diaryPosts.removeAll()
//                try managedObjectContext.save()
//            }
            try print(CoreDataController.sharedInstance.managedObjectContext.count(for: fetchRequest))
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
