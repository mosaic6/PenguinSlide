//
//  HitShark.m
//  PenguinSlider
//
//  Created by Joshua T Walsh on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HitShark.h"

@implementation HitShark
// Collision for each shark
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"shark";
    self.physicsBody.sensor = TRUE;
}
@end
