//
//  SMCFMSectionHeadView.m
//  gdmobiletv
//
//  Created by smc on 16/2/3.
//  Copyright © 2016年 Nanguang Culture Communication(Guangzhou) Limited. All rights reserved.
//

#import "SMCFMSectionFootView.h"

@implementation SMCFMSectionFootView

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)testBtn:(id)sender {
   
    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
    
}

// 获取父类控制器
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
