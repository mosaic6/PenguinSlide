//
//  Point.m
//  PenguinSlider
//
//  Created by Joshua Walsh on 6/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StarPoint.h"

@implementation StarPoint

// Collision for each star
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"points";
    self.physicsBody.sensor = TRUE;
}
@end
