

#import <UIKit/UIKit.h>

@protocol TFTableViewDlegate <NSObject>

- (void)TableViewSelectorIndix:(NSString *)str;


@end

@interface TableViewCell : UITableViewCell

@property (nonatomic,strong)NSArray *cellArr;

@property (nonatomic,assign)id<TFTableViewDlegate> delegate;

@end
