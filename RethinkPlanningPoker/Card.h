//
//  Card.h
//  RethinkPlanningPoker
//
//  Created by Arthur Dexter on 2/25/12.
//  Copyright (c) 2012 Arthur Dexter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Card : UIView {
    UIImageView *smallFront_;
    UIImageView *largeFront_;
    UIImageView *back_;
}

@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) BOOL frontHidden;
@property (nonatomic, assign) BOOL smallFrontHidden;

+ (CGSize)defaultSize;
+ (CGFloat)defaultPadding;
+ (Card *)cardWithValue:(NSString *)value;

@end
