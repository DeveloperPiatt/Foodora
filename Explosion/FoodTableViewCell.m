//
//  FoodTableViewCell.m
//  Explosion
//
//  Created by NickPiatt on 5/10/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import "FoodTableViewCell.h"

@interface FoodTableViewCell ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation FoodTableViewCell

@synthesize opinion, nameLabel, likeButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeLike:(UIButton *)sender {
//    opinion.like
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nameLabel.text
                            
                                                      message:@"Rate this restaurant!"
                            
                                                     delegate:self
                            
                                            cancelButtonTitle:@"Nevermind"
                            
                                            otherButtonTitles:@"Like", @"Meh", @"Dislike", nil];
    
    [message show];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d", buttonIndex);
    
    NSString *newOpinion;
    
    if (buttonIndex == 1) {
        opinion.like = [NSNumber numberWithInt:1];
        newOpinion = @"Like";
    }
    if (buttonIndex == 2) {
        opinion.like = [NSNumber numberWithInt:0];
        newOpinion = @"Meh";
    }
    if (buttonIndex == 3) {
        opinion.like = [NSNumber numberWithInt:-1];
        newOpinion = @"Dislike";
    }
    
    if (buttonIndex != 0) {
        [likeButton setTitle:newOpinion forState:UIControlStateNormal];
    }
    
    NSError *error = nil;
    if([self.managedObjectContext hasChanges]) {
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"Save Failed: %@", [error localizedDescription]);
        } else {
            NSLog(@"Save Succeeded");
        }
    }
}

#pragma mark - Data Stuff

-(NSManagedObjectContext*)managedObjectContext {
    return [(AppDelegate*)[[UIApplication sharedApplication]delegate]managedObjectContext];
}
@end
