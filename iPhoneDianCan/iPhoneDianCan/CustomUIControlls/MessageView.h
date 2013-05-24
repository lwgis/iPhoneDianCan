//
//  MessageView.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-4-1.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIView
+(id)messageViewWithMessageText:(NSString *)message;
-(void)show;
-(void)showWithDuration:(NSTimeInterval)duration;

@end
