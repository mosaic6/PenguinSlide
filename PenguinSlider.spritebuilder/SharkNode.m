//
//  SharkNode.m
//  PenguinSlider
//
//  Created by Joshua T Walsh on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SharkNode.h"

@implementation SharkNode
#define ARC4RANDOM_MAX      0x100000000

// Sets min and max height for stars to be set in view
static const CGFloat minYPosition = 80.f;
static const CGFloat maxYPosition = 320.f;


// Sets a random place for stars in view
- (void)setRandomPosition {
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    CGFloat range = maxYPosition - minYPosition;
    _shark.position = ccp(_shark.position.x, minYPosition + (random * range));
}


- (void)didLoadFromCCB{
    _shark.physicsBody.collisionType = @"shark";
    _shark.physicsBody.sensor = TRUE;
    _shark.position = ccp(_shark.position.x, _shark.position.y);
}
@end
