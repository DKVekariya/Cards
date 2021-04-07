//
//  UserInfo+CoreDataProperties.swift
//  Cards
//
//  Created by Divyesh Vekariya on 06/04/21.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var city: String?
    @NSManaged public var email: String?
    @NSManaged public var name: String?

}

extension UserInfo : Identifiable {

}
