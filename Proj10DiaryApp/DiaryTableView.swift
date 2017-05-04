//
//  DiaryTableView.swift
//  Proj10DiaryApp
//
//  Created by Vernon G Martin on 5/1/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import CoreData

class DiaryTableView: UITableViewController {
    
    static var diaryPosts: [NSManagedObject] = []
    var moodImage: UIImageView?

    @IBOutlet weak var newEntryButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataController.sharedInstance.fetch()
        //tableView.reloadData()
        print(DiaryTableView.diaryPosts.count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let detailView = segue.destination as? DetailController {
                detailView.homepage = self
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DiaryTableView.diaryPosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryTableCell
        
        cell.diaryEntryDateLabel.text = "November 23rd, 2016"
        if !DiaryTableView.diaryPosts.isEmpty{
            cell.diaryThoughtsLabel.text = DiaryTableView.diaryPosts[indexPath.row].value(forKey: "post") as? String
            cell.diaryEntryDateLabel.text = DiaryTableView.diaryPosts[indexPath.row].value(forKey: "date") as? String
            cell.locationLabel.text = DiaryTableView.diaryPosts[indexPath.row].value(forKey: "location") as? String
            let moodImageData = DiaryTableView.diaryPosts[indexPath.row].value(forKey: "mood") as? Data
           //FIXME: - Fix this - error handling
            if moodImageData != nil {
            cell.moodImage.image = UIImage(data: moodImageData!)
            }else {
                print("error nil found")
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete)
        {
            
            print("Diary Posts: \(DiaryTableView.diaryPosts.count)")
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DiaryPost")
            do{
            try print("CORED DATA Object Number: \(CoreDataController.sharedInstance.managedObjectContext.count(for: fetchRequest))")
            }catch{
                print("Error Cd")
            }
            print("Index Path Deleteing From: \(indexPath.row)")
            //print("Diary Posts: \(DiaryTableView.diaryPosts.count)")
            
            
            CoreDataController.sharedInstance.managedObjectContext.delete(DiaryTableView.diaryPosts[indexPath.row] as NSManagedObject)
            DiaryTableView.diaryPosts.remove(at: indexPath.row)
            //self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            //self.tableView.endUpdates()
            
            
            
            var error:Error? = nil;
            do{
                try CoreDataController.sharedInstance.managedObjectContext.save()
            }catch{
                
            }
            
        }
    }

}
