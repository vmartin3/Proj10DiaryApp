//
//  DiaryPost.swift
//  Proj10DiaryApp
//
//  Created by Vernon G Martin on 5/2/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import UIKit
import  CoreData

class DiaryPost: NSManagedObject {
    static let identifier = "DiaryPost"
}

extension DiaryPost{
    
    @NSManaged var date: Date
    @NSManaged var location: String
    @NSManaged var mood: UIImage
    @NSManaged var post: String
    @NSManaged var image: UIImage
}
