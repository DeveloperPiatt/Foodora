//
//  FriendsTableViewCell.m
//  Explosion
//
//  Created by NickPiatt on 5/9/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import "FriendsTableViewCell.h"
#import "AppDelegate.h"

@interface FriendsTableViewCell ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation FriendsTableViewCell

@synthesize goingSwitch, user;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        NSLog(@"ran me");
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(IBAction)switchAction:(id)sender
{
    NSNumber *boolValue = [NSNumber numberWithBool:goingSwitch.on];
    user.isGoing = boolValue;
    
    NSError *error = nil;
    if([self.managedObjectContext hasChanges]) {
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"Save Failed: %@", [error localizedDescription]);
        } else {
            NSLog(@"Save Succeeded");
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Data Stuff

-(NSManagedObjectContext*)managedObjectContext {
    return [(AppDelegate*)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

@end
