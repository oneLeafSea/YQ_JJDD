//
//  UITextField+TCStyle.m
//  TC
//
//  Created by 郭志伟 on 15/11/11.
//  Copyright © 2015年 rooten. All rights reserved.
//

#import "UITextField+TCStyle.h"

@implementation UITextField (TCStyle)

- (void) setLabelTextFieldWithlabelName:(NSString *) labelName {
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, self.bounds.size.height / 2, 0, 0)];
    lbl.text = labelName;
    [lbl sizeToFit];
    
    lbl.textColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4.0;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.leftView = lbl;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.textColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    lbl.frame = CGRectMake(10, self.bounds.size.height / 2, lbl.bounds.size.width, lbl.bounds.size.height);
}

@end
