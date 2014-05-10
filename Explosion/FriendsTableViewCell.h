//
//  FriendsTableViewCell.h
//  Explosion
//
//  Created by NickPiatt on 5/9/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"

@interface FriendsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *goingSwitch;

@property (nonatomic, strong)Users *user;

-(IBAction)switchAction:(id)sender;

@end
