
//屏幕宽和高
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#import "TableViewCell.h"

@implementation TableViewCell

- (void)setCellArr:(NSArray *)cellArr{
    
    _cellArr = cellArr;
    CGFloat w = (kScreenWidth-30)/3;
    for (int i = 0; i < cellArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15+i%3*w, 15+i/3*45, w-15, 30);
        [btn setTitle:cellArr[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:2.0f];
        [btn.layer setBorderColor:[UIColor colorWithWhite:0.8 alpha:1.0].CGColor];
        [btn.layer setBorderWidth:1.0f];

        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //btn.backgroundColor = [UIColor grayColor];
        [self addSubview:btn];
    }
    
}

- (void)btnClick:(UIButton *)btn{
    
    
        [self.delegate TableViewSelectorIndix:btn.titleLabel.text];
    
    

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
