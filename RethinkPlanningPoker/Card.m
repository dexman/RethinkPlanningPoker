//
//  Card.m
//  RethinkPlanningPoker
//
//  Created by Arthur Dexter on 2/25/12.
//  Copyright (c) 2012 Arthur Dexter. All rights reserved.
//

#import "Card.h"

@interface Card ()
- (void)refresh;
@end

@implementation Card

@synthesize value;
@synthesize frontHidden;
@synthesize smallFrontHidden;

+ (CGSize)defaultSize {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGSizeMake(180.0f, 250.0f);
    } else {
        return CGSizeMake(90.0f, 125.0f);
    }
}

+ (CGFloat)defaultPadding {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 20.0f;
    } else {
        return 10.0f;
    }
}

+ (Card *)cardWithValue:(NSString *)value {
    CGRect frame = CGRectZero;
    frame.size = [Card defaultSize];
    Card *card = [[Card alloc] initWithFrame:frame];
    card.value = value;
    return card;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        smallFront_ = [[UIImageView alloc] initWithFrame:self.bounds];
        smallFront_.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        smallFront_.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:smallFront_];

        largeFront_ = [[UIImageView alloc] initWithFrame:self.bounds];
        largeFront_.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        largeFront_.hidden = YES;
        largeFront_.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:largeFront_];

        back_ = [[UIImageView alloc] initWithFrame:self.bounds];
        back_.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        back_.hidden = YES;
        back_.image = [UIImage imageNamed:@"card-back"];
        back_.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:back_];
    }
    return self;
}

- (void)setValue:(NSString *)newValue {
    if (newValue != value) {
        value = newValue;
        smallFront_.image = [UIImage imageNamed:[NSString stringWithFormat:@"deck-%@", value]];
        largeFront_.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", value]];
    }
}

- (void)setFrontHidden:(BOOL)newValue {
    if (newValue != frontHidden) {
        frontHidden = newValue;
        [self refresh];
    }
}

- (void)setSmallFrontHidden:(BOOL)newValue {
    if (newValue != smallFrontHidden) {
        smallFrontHidden = newValue;
        [self refresh];
    }
}

- (void)refresh {
    smallFront_.hidden = self.smallFrontHidden || self.frontHidden;
    largeFront_.hidden = !self.smallFrontHidden || self.frontHidden;
    back_.hidden = !self.frontHidden;
}

@end
