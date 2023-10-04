

import UIKit

@objc class UserDetailViewController: UIViewController {

    //MARK: - All IBOutlets
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDateJoined: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblPostCode: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    
    //MARK: - Variables
    @objc var strUserUUID: String = ""
    
    
    //MARK: - Lifecycle Events

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CommanMethods.sharedInstance.backButtonTitleRemove(self)
    }
    
    //MARK: - Custom Methods
    
    func fetchAllUserData() {
        
        let objUserList: UserList?
        
        var arrUserList:[UserList]!
        
        var commitPredicate: NSPredicate?
        commitPredicate = NSPredicate(format: "userUUID == %@", strUserUUID)
        
        arrUserList =  (CoreDataManager.sharedInstance.getObjectsforEntity(strEntity: Constants.CoreDataTables.kUserList, ShortBy: "", isAscending: true, predicate: commitPredicate!, groupBy: "", taskContext: CoreDataManager.sharedInstance.bGManagedObjectContext) as! NSArray).mutableCopy() as? [UserList]
        
        if arrUserList.count>0 {
            objUserList = arrUserList.first
            lblEmail.text = objUserList?.email
            lblDateJoined.text = CommanMethods.sharedInstance.convertDateFormater((objUserList?.joinedDate)!)
            lblDOB.text = CommanMethods.sharedInstance.convertDOB((objUserList?.dateOfBirth)!)
            lblCity.text = objUserList?.city
            lblState.text = objUserList?.state
            lblCountry.text = objUserList?.country
            lblPostCode.text = objUserList?.postcode
            imgUserProfile.image = UIImage(data: (objUserList?.profilePic)!)
            self.title = objUserList?.fullName
            lblAge.text = "\(CommanMethods.sharedInstance.calculateAge(from: (objUserList?.dateOfBirth)!) ?? 0)"
        } else {
            
        }
        
        
    }
    
    //MARK: - Button Action
    
    //MARK: - Navigation methods

}
