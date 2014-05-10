//
//  FriendsViewController.h
//  Explosion
//
//  Created by NickPiatt on 5/8/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"

@interface FriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addFriendButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end
