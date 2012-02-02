//
//  Card.h
//  RethinkPlanningPoker
//
//  Created by Arthur Dexter on 2/2/12.
//  Copyright (c) 2012 Arthur Dexter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Card : UIControl {
    UIView *front_;
    UILabel *label_;
    UIImageView *imageView_;
    UIImageView *back_;
}

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) BOOL frontShowing;

+ (CGSize)cardSizeThatFits:(CGSize)size rows:(NSUInteger)rows columns:(NSUInteger)columns;

@end
