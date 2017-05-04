//
//  DetailController.swift
//  Proj10DiaryApp
//
//  Created by Vernon G Martin on 5/2/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class DetailController: UIViewController {
    
    @IBOutlet weak var badMoodButton: UIButton!
    @IBOutlet weak var todaysDateLabel: UILabel!
    @IBOutlet weak var goodMoodButton: UIButton!
    @IBOutlet weak var averageMoodButton: UIButton!
    
    
    var homepage: DiaryTableView?
    var moodImage: UIImage?
    var imageData: Data?
    var fullDate:String?
    var diaryText:String?
    var location:String?
    
    
   // let post = NSEntityDescription.insertNewObject(forEntityName: "DiaryPost", into: CoreDataController.sharedInstance.managedObjectContext) as! DiaryPost
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM"
        fullDate = formatter.string(from: date)
        todaysDateLabel.text = fullDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func savePressed(_ sender: AnyObject) {
        //post.date = todaysDateLabel.text!
        CoreDataController.sharedInstance.save(postText: diaryText!, postDate: fullDate!, imageData: self.imageData!, location: self.location!)
        homepage?.tableView.reloadData()
    }
    
    @IBAction func badMoodButtonPressed(_ sender: AnyObject) {
        badMoodButton.setTitleColor(.red, for: .normal)
        averageMoodButton.setTitleColor(.white, for: .normal)
        goodMoodButton.setTitleColor(.white, for: .normal)
        prepareImageForSaving(iconNamed: "icn_bad")
    }

    @IBAction func averageMoodButtonPressed(_ sender: AnyObject) {
        averageMoodButton.setTitleColor(.red, for: .normal)
        badMoodButton.setTitleColor(.white, for: .normal)
        goodMoodButton.setTitleColor(.white, for: .normal)
        prepareImageForSaving(iconNamed: "icn_average")
    }
    @IBAction func goodMoodButtonPressed(_ sender: AnyObject) {
        goodMoodButton.setTitleColor(.red, for: .normal)
        averageMoodButton.setTitleColor(.white, for: .normal)
        badMoodButton.setTitleColor(.white, for: .normal)
        prepareImageForSaving(iconNamed: "icn_happy")
    }
    @IBAction func addLocationPressed(_ sender: AnyObject) {
        LocationManager.sharedLocationInstance.determineMyCurrentLocation()
        
        let when = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.location = "\(LocationManager.sharedLocationInstance.street!) - \(LocationManager.sharedLocationInstance.city!), \(LocationManager.sharedLocationInstance.state!)"
            let alert = UIAlertController(title: "Your Current Location", message: "Your current location is set as: \(self.location)", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default)
            alert.addAction(okay)
            self.present(alert, animated: true)
        }
        
       
    }

    @IBAction func enterDiaryPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New Diary Entry",
                                      message: "Type about how your day went",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) {
                                        [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                                let postText = textField.text else {
                                                return
                                        }
                                        self.diaryText = postText
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func prepareImageForSaving(iconNamed: String){
        moodImage = UIImage (named: iconNamed)
        // use date as unique id
        let date : Double = NSDate().timeIntervalSince1970
        // create NSData from UIImage
        imageData = UIImagePNGRepresentation(moodImage!)

    }
    
}
