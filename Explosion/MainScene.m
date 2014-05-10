//
//  mainScene.m
//  Explosion
//
//  Created by NickPiatt on 5/4/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import "mainScene.h"

@implementation MainScene
{
    SKSpriteNode *_bgSprite;
    
    SKSpriteNode *_playSprite;
    SKSpriteNode *_safeSprite;
    SKSpriteNode *_dangerSprite;
    
    SKLabelNode *_decisionLabel;
    
    SKSpriteNode *_resetSprite;
    
    int _sizeMod;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:60.0f/255.0f green:166.0f/255.0f blue:238.0f/255.0f alpha:1.0];
        
        _sizeMod = self.size.height-24;
        
        AppDelegate *aDelegate = DELEGATE;
        aDelegate.userLogin = @"Nick Piatt";
        
        [self setupUI];
    }
    return self;
}

-(void)optionBoxSelected:(SKSpriteNode*)oBox
{
//    CGFloat actionDuration = .25;
//    SKAction *waitAction = [SKAction waitForDuration:.25];
//    
//    SKAction *scaleAction = [SKAction scaleBy:1.5 duration:actionDuration];
//    SKAction *actionSequence = [SKAction sequence:@[waitAction, scaleAction]];
//    
//    SKAction *moveUpAction = [SKAction moveByX:0 y:25 duration:.25];
//    SKAction *moveSequence = [SKAction sequence:@[waitAction, moveUpAction]];
//    [self runActionOnOptionBoxes:moveSequence];
    
//    [oBox runAction:actionSequence completion:^{
        //[self spawnDecisionAtNode:oBox];
//    }];
    
    
}

-(void)runActionOnOptionBoxes:(SKAction*)nodeAction
{
    [_safeSprite runAction:nodeAction];
    [_playSprite runAction:nodeAction];
    [_dangerSprite runAction:nodeAction];
}

-(void)setupUI
{
//    int sizeMod = self.size.height-24;
    
    _bgSprite = [SKSpriteNode spriteNodeWithImageNamed:@"foodora_quicksketch.jpg"];
    _bgSprite.size = CGSizeMake(320, 312);
    _bgSprite.anchorPoint = CGPointZero;
    _bgSprite.position = CGPointMake(0, _sizeMod-_bgSprite.size.height);
    _bgSprite.name = @"bgSprite";
    
    [self addChild:_bgSprite];

    _playSprite = [SKSpriteNode spriteNodeWithImageNamed:@"play70x40"];
    _playSprite.size = CGSizeMake(102, 60);
    _playSprite.position = CGPointMake(58, _sizeMod-338);
    _playSprite.name = @"playSprite";
    
    [self addChild:_playSprite];
    
    _safeSprite = [SKSpriteNode spriteNodeWithImageNamed:@"safe60x35"];
    _safeSprite.size = CGSizeMake(94, 59);
    _safeSprite.position = CGPointMake(154, _sizeMod-340);
    _safeSprite.name = @"safeSprite";
    
    [self addChild:_safeSprite];
    
    _dangerSprite = [SKSpriteNode spriteNodeWithImageNamed:@"danger90x40"];
    _dangerSprite.size = CGSizeMake(127, 59);
    _dangerSprite.position = CGPointMake(260, _sizeMod-340);
    _dangerSprite.name = @"dangerSprite";
    
    [self addChild:_dangerSprite];
    
    CGFloat actionSpeed = 1;
    SKAction *wiggleAction = [SKAction rotateByAngle:M_PI/64 duration:actionSpeed/2];
    SKAction *wiggleSeq = [SKAction repeatActionForever:[SKAction sequence:@[[wiggleAction reversedAction], [wiggleAction reversedAction], wiggleAction, wiggleAction]]];
    
    
//    [_playSprite runAction:wiggleSeq];
//    [_safeSprite runAction:wiggleSeq];
//    [_dangerSprite runAction:wiggleSeq];
    
}

-(void)spawnDecisionAtNode:(SKSpriteNode*)node
{    
    BOOL addToView = FALSE;
    if (_decisionLabel == nil) {
        _decisionLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        addToView = TRUE;
    }
    
    _decisionLabel.text = [NSString stringWithFormat:@"A %@ decision!", node.name];
    // TODO:
    _decisionLabel.fontSize = 1;
    _decisionLabel.position = node.position;
    
    
    /*
     Have to do it this way because the node is originally made at proper size so I can't add it til
     I set all the properties. Easier to just break up the IF statement and add it at the end only if
     it needs to be added.
     */
    if (addToView) {
        [self addChild:_decisionLabel];
    }
    
    
    
    CGFloat finalFontSize = 16;
    CGFloat actionDuration = .25;
    CGFloat elapsedTimeMod = 1 / actionDuration;
    SKAction *sizeAction = [SKAction customActionWithDuration:actionDuration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        
        _decisionLabel.fontSize = 1+(elapsedTimeMod * elapsedTime * (finalFontSize-1));
        
    }];
    
    CGPoint targetLocation = CGPointMake(self.size.width/2, _sizeMod-394);
    
    SKAction *moveXAction = [SKAction moveToX:150 duration:.25];
    SKAction *moveYAction = [SKAction moveTo:targetLocation duration:.25];
    
    SKAction *actionGroup = [SKAction group:@[sizeAction, moveXAction, moveYAction]];
    
    [_decisionLabel runAction:actionGroup completion:^{
//        [self spawnTryAgain];
    }];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKSpriteNode *touchedNode = (SKSpriteNode*)[self nodeAtPoint:touchLocation];
    NSString *nodeName = touchedNode.name;
    
    NSArray *optionsArray = @[@"safeSprite", @"dangerSprite", @"playSprite"];
    
    if ([optionsArray containsObject:nodeName]) {
        [self spawnDecisionAtNode:touchedNode];
    }
}

@end
