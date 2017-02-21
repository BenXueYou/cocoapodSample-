//
//  QCPersonalInfoCell.m
//  chargePileManage
//
//  Created by YuMing on 16/6/17.
//  Copyright © 2016年 shQianChen. All rights reserved.
//

#import "QCPersonalInfoCell.h"

// third lib
#import "UIColor+hex.h"
#import "YYKit.h"

#import "QCPersonInfoArrowModel.h"
#import "QCPersonInfoLabelModel.h"
#import "QCPersonInfoSwitchModel.h"
#import "QCPersonInfoIconModel.h"
#import "QCPersonInfoSegmentModel.h"

#import "GlobalClass.h"


@interface QCPersonalInfoCell ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
/**
 *  箭头
 */
@property (nonatomic,strong) UIImageView *arrowView;
/**
 *  头像
 */
@property (nonatomic,strong) UIImageView *iconView;
/**
 *  性别选择
 */
@property (nonatomic,strong) UISegmentedControl *segmentedView;
//@property (nonatomic,copy) NSString *sex;

/**
 *  开关
 */
@property (nonatomic,strong) UISwitch *switchView;
/**
 *  标签
 */
@property (nonatomic,strong) UILabel *labelView;

@end


@implementation QCPersonalInfoCell

#pragma - MARK ClickFunction
- (void)switchStateChange
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.switchView.isOn forKey:self.item.title];
    [defaults synchronize];
}
- (void)charge:(UISegmentedControl *)segmented
{
    NSLog(@"点击了segmented");
//    NSString *sex = [[NSString alloc] init];
    if (segmented.selectedSegmentIndex) {
        
        
        _item.gender = 1;
        
        [GlobalClass sharedInStance].gender = @"woman";
    }
    else{
         _item.gender = 0;
        [GlobalClass sharedInStance].gender = @"man";;
    }

}
#pragma - MARK SetupView
- (void)setData
{
    
    if(self.item.image){
    
        self.iconView.image = self.item.image;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width, 10)];
        line.backgroundColor = XYCOLOR(226, 226, 226,1);
        [self.contentView addSubview:line];
    }
    else{
        self.iconView.image = [GlobalClass sharedInStance].Image;
    }
  
    if (self.item.title.length == 0) {
        
        self.textLabel.text = [GlobalClass sharedInStance].name;
    }
    self.textLabel.text = self.item.title;
    
    self.detailTextLabel.text = self.item.subTitle;
}
- (void)setRightContent
{
    if ([self.item isKindOfClass:[QCPersonInfoArrowModel class]]) { // 箭头
        self.accessoryView = self.arrowView;
    } else if ([self.item isKindOfClass:[QCPersonInfoSwitchModel class]]) { // 开关
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.switchView.on = [defaults boolForKey:self.item.title];
    } else if ([self.item isKindOfClass:[QCPersonInfoLabelModel class]]) { // 标签
        self.accessoryView = self.labelView;
    } else if ([self.item isKindOfClass:[QCPersonInfoIconModel class]]) {
        self.accessoryView = self.iconView;
    } else if ([self.item isKindOfClass:[QCPersonInfoSegmentModel class]]) {
        self.accessoryView = self.segmentedView;
    } else {
        self.accessoryView = nil;
    }
}
#pragma mark - initCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"QCPersonalInfoCell";
    QCPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[QCPersonalInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
#pragma mark - getters and setters
- (void)setItem:(QCPersonInfoModel *)item
{
    _item = item;
    // 1.设置数据
    [self setData];
    // 2.设置右边按钮
    [self setRightContent];
}
- (UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    return _arrowView;
}
- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchStateChange) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}
- (UIImageView *)iconView
{
    if (_iconView == nil) {
        
        _iconView = [UIImageView new];
        _iconView.userInteractionEnabled = YES;
        
        UIImage *image = nil;
        if (_item.image) {
            image = [GlobalClass sharedInStance].Image;
        } else {
            image = _item.image;
        }
        

        _iconView.image = [image imageByRoundCornerRadius:60 borderWidth:0 borderColor:[UIColor whiteColor]];
        
        _iconView.frame = CGRectMake(0, 0, 60, 60);
        
        _iconView.layer.cornerRadius = _iconView.frame.size.width / 2;
        _iconView.clipsToBounds = YES;
        _iconView.backgroundColor = [UIColor flatWhiteColor];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        
                
        [_iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            
            NSLog(@"==========切换头像");
            UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                            initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
            [myActionSheet showInView:self.superview];
            
        }]];
    }
    return _iconView;
}

- (UISegmentedControl *)segmentedView
{
    if (_segmentedView == nil) {
        CGFloat segmentedHeight = 25;
        NSArray *array=@[@"男",@"女"];
        _segmentedView = [[UISegmentedControl alloc] initWithItems:array];
        _segmentedView.frame = CGRectMake(0, 0, 60, segmentedHeight);
        
        if (_item.gender == 0) {
            _segmentedView.selectedSegmentIndex = 0;
        } else {
            _segmentedView.selectedSegmentIndex = 1;
        }
        
        _segmentedView.tintColor = [UIColor colorWithHex:0x299dff];
        [_segmentedView addTarget:self action:@selector(charge:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentedView;
}
#pragma - mark UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }

    switch (buttonIndex) {
        case 0: {
            [self takePhoto];
            break;
        }
        case 1: {
            [self localPhoto];
            break;
        }
        default: {
            break;
        }
    }
}
#pragma - mark UIImagePickDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.iconView.image = [image imageByRoundCornerRadius:50 borderWidth:0 borderColor:[UIColor whiteColor]];
    
//    将获取的图片保存个人信息model
    self.item.image = image;
    
    [GlobalClass sharedInStance].Image = image;
    
    NSLog(@"++++++++%@",[GlobalClass sharedInStance].Image);
    
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
}
#pragma - mark private method
- (void) takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {

        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [[self viewController] presentViewController:picker animated:YES completion:nil];

    } else {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
- (void) localPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [[self viewController] presentViewController:picker animated:YES completion:nil];
}
// 得到viewController
- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
