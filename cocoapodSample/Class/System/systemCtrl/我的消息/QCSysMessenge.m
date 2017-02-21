//
//  QCSysMessenge.m
//  cocoapodSample
//
//  Created by cnc on 16/9/5.
//  Copyright © 2016年 QC-朋学友. All rights reserved.
//

#import "QCSysMessenge.h"

@interface QCSysMessenge ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UISegmentedControl *segmentView;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UITableView *adminTableView;
@property (nonatomic,strong) UITableView *replyTableView;
@end

@implementation QCSysMessenge

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setScrollView];
    [self setSegmentControl];
    [self loadScrollView];
    
}

-(void)setScrollView{

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    
}

-(void)setSegmentControl{

    CGFloat segmentH = 40;
    CGFloat segmentX = 20;
    CGFloat segmentY = 5;
    NSArray *array = @[@"管理员消息",@"回复消息"];
    UISegmentedControl *segmentedView = [[UISegmentedControl alloc] initWithItems:array];
    segmentedView.selectedSegmentIndex = 0;
    segmentedView.tintColor = [UIColor colorWithHex:0x299dff];
    [segmentedView addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentedView.frame = CGRectMake(segmentX, segmentY, SCREEN_WIDTH - 2 * segmentX, segmentH);
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:segmentedView];
    self.segmentView = segmentedView;
    
    [self setNavigation];
}


-(void)loadScrollView{
    CGFloat AdminTableviewH = SCREEN_HEIGHT - 64 - 40;
    CGFloat AdminTableviewX = 0;
    CGFloat AdminTableviewY = 50;
    
    UITableView *AdminTableView = [[UITableView alloc] initWithFrame:CGRectMake(AdminTableviewX, AdminTableviewY, SCREEN_WIDTH, AdminTableviewH) style:(UITableViewStylePlain)];
    AdminTableView.delegate = self;
    AdminTableView.dataSource = self;
    self.adminTableView = AdminTableView;
    [self.adminTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AdminCell"];
    [self.scrollView addSubview:AdminTableView];
    
    
    UITableView *replyTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, AdminTableviewY, SCREEN_WIDTH, AdminTableviewH) style:(UITableViewStylePlain)];
    
    replyTableView.delegate = self;
    replyTableView.dataSource = self;
    
    self.replyTableView = replyTableView;
  
    [self.replyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"replyCell"];
    [self.scrollView addSubview:replyTableView];
    
}


-(void)segmentAction:(UISegmentedControl *)segment{

    if (segment.selectedSegmentIndex == 0) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else{
    
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
    self.scrollView.bouncesZoom = NO;

}


#pragma mark -----UIScrollViewDelegate-----
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.x < SCREEN_WIDTH / 2) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (scrollView.contentOffset.x >= SCREEN_WIDTH / 2){
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
    else{
    
    }
}

#pragma mark ----UITableVieDelelgate-----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.adminTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdminCell"];
        return cell;
    }
   
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"replyCell"];
        return cell;
}


//返回按钮
-(void)setNavigation{
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:(UIBarButtonItemStyleDone) target:self action: @selector(back)];
    
    self.navigationItem.leftBarButtonItem = button;
}

-(void)back{
    
    //    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
