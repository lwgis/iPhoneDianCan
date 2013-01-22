//
//  TabView.h
//  iPhoneDianCan
//
//  Created by 李炜 on 13-1-4.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyTabBarDelegate <NSObject>
-(void)tabWasSelected:(NSInteger) index;
-(void)updateContentViewSizeWithHidden:(BOOL) hidden;
@end
@interface TabView : UIImageView
@property(nonatomic,assign) NSObject<MyTabBarDelegate> *delegate;
-(void)setTabViewHidden:(BOOL) hidden;//设置自定义tabview是否可见

@end
