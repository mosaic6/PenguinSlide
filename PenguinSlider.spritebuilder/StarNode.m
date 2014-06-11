//
//  StarNode.m
//  PenguinSlider
//
//  Created by Joshua Walsh on 6/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StarNode.h"

@implementation StarNode
#define ARC4RANDOM_MAX      0x100000000

static const CGFloat minYPosition = 44.f;

static const CGFloat maxYPosition = 300.f;

//static const CGFloat startPosition = 200.f;

//static const CGFloat starDistance = 123.f;

- (void)setRandomPosition {
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    CGFloat range = maxYPosition - minYPosition;
    _star.position = ccp(_star.position.y, minYPosition + (random * range));
}

- (void)didLoadFromCCB{
    _star.physicsBody.collisionType = @"point";
    _star.physicsBody.sensor = TRUE;
    
}
@end
