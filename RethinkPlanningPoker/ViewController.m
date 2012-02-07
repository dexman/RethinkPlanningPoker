//
//  ViewController.m
//  RethinkPlanningPoker
//
//  Created by Arthur Dexter on 2/1/12.
//  Copyright (c) 2012 Arthur Dexter. All rights reserved.
//

#import "ViewController.h"
#import "Card.h"
#import <QuartzCore/QuartzCore.h>

static const NSUInteger kRows = 4;
static const NSUInteger kColumns = 4;
static const CGFloat kMinPadding = 10.0f;

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *values = [NSArray arrayWithObjects:
                       @"0", @"1/2", @"1", @"2",
                       @"3", @"5", @"8", @"13",
                       @"21", @"34", @"55", @"89",
                       @"?", [UIImage imageNamed:@"coffee"], nil];

    const CGSize boundsSize = self.view.bounds.size;
    const CGSize cardSize = [Card cardSizeThatFits:CGSizeMake(boundsSize.width - (kColumns + 1) * kMinPadding,
                                                              boundsSize.height - (kRows + 1) * kMinPadding)
                                              rows:kRows
                                           columns:kColumns];
    const CGSize cardPadding = CGSizeMake((boundsSize.width - kColumns * cardSize.width) / (kColumns + 1),
                                          (boundsSize.height - kRows * cardSize.height) / (kRows + 1));
    for (NSUInteger i = 0; i < [values count]; ++i) {
        NSUInteger rowIndex = i / kRows;
        NSUInteger columnIndex = i % kColumns;
        CGRect frame = CGRectMake(cardPadding.width + columnIndex * (cardPadding.width + cardSize.width), 
                                  cardPadding.height + rowIndex * (cardPadding.height + cardSize.height),
                                  cardSize.width,
                                  cardSize.height);
        Card *card = [[Card alloc] initWithFrame:frame];
        [card addTarget:self action:@selector(cardTouched:) forControlEvents:UIControlEventTouchUpInside];

        id value = [values objectAtIndex:i];
        if ([value isKindOfClass:[NSString class]]) {
            card.text = value;
        } else if ([value isKindOfClass:[UIImage class]]) {
            card.image = value;
        }
        [self.view addSubview:card];
    }

    currentCard_ = nil;
    currentCardGridFrame_ = CGRectNull;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (currentCard_ && !currentCard_.frontShowing) {
        currentCard_.frontShowing = YES;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)cardTouched:(Card *)card {
    [self.view bringSubviewToFront:card];
    if (!currentCard_) {
        currentCard_ = card;
        currentCardGridFrame_ = card.frame;
        card.frontShowing = NO;
        [UIView animateWithDuration:0.5
                         animations:^{
                             CGRect result = self.view.bounds;
                             result.size = [Card cardSizeThatFits:result.size rows:1 columns:1];
                             result.origin.x = floorf(self.view.bounds.size.width - result.size.width) / 2.0f;
                             result.origin.y = floorf(self.view.bounds.size.height - result.size.height) / 2.0f;
                             card.frame = result;
                         }];
    } else {
        if (!card.frontShowing) {
            card.frontShowing = YES;
        } else {
            CGRect frame = currentCardGridFrame_;
            currentCardGridFrame_ = CGRectNull;
            [UIView animateWithDuration:0.2
                             animations:^{
                                 card.frame = frame;
                             }];
        }
    }
}

@end
