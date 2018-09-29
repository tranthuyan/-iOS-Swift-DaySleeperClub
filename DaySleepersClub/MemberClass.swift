//
//  MemberClass.swift
//  DaySleepersClub
//
//  Created by lydia on 6/4/18.
//  Copyright © 2018 lydia. All rights reserved.
//

import Foundation
import UIKit
import os.log

class MemberClass: NSObject, NSCoding {
    //MARK: Properties
    var photo: UIImage?
    var name: String
    var team: String
    var descriptions: String
    var rating: Int
    
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("members")
    
    //MARK: Types
    struct PropertyKey {
        static let photo = "photo"
        static let name = "name"
        static let team = "team"
        static let descriptions = "descriptions"
        static let rating = "rating"
    }
    
    //MARK: Initialization
    
    init?(photo: UIImage?, name: String, team: String, descriptions: String, rating: Int) {
        
        // The name must not be empty
         guard !name.isEmpty else {
         return nil
         }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties
        self.photo = photo
        self.team = team
        self.descriptions = descriptions
        self.rating = rating
        
        // Initialization should fail these below are empty strings
        if name.isEmpty {
            return nil
        } else {
            self.name = name
        }
        
        if team.isEmpty {
            self.team = "(None)"
        }
        
        if descriptions.isEmpty {
            self.descriptions = "(None)"
        }
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(team, forKey: PropertyKey.team)
        aCoder.encode(descriptions, forKey: PropertyKey.descriptions)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    // Unarchiving
    required convenience init?(coder aDecoder: NSCoder) {
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        // if cannot decode these strings the initializer would fail
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Member object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let team = aDecoder.decodeObject(forKey: PropertyKey.team) as? String else {
            os_log("Unable to decode the team for a Member object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let descriptions = aDecoder.decodeObject(forKey: PropertyKey.descriptions) as? String else {
            os_log("Unable to decode the description for a Member object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // call designated initializer.
        self.init(photo: photo, name: name, team: team, descriptions: descriptions, rating: rating)
        
    }
    
    // MARK: static func
    static func saveMembers(member: [MemberClass]) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(member, toFile: MemberClass.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Saved!", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save!", log: OSLog.default, type: .error)
        }
    }
    
    // Unarchiving
   static func loadMembers() -> [MemberClass]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: MemberClass.ArchiveURL.path) as? [MemberClass]
    }
}
