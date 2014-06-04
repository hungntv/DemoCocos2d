//
//  MyScene.m
//  DemoCocos2d
//
//  Created by VietHung on 6/4/14.
//  Copyright (c) 2014 HDSoft. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene {
    CCPhysicsNode *_physicsNode;
}

+ (instancetype)scene {
    return [[self alloc] init];
}

- (void)onEnter {
    [super onEnter];
    glClearColor(0.1, 0.1, 0.1, 1.0);
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"newton.plist"];
    
    _physicsNode = [CCPhysicsNode node];
    _physicsNode.gravity = ccp(0, 3*-980.665);
    _physicsNode.debugDraw = YES;
    [self addChild:_physicsNode];
    
    // create an outline of the basic physics node, to keep physics "in door"
    CCNode *outline = [CCNode node];
    outline.contentSize = CGSizeMake(280, 300);
    outline.anchorPoint = ccp(0.5, 0.5);
    outline.position = ccp(160, 284);
    
    outline.physicsBody = [CCPhysicsBody bodyWithPolylineFromRect:CGRectMake(0, 0, 280, 300) cornerRadius:3];
    outline.physicsBody.friction = 1.f;
    outline.physicsBody.elasticity = 0.5f;
    outline.physicsBody.collisionCategories = @[@"outline"];
    outline.physicsBody.collisionMask = @[@"sphere", @"rope"];
    [_physicsNode addChild:outline];
    
    for (int i = 0; i < 20; i++) {
        CCSprite *sprite = [CCSprite spriteWithImageNamed:@"letter.o.png"];
        sprite.anchorPoint = ccp(0.5,0.5);
        sprite.position = ccp(160, 284);
        
        CCPhysicsBody *body =
        [CCPhysicsBody bodyWithCircleOfRadius:25
                                    andCenter:ccp(sprite.contentSize.width/2,sprite.contentSize.height/2)];
        sprite.physicsBody = body;
        
        body.friction = 0.5;
        body.elasticity = 1.0;
        body.collisionCategories = @[@"sphere"];
        body.collisionMask = @[@"sphere", @"outline"];
        
        [_physicsNode addChild:sprite];
    }
    
    //rotate
    [outline runAction:
     [CCActionRepeatForever actionWithAction:
      [CCActionSequence actionWithArray:@[[CCActionRotateTo actionWithDuration:1 angle:180],
                                          [CCActionRotateTo actionWithDuration:1 angle:360]]]]];
    
    // add a reset button
    CCButton *resetButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"reset.png"]];
    resetButton.positionType = CCPositionTypeNormalized;
    resetButton.position = (CGPoint){0.90f, 0.80f};;
    [resetButton setTarget:self selector:@selector(onResetClicked:)];
    [self addChild:resetButton];
}

- (void)onResetClicked:(id)sender
{
    // recreate the scene
    [[CCDirector sharedDirector] replaceScene:[self.class scene]];
}

@end
