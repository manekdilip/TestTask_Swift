

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserListTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblUserName;
@property (nonatomic, strong) IBOutlet UILabel *lblUserEmail;
@property (nonatomic, strong) IBOutlet UILabel *lblCountry;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIImageView *imgProfile;

@end

NS_ASSUME_NONNULL_END
