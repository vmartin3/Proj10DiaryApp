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
    
    @IBOutlet weak var headerDateText: UILabel!
    @IBOutlet weak var newEntryButton: UIBarButtonItem!
    static var diaryPosts: [NSManagedObject] = []
    var cellString:String?
    
    
    //Fetch data once view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataController.sharedInstance.fetch()
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(colorLiteralRed: 0/225, green: 128/255, blue: 128/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .black
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM"
        let fullDate = formatter.string(from: date)
        self.title = fullDate
        formatter.dateFormat = "MMM YYYY"
        let modifiedDate = formatter.string(from: date)
        headerDateText.text = modifiedDate
    }
    
    //Pass reference of this VC on segue to detailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let detailView = segue.destination as? DetailController {
                detailView.homepage = self
            }
        }
        if segue.identifier == "ModalSegue" {
            let readOnlyVC = storyboard?.instantiateViewController(withIdentifier: "PopVC") as! ReadOnlyViewController
            readOnlyVC.view.backgroundColor = .clear
            readOnlyVC.modalPresentationStyle = .overCurrentContext
            readOnlyVC.fullDiaryEntry.text = cellString
            self.present(readOnlyVC, animated: false, completion: nil)
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
        
        if !DiaryTableView.diaryPosts.isEmpty{
            guard let diaryText = DiaryTableView.diaryPosts[indexPath.row].value(forKey: "post") as? String else {
                print("Error Setting Post Text")
                return cell
            }
            guard let dateText = DiaryTableView.diaryPosts[indexPath.row].value(forKey: "date") as? String else {
                print("Error Setting Date")
                return cell
            }
            guard let location = DiaryTableView.diaryPosts[indexPath.row].value(forKey: "location") as? String else {
                print("Error Setting Location")
                return cell
            }
            guard let moodImageData = DiaryTableView.diaryPosts[indexPath.row].value(forKey: "mood") as? Data else {
                print("Error Setting Mood Image")
                return cell
            }
                
            cell.diaryThoughtsLabel.text = diaryText
            cell.diaryEntryDateLabel.text = dateText
            cell.locationLabel.text = location
            cell.moodImage.image = UIImage(data: moodImageData)
            
            if tableView.tag == 2{
               cell.diaryEntryDateLabel.textColor = UIColor(colorLiteralRed: 51/255, green: 102/255, blue: 0/255, alpha: 1)
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete)
        {
            CoreDataController.sharedInstance.managedObjectContext.delete(DiaryTableView.diaryPosts[indexPath.row] as NSManagedObject)
            DiaryTableView.diaryPosts.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            var error:Error? = nil;
            do{
                try CoreDataController.sharedInstance.managedObjectContext.save()
            }catch{
               print("Unable to save after item deletion")
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DiaryTableCell
        
        cellString = cell.diaryThoughtsLabel.text!
        performSegue(withIdentifier: "ModalSegue", sender: self)
    }
    
    


}
