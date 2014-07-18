//
//  BearNode.m
//  PenguinSlider
//
//  Created by Joshua Walsh on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "BearNode.h"

@implementation BearNode
#define ARC4RANDOM_MAX      0x100000000

// Sets min and max height for stars to be set in view
static const CGFloat minYPosition = 80.f;
//static const CGFloat maxYPosition = 320.f;


// Sets a random place for stars in view
- (void)setRandomPosition {
//    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
//    CGFloat range = maxYPosition - minYPosition;
//    _bear.position = ccp(_bear.position.x, minYPosition + (random * range));
    _bear.position = ccp(_bear.position.x, minYPosition);
}


- (void)didLoadFromCCB{
    _bear.physicsBody.collisionType = @"bear";
    _bear.physicsBody.sensor = TRUE;
    _bear.position = ccp(_bear.position.x, _bear.position.y);
}
@end
