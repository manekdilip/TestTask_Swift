

#import "ListViewController.h"
#import "TestApp-Swift.h"
#import "UserListTableViewCell.h"


@class UserDetailViewController;

@interface ListViewController ()

@end

@implementation ListViewController

@synthesize tblUserList = _tblUserList;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromDB];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadDataFromDB)
                                                     name:@"reloadUserList"
                                                   object:nil];
    [[CommanMethods sharedInstance] getUserListFromAPI];
    // Do any additional setup after loading the view.
}

//MARK: Custom Methods

-(void)loadDataFromDB{
    arrAllUserList = [[CommanMethods sharedInstance]fetchAllUserData];
    NSLog(@"data");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_tblUserList reloadData];
    });
    
}

//MARK: Naviation Methods

-(void) moveToDetailScreen:(NSString *)strUserUUID {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserDetailViewController *objUserDetails = (UserDetailViewController *)[storyboard instantiateViewControllerWithIdentifier: @"UserDetailViewController"];
    objUserDetails.strUserUUID = strUserUUID;
    [self.navigationController pushViewController:objUserDetails animated:YES];
}
//MARK: - Table ViewMethods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    static NSString *CellIdentifier = @"UserListTableViewCell";
    UserListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.lblDate.text = [[CommanMethods sharedInstance]convertDateFormater:[arrAllUserList[indexPath.row] joinedDate]];
    cell.lblUserName.text = [arrAllUserList[indexPath.row] fullName];
    cell.lblUserEmail.text = [arrAllUserList[indexPath.row] email];
    cell.lblCountry.text = [arrAllUserList[indexPath.row] country];
    
    cell.imgProfile.image = [UIImage imageWithData:[arrAllUserList[indexPath.row] profilePic]];
    
    
    
    return  cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return arrAllUserList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self moveToDetailScreen:[arrAllUserList[indexPath.row] userUUID]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == arrAllUserList.count - 10) {
        [[CommanMethods sharedInstance] getUserListFromAPI];
    }
}

@end
