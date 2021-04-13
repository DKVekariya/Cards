//
//  UserInfo+CoreDataProperties.swift
//  Cards
//
//  Created by Divyesh Vekariya on 12/04/21.
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
    @NSManaged public var username: String?
    @NSManaged public var phone: String?

}

extension UserInfo : Identifiable {

}
