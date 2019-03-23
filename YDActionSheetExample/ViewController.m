//
//  ViewController.m
//  YDActionSheet
//
//  Created by Think on 2019/3/23.
//  Copyright © 2019 Think. All rights reserved.
//

#import "ViewController.h"
#import "YDActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [YDActionSheet showActionSheetWithTitle:@"提示"
                          cancelButtonTitle:@"取消"
                     destructiveButtonTitle:@"删除"
                          otherButtonTitles:@[@"第一项", @"第二项", @"第三项"]
                                    handler:^(YDActionSheet *actionSheet, NSInteger index) {
                                        NSLog(@"%ld", index);
                                    }];
}


@end
