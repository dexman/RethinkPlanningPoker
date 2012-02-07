//
//  ViewController.h
//  RethinkPlanningPoker
//
//  Created by Arthur Dexter on 2/1/12.
//  Copyright (c) 2012 Arthur Dexter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Card;

@interface ViewController : UIViewController {
    Card *currentCard_;
    CGRect currentCardGridFrame_;
}

@end
