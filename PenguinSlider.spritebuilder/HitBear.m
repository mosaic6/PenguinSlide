//
//  HitBear.m
//  PenguinSlider
//
//  Created by Joshua Walsh on 7/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HitBear.h"

@implementation HitBear
// Collision for each bear
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"bear";
    self.physicsBody.sensor = TRUE;
}
@end
