

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface ListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSArray * arrAllUserList;
}

@property(nonatomic, strong) IBOutlet UITableView *tblUserList;


@end

NS_ASSUME_NONNULL_END
