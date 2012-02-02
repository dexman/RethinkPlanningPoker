//
//  Card.m
//  RethinkPlanningPoker
//
//  Created by Arthur Dexter on 2/2/12.
//  Copyright (c) 2012 Arthur Dexter. All rights reserved.
//

#import "Card.h"
#import <QuartzCore/QuartzCore.h>

@implementation Card

@synthesize frontShowing;

+ (CGFloat)fontRatio {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 4.0f;
    } else {
        return 3.0f;
    }
}

+ (CGFloat)cornerRadius {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 8.0f;
    } else {
        return 4.0f;
    }
}

+ (CGFloat)aspectRatio {
    return 0.7f;
}

+ (CGSize)cardSizeThatFits:(CGSize)size rows:(NSUInteger)rows columns:(NSUInteger)columns {
    CGSize result = CGSizeZero;
    result.width = floorf(size.width / (CGFloat) rows);
    result.height = floorf(size.height / (CGFloat) columns);
    if (result.width / [Card aspectRatio] < result.height) {
        result.height = floorf(result.width / [Card aspectRatio]);
    } else if (result.width / [Card aspectRatio] > result.height) {
        result.width = floorf(result.height * [Card aspectRatio]);
    }
    return result;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = [Card cornerRadius];

        front_ = [[UIView alloc] initWithFrame:CGRectZero];
        front_.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:front_];

        label_ = [[UILabel alloc] initWithFrame:CGRectZero];
        label_.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        label_.hidden = YES;
        label_.textAlignment = UITextAlignmentCenter;
        [front_ addSubview:label_];

        imageView_ = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView_.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        imageView_.contentMode = UIViewContentModeScaleAspectFit;
        imageView_.hidden = YES;
        [front_ addSubview:imageView_];

        back_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card-back"]];
        back_.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        back_.contentMode = UIViewContentModeScaleAspectFit;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];

        frontShowing = YES;
    }
    return self;
}

- (void)layoutSubviews {
    CGRect bounds = self.bounds;
    front_.frame = bounds;
    back_.frame = bounds;

    label_.hidden = [label_.text length] == 0;
    if (!label_.hidden) {
        CGFloat fontSize = roundf(bounds.size.height / [Card fontRatio]);
        label_.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
        label_.frame = CGRectInset(bounds, [Card cornerRadius], [Card cornerRadius]);
    }

    imageView_.hidden = imageView_.image == nil;
    if (!imageView_.hidden) {
        CGFloat side = roundf(bounds.size.height / [Card fontRatio]);
        imageView_.frame = CGRectMake(floorf(CGRectGetMidX(bounds) - side / 2.0f),
                                  floorf(CGRectGetMidY(bounds) - side / 2.0f),
                                  side, side);
    }
}

- (NSString *)text {
    return label_.text;
}

- (void)setText:(NSString *)text {
    label_.text = text;
}

- (UIImage *)image {
    return imageView_.image;
}

- (void)setImage:(UIImage *)image {
    imageView_.image = image;
}

- (void)tapped:(UIGestureRecognizer *)tap {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)setFrontShowing:(BOOL)value {
    if (value != frontShowing) {
        frontShowing = value;
        [UIView transitionWithView:self
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            if (frontShowing) {
                                [back_ removeFromSuperview];
                                [self addSubview:front_];
                            } else {
                                [front_ removeFromSuperview];
                                [self addSubview:back_];
                            }
                        }
                        completion:NULL];
    }
}

@end
