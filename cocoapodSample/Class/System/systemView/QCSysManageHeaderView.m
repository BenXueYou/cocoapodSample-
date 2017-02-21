//
//  QCSysManageHeaderView.m
//  chargePileManage
//
//  Created by YuMing on 16/6/15.
//  Copyright © 2016年 shQianChen. All rights reserved.
//

#import "QCSysManageHeaderView.h"
#import "YYKit.h"
#import "UIColor+hex.h"
#import "UIGestureRecognizer+Block.h"

@interface QCSysManageHeaderView () <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property (nonatomic,weak) UIView *userView;



@property (nonatomic,weak) UIImageView *bgImage;
@end


@implementation QCSysManageHeaderView

#pragma mark - init

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *bgImage = [[UIImageView alloc] init];
        bgImage.backgroundColor = XYCOLOR(255, 255, 255,1);
        bgImage.layer.borderWidth = 1;
        bgImage.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor lightGrayColor]);
        [self addSubview:bgImage];
        self.bgImage = bgImage;
        [self setupView];

    }
    return self;
}


- (void) setupView
{
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 15, kScreenWidth, 15)];
    userView.backgroundColor = XYCOLOR(246, 246, 246,1);
  
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 14, kScreenWidth, 1)];
    line1.backgroundColor = [UIColor colorWithHex:0XC8C7CC];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, kScreenWidth, 1)];
    line2.backgroundColor = [UIColor colorWithHex:0XC8C7CC];
    [self addSubview:userView];
    [self addSubview:line1];
    [self addSubview:line2];
    
    self.userImageView = [UIImageView new];
    self.userImageView.layer.borderWidth = 1;
    self.userImageView.layer.borderColor = [UIColor colorWithHex:0XC8C7CC].CGColor;
    UIImage *image = nil;
    
    if ([GlobalClass sharedInStance].Image){
        
        _userImageView.image = [[GlobalClass sharedInStance].Image imageByRoundCornerRadius:50 borderWidth:0 borderColor:[UIColor whiteColor]];
        NSLog(@"____++++++++______%@",[GlobalClass sharedInStance].Image );
    }
    else{
        image = [UIImage imageNamed:@"admin"];
        _userImageView.image = [image imageByRoundCornerRadius:50 borderWidth:0 borderColor:[UIColor whiteColor]];
    
    }
    
    _userImageView.frame = CGRectMake((SCREEN_WIDTH - 60)/2, 9, 80, 80);
    _userImageView.layer.cornerRadius = _userImageView.frame.size.width / 2;
    _userImageView.clipsToBounds = YES;
    _userImageView.backgroundColor = [UIColor flatWhiteColor];
    _userImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:_userImageView];
    

    
    UILabel *userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 93, 100, 15)];
    userNameLbl.font = [UIFont systemFontOfSize:14];
     userNameLbl.textAlignment = NSTextAlignmentCenter;
    
    if ([GlobalClass sharedInStance].name.length) {
        userNameLbl.text = [GlobalClass sharedInStance].name;
    }
    else{
        userNameLbl.text = @"我的帐号";
       
    }
    userNameLbl.textColor = [UIColor blackColor];
    [self addSubview:userNameLbl];
    self.userNameLbl = userNameLbl;
    
    
}

#pragma mark - setup frame
- (void) layoutSubviews
{
    [super layoutSubviews];
    _bgImage.frame = self.bounds;
    
}
@end
