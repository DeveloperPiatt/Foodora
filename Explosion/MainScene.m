//
//  mainScene.m
//  Explosion
//
//  Created by NickPiatt on 5/4/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import "mainScene.h"
#import "Users.h"
#import "Restaurants.h"
#import "Opinions.h"

@interface MainScene () {
    AppDelegate *aDelegate;
    Users *_user;
    NSNumber *_likeValue;
    
    UITextField *login;
    
    NSSet *testSet;
    
    NSMutableData *webData;
    NSURLConnection *connection;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerOpinions;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerGetUser;

@end

@implementation MainScene
{
    SKSpriteNode *_bgSprite;
    
    SKSpriteNode *_playSprite;
    SKSpriteNode *_safeSprite;
    SKSpriteNode *_dangerSprite;
    
    SKLabelNode *_decisionLabel;
    
    SKLabelNode *_loginLabel;
    
    SKSpriteNode *_resetSprite;
    
    int _sizeMod;
}

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:60.0f/255.0f green:166.0f/255.0f blue:238.0f/255.0f alpha:1.0];
        
        _sizeMod = self.size.height-24;
        
        aDelegate = DELEGATE;
//        aDelegate.userLogin = @"Nick Piatt";
//        
//       
//        
//        NSError *error;
//        if (![[self fetchedResultsControllerGetUser]performFetch:&error]) {
//            NSLog(@"Error! %@", error);
//            abort();
//        }
//        
//        
//        if ([self.fetchedResultsControllerGetUser fetchedObjects] > 0) {
//            NSLog(@"captured logged in user");
//            _user = [[self.fetchedResultsControllerGetUser fetchedObjects]objectAtIndex:0];
//        }
//
//        
//        [self setupUI];
        
        [self setupLogin];
        
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    
    
    login = [[UITextField alloc] initWithFrame:CGRectMake(self.size.width/2 - 100, 360, 200, 40)];
    login.borderStyle = UITextBorderStyleRoundedRect;
    login.textColor = [UIColor blackColor];
    login.font = [UIFont systemFontOfSize:17.0];
    login.placeholder = @"Enter your name here";
    login.backgroundColor = [UIColor whiteColor];
    login.autocorrectionType = UITextAutocorrectionTypeYes;
    login.keyboardType = UIKeyboardTypeDefault;
    login.clearButtonMode = UITextFieldViewModeWhileEditing;
    login.delegate = self;
    [self.view addSubview:login];
}

-(void)setupLogin
{
    
    _bgSprite = [SKSpriteNode spriteNodeWithImageNamed:@"foodora_quicksketch.jpg"];
    _bgSprite.size = CGSizeMake(320, 312);
    _bgSprite.anchorPoint = CGPointZero;
    _bgSprite.position = CGPointMake(0, _sizeMod-_bgSprite.size.height);
    _bgSprite.name = @"bgSprite";
    
    [self addChild:_bgSprite];
    
    _loginLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _loginLabel.text = [NSString stringWithFormat:@"Type your Username!"];
    _loginLabel.fontSize = 16;
    _loginLabel.position = CGPointMake(self.size.width/2, _sizeMod - 340);
    
    [self addChild:_loginLabel];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint OC = self.view.center;
    self.view.center = CGPointMake(OC.x, OC.y-150);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGPoint OC = self.view.center;
    self.view.center = CGPointMake(OC.x, OC.y+150);
    
    //Initilizes NSURL object and and creates request
    NSURL *url = [NSURL URLWithString:@"http://fishslice2000.appspot.com/users.jsp"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //Loads url request and sends messages to delegate as the load progresses
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(connection)
    {
        NSLog(@"connection true");
        webData = [[NSMutableData alloc]init];
    }
    
    
    return YES;
}

//Sent when the connection has received sufficient data to construct the URL response
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //Resets webData on valid response
    [webData setLength:0];
}


//Sets the recieved data to webData for use later. We are currently expecting it to receive JSON
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
    NSLog(@"SetData");
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"FailWithError");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
        NSLog(@"ConnectionFinishedLoading");
        NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
        for (NSDictionary *user in allDataDictionary)
        {
            
            if ([login.text isEqualToString:[user objectForKey:@"username"]]) {
                NSLog(@"SUCCESS");
                aDelegate.userLogin = login.text;
                
                
                NSError *error;
                if (![[self fetchedResultsControllerGetUser]performFetch:&error]) {
                    NSLog(@"Error! %@", error);
                    abort();
                }
                
                
                if ([self.fetchedResultsControllerGetUser fetchedObjects] > 0) {
                    NSLog(@"captured logged in user");
                    _user = [[self.fetchedResultsControllerGetUser fetchedObjects]objectAtIndex:0];
                }

                [login removeFromSuperview];
                [_loginLabel removeFromParent];
                [self setupUI];
            }
            
        }
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
    
