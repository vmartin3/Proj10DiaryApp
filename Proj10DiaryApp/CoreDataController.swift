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
    
    //Enum for the Core Data entity keys
    enum DiaryKeys:String {
        case post = "post"
        case date = "date"
        case mood = "mood"
        case location = "location"
    }
    
    //Creates managed object context
    var managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        return managedContext!
    }()
    
    //Saves a DiaryPost to CoreData
    func save(postText: String, postDate: String, imageData: Data, location: String) {
        let entity = NSEntityDescription.entity(forEntityName: DiaryPost.identifier, in: managedObjectContext)!
        let diaryEntry = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        diaryEntry.setValue(postText, forKey: DiaryKeys .post.rawValue)
        diaryEntry.setValue(postDate, forKey: DiaryKeys .date.rawValue)
        diaryEntry.setValue(imageData, forKey: DiaryKeys .mood.rawValue)
        diaryEntry.setValue(location, forKey: DiaryKeys .location.rawValue)
        
        //Actually save the object and append diary item to the array
        do {
            try managedObjectContext.save()
            DiaryTableView.diaryPosts.append(diaryEntry)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Grabs the saved DiaryPost Data
    func fetch(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DiaryPost")
        do {
            DiaryTableView.diaryPosts = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
