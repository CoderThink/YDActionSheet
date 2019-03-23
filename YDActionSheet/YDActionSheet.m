//
//  YDActionSheet.m
//  YDActionSheet
//
//  Created by Think on 2019/3/22.
//  Copyright © 2019 Think. All rights reserved.
//

#import "YDActionSheet.h"

static const CGFloat kRowHeight = 48.0f;
static const CGFloat kRowLineHeight = 0.5f;
static const CGFloat kSeparatorHeight = 6.0f;
static const CGFloat kTitleFontSize = 13.0f;
static const CGFloat kButtonTitleFontSize = 18.0f;
static const NSTimeInterval kAnimateDuration = 0.25f;

// 判断是否为iPhone X 系列
#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)

#define tabbarHeight (IS_IPhoneX_All ? 34 : 0)

@interface YDActionSheet ()

/** block回调 */
@property (nonatomic,copy) YDActionSheetBlock actionSheetBlock;

/** 背景视图 */
@property (nonatomic,strong) UIView *backgroundView;

/** 弹出视图 */
@property (nonatomic,strong) UIView *actionSheetView;

@end

@implementation YDActionSheet

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(YDActionSheetBlock)actionSheetBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _actionSheetBlock = actionSheetBlock;
        
        CGFloat actionSheetHeight = 0;
        
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        
        _actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
        _actionSheetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _actionSheetView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        [self addSubview:_actionSheetView];
        
        UIImage *normalImage = [self imageWithColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
        UIImage *highlightedImage = [self imageWithColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        
        if (title && title.length > 0)
        {
            actionSheetHeight += kRowLineHeight;
            
            CGFloat titleHeight = ceil([title boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleFontSize]} context:nil].size.height) + 15*2;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, actionSheetHeight, self.frame.size.width, titleHeight)];
            titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            titleLabel.text = title;
            titleLabel.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
            titleLabel.textColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            titleLabel.numberOfLines = 0;
            [_actionSheetView addSubview:titleLabel];
            
            actionSheetHeight += titleHeight;
        }
        
        if (destructiveButtonTitle && destructiveButtonTitle.length > 0)
        {
            actionSheetHeight += kRowLineHeight;
            
            [self addButtonWithTitle:destructiveButtonTitle height:actionSheetHeight normalImage:normalImage highlightedImage:highlightedImage titleColor:[UIColor colorWithRed:230.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:1.0f] tag:-1];
            
            actionSheetHeight += kRowHeight;
        }
        
        if (otherButtonTitles && [otherButtonTitles count] > 0)
        {
            for (int i = 0; i < otherButtonTitles.count; i++)
            {
                actionSheetHeight += kRowLineHeight;
                
                [self addButtonWithTitle:otherButtonTitles[i] height:actionSheetHeight normalImage:normalImage highlightedImage:highlightedImage titleColor:[UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f] tag:i+1];
                
                actionSheetHeight += kRowHeight;
            }
        }
        
        if (cancelButtonTitle && cancelButtonTitle.length > 0)
        {
            actionSheetHeight += kSeparatorHeight;

            [self addButtonWithTitle:cancelButtonTitle ?: @"取消" height:actionSheetHeight normalImage:normalImage highlightedImage:highlightedImage titleColor:[UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f] tag:0];
            
            actionSheetHeight += kRowHeight + tabbarHeight;
        }
        
        _actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, actionSheetHeight);
    }
    
    return self;
}

- (void)addButtonWithTitle:(NSString *)title height:(CGFloat)height normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage titleColor:(UIColor *)titleColor tag:(NSInteger)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, height, self.frame.size.width, kRowHeight + (tag == 0 ?tabbarHeight:0));
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    button.tag = tag;
    button.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (tag == 0 && IS_IPhoneX_All) {
        [button setTitleEdgeInsets:UIEdgeInsetsMake(-10, 0, 10, 0)];
    }
    [_actionSheetView addSubview:button];
}

+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(YDActionSheetBlock)actionSheetBlock
{
    return [[self alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles handler:actionSheetBlock];
}

+ (void)showActionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(YDActionSheetBlock)actionSheetBlock
{
    YDActionSheet *ydActionSheet = [self actionSheetWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles handler:actionSheetBlock];
    [ydActionSheet show];
}

- (void)show
{
    // 在主线程中处理,否则在viewDidLoad方法中直接调用,会先加本视图,后加控制器的视图到UIWindow上,导致本视图无法显示出来,这样处理后便会优先加控制器的视图到UIWindow上
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [UIView animateWithDuration:kAnimateDuration animations:^{
            self.backgroundView.alpha = 1.0f;
            self.actionSheetView.frame = CGRectMake(0, self.frame.size.height-self.actionSheetView.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
        }];
    });
}

- (void)dismiss
{
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.backgroundView.alpha = 0.0f;
        self.actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.backgroundView];
    if (!CGRectContainsPoint(self.actionSheetView.frame, point))
    {
        if (self.actionSheetBlock)
        {
            self.actionSheetBlock(self, 0);
        }
        
        [self dismiss];
    }
}

- (void)buttonClicked:(UIButton *)button
{
    if (self.actionSheetBlock)
    {
        self.actionSheetBlock(self, button.tag);
    }
    
    [self dismiss];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"YDActionSheet dealloc");
#endif
}

@end