//    _bgSprite = [SKSpriteNode spriteNodeWithImageNamed:@"foodora_quicksketch.jpg"];
//    _bgSprite.size = CGSizeMake(320, 312);
//    _bgSprite.anchorPoint = CGPointZero;
//    _bgSprite.position = CGPointMake(0, _sizeMod-_bgSprite.size.height);
//    _bgSprite.name = @"bgSprite";
//    
//    [self addChild:_bgSprite];

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

-(NSString*)getDecisionFor:(NSString*)decisionType
{
    
    NSMutableString *theDecision = [[NSMutableString alloc] initWithString:@"Going to "];
    
    
    
    NSMutableArray *validRestaurants = [NSMutableArray new];
    NSMutableArray *bannedRestaurants = [NSMutableArray new];
    
    NSSet *friendArray = _user.friends;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    NSMutableArray *test = [NSMutableArray arrayWithArray:[_user.friends sortedArrayUsingDescriptors:sortDescriptors]];
    
    
    NSMutableArray *peopleGoing = [NSMutableArray new];
    [peopleGoing addObject:_user];
    
    for (Users *user in test) {
        if ([user.isGoing boolValue]) {
            [peopleGoing addObject:user];
        }
    }
    
    testSet = [NSSet setWithArray:peopleGoing];
    
    NSError *error;
    
    self.fetchedResultsControllerOpinions = nil;
    
    if (![[self fetchedResultsControllerOpinions]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    NSArray *allOpinions = [self.fetchedResultsControllerOpinions fetchedObjects];
    
    if ([self.fetchedResultsControllerOpinions fetchedObjects] > 0) {
        
    
        if ([decisionType isEqualToString:@"playSprite"]) {
            
            
            
            for (Opinions *opinion in allOpinions) {
                NSLog(@"%@ - %@", opinion.user.name, opinion.restaurant.name);
                if ([opinion.like intValue] >= 0) {
                    if (![bannedRestaurants containsObject:opinion.restaurant.name]) {
                        [validRestaurants addObject:opinion.restaurant.name];
                    }
                } else {
                    [validRestaurants removeObject:opinion.restaurant.name];
                    [bannedRestaurants addObject:opinion.restaurant.name];
                }
            }
        }
        
        if ([decisionType isEqualToString:@"safeSprite"]) {
            for (Opinions *opinion in allOpinions) {
                NSLog(@"%@ - %@", opinion.user.name, opinion.restaurant.name);
                if ([opinion.like intValue] >= 1) {
                    if (![bannedRestaurants containsObject:opinion.restaurant.name]) {
                        [validRestaurants addObject:opinion.restaurant.name];
                    }
                } else {
                    [validRestaurants removeObject:opinion.restaurant.name];
                    [bannedRestaurants addObject:opinion.restaurant.name];
                }
            }
        }
        
        if ([decisionType isEqualToString:@"dangerSprite"]) {
            for (Opinions *opinion in allOpinions) {
                NSLog(@"%@ - %@", opinion.user.name, opinion.restaurant.name);
                if ([opinion.like intValue] >= -1) {
                    if (![bannedRestaurants containsObject:opinion.restaurant.name]) {
                        [validRestaurants addObject:opinion.restaurant.name];
                    }
                } else {
                    [validRestaurants removeObject:opinion.restaurant.name];
                    [bannedRestaurants addObject:opinion.restaurant.name];
                }
            }
        }
        
    }
    
    NSLog(@"Valid options - %@", validRestaurants);
    if (validRestaurants.count > 0) {
        int randomValue =arc4random() % validRestaurants.count;
        [theDecision appendString:[validRestaurants objectAtIndex:randomValue]];
    } else {
        [theDecision setString:@"Not enough matches"];
    }
   
    
    return [NSString stringWithFormat:@"%@", theDecision];
}

-(void)spawnDecisionAtNode:(SKSpriteNode*)node
{    
    BOOL addToView = FALSE;
    if (_decisionLabel == nil) {
        _decisionLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        addToView = TRUE;
    }
    
//    [self getDecisionFor:node.name];
    
    _decisionLabel.text = [NSString stringWithFormat:@"%@!", [self getDecisionFor:node.name]];
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

#pragma mark - Fetched Stuff
-(NSFetchedResultsController*) fetchedResultsControllerGetUser {
    NSLog(@"user = %@", aDelegate.userLogin);
    if (_fetchedResultsControllerGetUser != nil) {
        return _fetchedResultsControllerGetUser;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", aDelegate.userLogin];
    [fetchRequest setPredicate:predicate];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsControllerGetUser = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsControllerGetUser.delegate = self;
    
    return _fetchedResultsControllerGetUser;
}

-(NSFetchedResultsController*) fetchedResultsControllerOpinions {
    if (_fetchedResultsControllerOpinions != nil) {
        return _fetchedResultsControllerOpinions;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Opinions" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"like" ascending:YES];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user IN %@", testSet];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsControllerOpinions = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsControllerOpinions.delegate = self;
    
    return _fetchedResultsControllerOpinions;
}

-(NSManagedObjectContext*)managedObjectContext {
    return [(AppDelegate*)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

@end
