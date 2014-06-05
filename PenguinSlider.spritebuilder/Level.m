//
//  Level.m
//  PenguinSlider
//
//  Created by Joshua Walsh on 6/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level.h"
@implementation Level



- (void)launchPenguin:(id)sender{
    float launchAngle = CC_DEGREES_TO_RADIANS(_launcher.rotationalSkewY);
    CGPoint directionVector = ccp(sinf(launchAngle), cosf(launchAngle));
    CGPoint launchOffset = ccpMult(directionVector, 90);
    
    [_launcher setPosition:CGPointMake(0.0, 0.0)];

    CCNode *penguin  = [CCBReader load:@"Penguin"];
    penguin.position = ccpAdd(_launcher.position, launchOffset);
    
    [_physicsNode addChild:penguin];
    
    CGPoint force = ccpMult(directionVector, 1000);
    [penguin.physicsBody applyForce:force];
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"pressSound.wav"];
}

@end
