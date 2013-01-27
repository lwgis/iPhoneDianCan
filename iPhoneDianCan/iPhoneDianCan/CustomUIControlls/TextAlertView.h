//
//  TextAlertView.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-26.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextAlertView : UIAlertView
@property NSInteger code;
@property(nonatomic,retain)UITextView *codeTexView;
@end
