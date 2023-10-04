

import Foundation
import UIKit

@objc
@objcMembers class CommanMethods: NSObject {
    
    static let sharedInstance = CommanMethods()
    
    func postNotification(_ strNotificationName:String) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(strNotificationName), object: nil)
    }
    
    func backButtonTitleRemove(_ controller:UIViewController) {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        controller.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    //MARK: - API calls
    func getUserListFromAPI() {
        
        let strUserListURL = Constants.WebServiceURLs.kUserListURL
        
        APIManager.shared.get(apiUrl: strUserListURL) { (result: Result<UserListModel, DataFetchError>) in
            switch result {
            case .success(let userList):
                self.saveUserListToDB(userList)
                break
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func saveUserListToDB(_ apiData:UserListModel) {
        
            let arrUsers = apiData.results
            
            for user in arrUsers {
                let objUserList: UserList?
                
                var arrUserList:[UserList]!
                
                var commitPredicate: NSPredicate?
                commitPredicate = NSPredicate(format: "userUUID == %@", user.login.uuid)
                
                arrUserList =  (CoreDataManager.sharedInstance.getObjectsforEntity(strEntity: Constants.CoreDataTables.kUserList, ShortBy: "", isAscending: true, predicate: commitPredicate!, groupBy: "", taskContext: CoreDataManager.sharedInstance.bGManagedObjectContext) as! NSArray).mutableCopy() as? [UserList]
                
                if arrUserList.count>0 {
                    objUserList = arrUserList.first
                }else{
                    objUserList = (CoreDataManager.sharedInstance.createObjectForEntity(entityName: Constants.CoreDataTables.kUserList, taskContext: CoreDataManager.sharedInstance.bGManagedObjectContext) ) as? UserList
                }
                
                objUserList?.fullName = user.name.title + " " + user.name.first + " " + user.name.last
                
                objUserList?.email = user.email
                
                objUserList?.joinedDate = user.registered.date
                
                objUserList?.country = user.location.country
                
                objUserList?.city = user.location.city
                
                objUserList?.state = user.location.state
                
                objUserList?.postcode = "Z8 9FX"
                
                objUserList?.userUUID = user.login.uuid
                
                objUserList?.dateOfBirth = user.dob.date
                
                let url = URL(string: user.picture.large)!
                if let imgData = try? Data(contentsOf: url) {
                    objUserList?.profilePic = imgData
                }
                
                CoreDataManager.sharedInstance.saveContextInBG()
            }
            
            self.postNotification("reloadUserList")
        
        
    }
    
    @objc func fetchAllUserData() -> [UserList] {
        
        let arrUserList:[UserList] = ((CoreDataManager.sharedInstance.getObjectsforEntity(strEntity: Constants.CoreDataTables.kUserList, ShortBy: "", isAscending: true, predicate: nil, groupBy: "", taskContext: CoreDataManager.sharedInstance.bGManagedObjectContext) as! NSArray).mutableCopy() as? [UserList])!
        
        return arrUserList
    }
    
    func convertDateFormater(_ strDate: String) -> String
    {
        var strDatetoShow = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let date = dateFormatter.date(from: strDate)!
        dateFormatter.dateFormat = "MMMM d, yyyy"
        strDatetoShow = dateFormatter.string(from: date)
        
        let joinDate = date
        let currentDate = Date()
        
        let calendar = Calendar.current
        if let days = calendar.dateComponents([.day], from: joinDate, to: currentDate).day {
            //print("Number of days since joining: \(days) days")
            if days < 7 {
                strDatetoShow = "\(days) days ago"
            }
            
        } else {
           // print("Failed to calculate the number of days.")
        }
        
        
        return  strDatetoShow
        
    }
    
    func convertDOB(_ strDate: String) -> String
    {
        var strDatetoShow = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let date = dateFormatter.date(from: strDate)!
        dateFormatter.dateFormat = "d MMM yyyy"
        strDatetoShow = dateFormatter.string(from: date)
        
        return  strDatetoShow
        
    }
    
    func calculateAge(from birthdateString: String) -> Int? {
        // Create a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        
        // Parse the birthdate string into a Date object
        if let birthdate = dateFormatter.date(from: birthdateString) {
            // Calculate the age
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: birthdate, to: Date())
            let age = ageComponents.year
            
            return age
        }
        
        // Return nil if the date couldn't be parsed
        return nil
    }
    
}
