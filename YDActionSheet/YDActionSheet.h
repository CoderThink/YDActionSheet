//
//  YDActionSheet.h
//  YDActionSheet
//
//  Created by Think on 2019/3/22.
//  Copyright © 2019 Think. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDActionSheet;

typedef void(^YDActionSheetBlock)(YDActionSheet *actionSheet,NSInteger index);

@interface YDActionSheet : UIView

- (instancetype) init NS_UNAVAILABLE;

- (instancetype) initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 弹出视图

 @param title                  提示文本
 @param cancelButtonTitle      取消按钮文本
 @param destructiveButtonTitle 删除按钮文本
 @param otherButtonTitles      其他按钮文本
 @param actionSheetBlock       block回调
 */
+ (void)showActionSheetWithTitle:(NSString *)title
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSArray *)otherButtonTitles
                         handler:(YDActionSheetBlock)actionSheetBlock;

@end

