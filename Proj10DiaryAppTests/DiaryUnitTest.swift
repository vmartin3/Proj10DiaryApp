//
//  SaveSuccesful.swift
//  Proj10DiaryApp
//
//  Created by Vernon G Martin on 5/8/17.
//  Copyright © 2017 Vernon G Martin. All rights reserved.
//

import XCTest
import CoreData

@testable import Proj10DiaryApp

class DiaryUnitTest: XCTestCase {
    
    var coreData = CoreDataController.sharedInstance
    
    var date: Date?
    var formatter: DateFormatter?
    var fullDate: String?
    
    var editPostString: String?
    
    override func setUp() {
        super.setUp()
        let entity = NSEntityDescription.entity(forEntityName: DiaryPost.identifier, in: coreData.managedObjectContext)!
        let diaryEntry = NSManagedObject(entity: entity, insertInto: coreData.managedObjectContext)
        diaryEntry.setValue("This is an example Entry", forKey: "post")
        
        date = Date()
        formatter = DateFormatter()
        formatter?.dateFormat = "EEEE d MMM"
        fullDate = formatter?.string(from: date!)
        
        editPostString = "This is an example edit"
    }
    
    
    override func tearDown() {
        fullDate = nil
        super.tearDown()
    }
    
    func testCoreDataSaving() {
        XCTAssertNoThrow(try coreData.managedObjectContext.save(), "Failed to save diary entry")
    }
    
    func testCorrectDate() {
        //Update String with Todays Date to test this assertion
        XCTAssert(fullDate == "Monday 8 May", "The date is NOT correct")
    }
    
    func testDeleteData() {
        XCTAssertNoThrow(try coreData.managedObjectContext.delete(DiaryTableView.diaryPosts[0] as NSManagedObject), "Failed to delete diary entry")
    }
    
    func testEdit(){
        DiaryTableView.diaryPosts[0].setValue(editPostString, forKey: "post")
        XCTAssertNotNil(editPostString, "There is no value provided to update the entry post")
        
    }
    
}
