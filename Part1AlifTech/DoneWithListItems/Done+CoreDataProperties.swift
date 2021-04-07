//
//  Done+CoreDataProperties.swift
//  Part1AlifTech
//
//  Created by REDDER on 4/7/21.
//  Copyright © 2021 REDDER. All rights reserved.
//
//

import Foundation
import CoreData


extension Done {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Done> {
        return NSFetchRequest<Done>(entityName: "Done")
    }

    @NSManaged public var date: Date?
    @NSManaged public var status: String?
    @NSManaged public var name: String?

}




