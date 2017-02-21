//
//  QCChooseRecordCtrl.m
//  chargePileManage
//
//  Created by YuMing on 16/7/8.
//  Copyright © 2016年 shQianChen. All rights reserved.
//

#import "QCChooseRecordCtrl.h"
#import "QCSearchREcordModel.h"
#import "UUDatePicker.h"
#import "UIColor+hex.h"
@interface QCChooseRecordCtrl () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *chargeRecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *supplyRecordBtn;
- (IBAction)chargeRecord;
- (IBAction)supplyRecord;
@property (weak, nonatomic) IBOutlet UITextField *checkWord;
- (IBAction)searchRecord;
@property (weak, nonatomic) IBOutlet UITextField *beginTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeField;

@property (strong, nonatomic) IBOutlet UIView *topView;

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) QCSearchRecordModel *searchModel;


@property (nonatomic,assign) float textTag;


@property (nonatomic,assign) float keyHeight;
@end

@implementation QCChooseRecordCtrl


- (UISearchBar *)searchBar{

    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(40, 27, SCREEN_WIDTH - 67, 30)];
    }
    return _searchBar;

}



#pragma - mark systemViewEvent
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigation];
    
    self.view.backgroundColor = XYCOLOR(246, 246, 246, 1);
    
    if (self.selectedIndex == 1) {
        self.chargeRecordBtn.backgroundColor = [UIColor whiteColor];
        self.supplyRecordBtn.backgroundColor = [UIColor colorWithHex:0x299dff];

    }else{
    
        self.supplyRecordBtn.backgroundColor = [UIColor whiteColor];
        self.chargeRecordBtn.backgroundColor = [UIColor colorWithHex:0x299dff];
        
            }
    
    [self setupView];
}

-(void)setNavigation{
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:(UIBarButtonItemStyleDone) target:self action: @selector(back)];
    
    self.navigationItem.leftBarButtonItem = button;
}

-(void)back{
    
    //    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
}
#pragma - mark keyBoardEvent

- (void) keyBoardDidShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    
    self.keyHeight = height;
    
    if (self.textTag == 3) {
        CGRect scrollViewFrame = self.topView.frame;
        scrollViewFrame.origin = CGPointMake(scrollViewFrame.origin.x, scrollViewFrame.origin.y - self.keyHeight/2);
        self.topView.frame = scrollViewFrame;
    }
    
   
    
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    
}
- (void) keyBoardDidHide:(NSNotification *) notif
{
    //当键盘隐藏的时候，将scrollView重新放下来
//    CGRect scrollViewFrame = self.topView.frame;
//    scrollViewFrame.origin = CGPointMake(scrollViewFrame.origin.x, scrollViewFrame.origin.y + 30);
//    self.topView.frame = scrollViewFrame;
    
}
#pragma - mark initUI
- (void) setupBtnBackGroud:(UIButton *)btn
{
    btn.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);

    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [XYCOLOR(154, 154, 154, 1) CGColor];
}
- (void) setupView
{
    [self setupBtnBackGroud:_chargeRecordBtn];
    [self setupBtnBackGroud:_supplyRecordBtn];
    
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY年MM月dd日"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    _beginTimeField.text = locationString;
    _endTimeField.text = locationString;
    
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *modelStr=[dateformatter stringFromDate:senddate];
    self.searchModel.searchType = @"充电记录";
    self.searchModel.beginTime = modelStr;
    self.searchModel.endTime = modelStr;

    
    UUDatePicker *beginDatePicker = [[UUDatePicker alloc] initWithframe:CGRectMake(0, 0, 320, 200) PickerStyle:UUDateStyle_YearMonthDay didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
            NSLog(@"%@年%@月%@日",year,month,day);
            _beginTimeField.text = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
            self.searchModel.beginTime = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    }];
    
    _beginTimeField.inputView   = beginDatePicker;
    
    UUDatePicker *endDatePicker = [[UUDatePicker alloc] initWithframe:CGRectMake(0, 0, 320, 200) PickerStyle:UUDateStyle_YearMonthDay didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
            NSLog(@"%@年%@月%@日",year,month,day);
        
            _endTimeField.text = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
        
            self.searchModel.endTime = [NSString stringWithFormat:@"%@%@%@",year,month,day];
        }];
        _endTimeField.inputView     = endDatePicker;
    
        _beginTimeField.delegate = self;
        _endTimeField.delegate = self;
        _checkWord.delegate = self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma - mark UITextFileDelegate
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{

    
    if (textField == _beginTimeField) {
        NSLog(@"_beginTimeField");
       
        self.textTag = 1;
        
    } else if (textField == _endTimeField) {
        NSLog(@"_endTiemField");
        
        self.textTag = 2;
        
    } else {
        NSLog(@"_checkWord");
        
        self.textTag = 3;
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"点击确定按钮！！！");
    [_checkWord resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma - mark BTN_FUN
- (IBAction)searchRecord {
    NSLog(@"%s",__func__);
    
    self.searchModel.searchWord = _checkWord.text;
    // 按下按键后，通知代理
    if ([self.delegate respondsToSelector:@selector(searchRecord:)]) {
        
        if (_checkWord.text) {
            self.searchModel.searchWord = _checkWord.text;
        } else {
            self.searchModel.searchWord = @"";
        }
        [self.delegate searchRecord:self.searchModel];
    }
    // 让控制器成为WQTabBar代理，就可以监控WQTabBar的动作了
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (IBAction)chargeRecord {
    NSLog(@"%s",__func__);
    _chargeRecordBtn.backgroundColor = XYCOLOR(41, 155, 255, 1);
    _supplyRecordBtn.backgroundColor = [UIColor clearColor];
    
     
    self.searchModel.searchType = @"充电记录";
}

- (IBAction)supplyRecord {
    
    NSLog(@"%s",__func__);
    _chargeRecordBtn.backgroundColor = [UIColor clearColor];
    _supplyRecordBtn.backgroundColor = XYCOLOR(41, 155, 255, 1);;
    
  
    self.searchModel.searchType = @"故障记录";
}

#pragma - mark sets and gets
- (QCSearchRecordModel *)searchModel
{
    if (_searchModel == nil) {
        _searchModel = [QCSearchRecordModel new];
        _searchModel.searchType = @"充电记录";
    }
    return _searchModel;
}
@end
