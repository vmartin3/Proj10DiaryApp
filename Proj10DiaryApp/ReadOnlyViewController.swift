//
//  ViewOnlyViewController.swift
//  Proj10DiaryApp
//
//  Created by Vernon G Martin on 5/5/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit

class ReadOnlyViewController: UIViewController {
    

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fullDiaryEntry: UITextView!
    var fullDiaryText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullDiaryEntry.text = fullDiaryText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        //dismiss(animated: true, completion: nil)
    }

    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
