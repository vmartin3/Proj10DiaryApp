//
//  DiaryTableCell.swift
//  Proj10DiaryApp
//
//  Created by Vernon G Martin on 5/1/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit

class DiaryTableCell: UITableViewCell {
    @IBOutlet weak var diaryEntryDateLabel: UILabel!
    @IBOutlet weak var diaryThoughtsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var diaryUserImage: UIImageView!
    @IBOutlet weak var moodImage: UIImageView!
    
    override func awakeFromNib() {
    }

}
