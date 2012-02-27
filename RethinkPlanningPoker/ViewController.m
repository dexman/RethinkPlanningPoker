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

@implementation ViewController

@synthesize currentCardOriginalFrame;
@synthesize currentCard;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.currentCardOriginalFrame = CGRectNull;

    NSArray *values = [NSArray arrayWithObjects:
                       @"0", @"1-2", @"1", @"2",
                       @"3", @"5", @"8", @"13",
                       @"x", nil];

    const CGSize boundsSize = self.view.bounds.size;
    const CGSize cardSize = [Card defaultSize];
    const CGFloat padding = [Card defaultPadding];
    const NSUInteger columnCount = (boundsSize.width + padding) / (cardSize.width + padding);
    const NSUInteger rowCount = (boundsSize.height + padding) / (cardSize.height + padding);
    const CGPoint inset = CGPointMake(floorf((boundsSize.width - columnCount * (cardSize.width + padding) + padding) / 2.0f),
                                      floorf((boundsSize.height - rowCount * (cardSize.height + padding) + padding) / 2.0f));

    for (NSUInteger i = 0; i < [values count]; ++i) {
        NSUInteger column = i % columnCount;
        NSUInteger row = i / columnCount;

        Card *card = [Card cardWithValue:[values objectAtIndex:i]];
        CGRect cardFrame = card.frame;
        cardFrame.origin.x = floorf(inset.x + column * (cardSize.width + padding));
        cardFrame.origin.y = floorf(inset.y + row * (cardSize.height + padding));
        card.frame = cardFrame;
        [self.view addSubview:card];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deckCardTapped:)];
        [card addGestureRecognizer:tap];
    }
}

- (void)viewDidUnload {
    self.currentCard = nil;
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (self.currentCard && self.currentCard.frontHidden) {
        [self flipToLargeFront:self.currentCard];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)deckCardTapped:(UITapGestureRecognizer *)tap {
    Card *card = (Card *)tap.view;
    if (!card.frontHidden && !card.smallFrontHidden) {
        [self flipToBack:card];
    } else if (card.frontHidden) {
        [self flipToLargeFront:card];
    } else if (!card.frontHidden && card.smallFrontHidden) {
        [self flipToSmallFront:card];
    }
}

- (void)flipToBack:(Card *)card {
    self.currentCardOriginalFrame = card.frame;
    self.currentCard = card;
    [[card superview] bringSubviewToFront:card];
    [self flipCard:card withAnimations:^{
        card.frame = self.view.bounds;
        card.frontHidden = YES;
    }];
}

- (void)flipToLargeFront:(Card *)card {
    [self flipCard:card withAnimations:^{
        card.frontHidden = NO;
        card.smallFrontHidden = YES;
    }];
}

- (void)flipToSmallFront:(Card *)card {
    [self flipCard:card withAnimations:^{
        card.frame = self.currentCardOriginalFrame;
        card.smallFrontHidden = NO;
    }];
    self.currentCardOriginalFrame = CGRectNull;
    self.currentCard = nil;
}

- (void)flipCard:(Card *)card withAnimations:(dispatch_block_t)animations {
    [UIView transitionWithView:card
                      duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:animations
                    completion:NULL];
}

@end
