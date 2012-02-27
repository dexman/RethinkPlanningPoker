//
//  ViewController.h
//  RethinkPlanningPoker
//
//  Created by Arthur Dexter on 2/1/12.
//  Copyright (c) 2012 Arthur Dexter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Card;

@interface ViewController : UIViewController

@property (nonatomic, assign) CGRect currentCardOriginalFrame;
@property (nonatomic, assign) Card *currentCard;

- (void)flipToBack:(Card *)card;
- (void)flipToLargeFront:(Card *)card;
- (void)flipToSmallFront:(Card *)card;
- (void)flipCard:(Card *)card withAnimations:(dispatch_block_t)animations;

@end
