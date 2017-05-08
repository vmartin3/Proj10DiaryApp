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
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var diaryInputView: UIView!
    @IBOutlet weak var headerDateText: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var diaryEntryButton: UIButton!
    @IBOutlet weak var badMoodButton: UIButton!
    @IBOutlet weak var todaysDateLabel: UILabel!
    @IBOutlet weak var goodMoodButton: UIButton!
    @IBOutlet weak var averageMoodButton: UIButton!
    @IBOutlet weak var whatHappenedTodayLabel: UILabel!
    
    var homepage: DiaryTableView?
    var moodImage: UIImage?
    var imageData: Data?
    var fullDate:String?
    var diaryText:String?
    var location:String?
    
    var indexPath:Int?
    
    //Load todays date when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMM"
        fullDate = formatter.string(from: date)
        todaysDateLabel.text = fullDate
        formatter.dateFormat = "MMM YYYY"
        var modifiedDate = formatter.string(from: date)
        headerDateText.text = modifiedDate
        
        if editMode == true{
            whatHappenedTodayLabel.text = "Tap To Edit: \(diaryText!)"
            setupEditMode()
        }
        
        self.detailTableView.delegate = homepage!
        self.detailTableView.dataSource = homepage
        self.detailTableView.reloadData()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func savePressed(_ sender: AnyObject) {
        if editMode == true {
              CoreDataController.sharedInstance.updatePost(index: indexPath!, newPost: diaryText!)
        } else {
            checkForNil {
                CoreDataController.sharedInstance.save(postText: diaryText!, postDate: fullDate!, imageData: imageData!, location: self.location!)
            }
        }
        
        showAlert(title: "Save Succesful", message: "We have succesfully saved your diary entry", action: "Okay")
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
        
        //2 Second delay to grab location before alert box shows up to prevent nil values
        let when = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.location = "\(LocationManager.sharedLocationInstance.street!) - \(LocationManager.sharedLocationInstance.city!), \(LocationManager.sharedLocationInstance.state!)"
            self.showAlert(title: "Your Location", message: "Your current location is set as: \(self.location!)", action: "Okay")
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
                                        self.whatHappenedTodayLabel.textColor = UIColor (colorLiteralRed: 51/255, green: 102/255, blue: 0/255, alpha: 1)
                                        self.diaryEntryButton.isEnabled = false
                                        
                                        if editMode == true {
                                            self.whatHappenedTodayLabel.text = "Your Edit Has Been Recorded!"
                                        }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func showAlert(title:String, message:String, action:String){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let done = UIAlertAction(title: action,
                                 style: .default)
        alert.addAction(done)
        self.present(alert, animated: true)
    }
    
    //Turns image into data
    func prepareImageForSaving(iconNamed: String){
        moodImage = UIImage (named: iconNamed)
        imageData = UIImagePNGRepresentation(moodImage!)
    }
    
    //Checks for any nil values before post is saved
    func checkForNil(completion: ()->Void){
        if location == nil {
            location = "Location not given"
        }
        if moodImage == nil {
            prepareImageForSaving(iconNamed: "transparent")
        }
        guard let text = diaryText else {
            self.showAlert(title: "Wait a Minute", message: "You must enter some text into your diary entry for us to save it!", action: "Okay")
            return
        }
        completion()
    }
    
    //Sets up the detail view accordingly if the user is making an update rather than a new post
    func setupEditMode(){
        detailTableView.isUserInteractionEnabled = false
        badMoodButton.isEnabled = false
        averageMoodButton.isEnabled = false
        goodMoodButton.isEnabled = false
        addLocationButton.isEnabled = false
    }
    
    


}
