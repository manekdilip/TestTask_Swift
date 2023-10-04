

import Foundation
import CoreData


extension UserList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserList> {
        return NSFetchRequest<UserList>(entityName: "UserList")
    }

    @NSManaged public var email: String?
    @NSManaged public var joinedDate: String?
    @NSManaged public var fullName: String?
    @NSManaged public var country: String?
    @NSManaged public var profilePic: Data?
    @NSManaged public var city: String?
    @NSManaged public var state: String?
    @NSManaged public var postcode: String?
    @NSManaged public var userUUID: String?
    @NSManaged public var dateOfBirth: String?
}

extension UserList : Identifiable {

}
