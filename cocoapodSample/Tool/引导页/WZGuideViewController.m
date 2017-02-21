//
//  WZGuideViewController.m
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import "WZGuideViewController.h"

@interface WZGuideViewController ()

@end

@implementation WZGuideViewController

@synthesize animating = _animating;

@synthesize pageScroll = _pageScroll;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

#pragma mark -


- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[WZGuideViewController sharedGuide].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[WZGuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[WZGuideViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[WZGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[WZGuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
	[[WZGuideViewController sharedGuide] hideGuide];
}

#pragma mark - 

+ (WZGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static WZGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
    NSLog(@"pressCheckButton is selected");
    
    
}

//点击进入按钮
- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    LoginViewController   *loginview = [[LoginViewController  alloc]init];
//    QGNavigationController *loginNvc = [[QGNavigationController alloc] initWithRootViewController:loginview];
//
//    appDelegate.window.rootViewController = loginNvc;
////    [appDelegate first];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //将图片组装
    NSArray *imageNameArray = [NSArray arrayWithObjects:@"yindao_1.jpg", @"yindao_2.jpg", @"yindao_3.jpg",@"yindao_4.jpg",@"yindao_5.jpg", nil];
    
    //创建滚动图
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.contentSize = CGSizeMake(SCREEN_WIDTH * imageNameArray.count, SCREEN_HEIGHT);
    [self.view addSubview:self.pageScroll];
    
    
    
    NSString *imgName = nil;
    UIImageView *view = nil;
    
    for (int i = 0; i < imageNameArray.count; i++) {
        imgName = [imageNameArray objectAtIndex:i];
        
//         NSLog(@"-----%@",imgName);
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH * i), 0.f, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imgName]];
        view.image = [UIImage  imageNamed:imgName];
        
        
        [self.pageScroll addSubview:view];
        
        if (i == imageNameArray.count - 1) {
            view.userInteractionEnabled = YES;
//            UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(80.f, 355.f, 15.f, 15.f)];
//            [checkButton setImage:[UIImage imageNamed:@"checkBox_selectCheck"] forState:UIControlStateSelected];
//            [checkButton setImage:[UIImage imageNamed:@"checkBox_blankCheck"] forState:UIControlStateNormal];
//            [checkButton addTarget:self action:@selector(pressCheckButton:) forControlEvents:UIControlEventTouchUpInside];
//            [checkButton setSelected:YES];
//            //[view addSubview:checkButton];
            
            
            UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            enterButton.frame = CGRectMake((SCREEN_WIDTH-120)/2, SCREEN_HEIGHT-100, 120, 60);
            [enterButton setTitle:@"点击进入" forState:(UIControlStateNormal)];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"btn.nor.png"] forState:(UIControlStateNormal)];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:enterButton];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
