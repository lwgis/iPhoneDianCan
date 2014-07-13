//
//  TextAlertView.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-26.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TextAlertViewDelegate;

@interface TextAlertView : UIView<UITextViewDelegate>
@property NSInteger code;
@property(nonatomic,retain)UITextView *codeTexView;
@property(nonatomic,assign)id<TextAlertViewDelegate> textAlertViewDelegate;
-(void)show;
@end
@protocol TextAlertViewDelegate <NSObject>

-(void)checkIn:(NSInteger) checkNum;

@end