//
//  AddContentViewController.h
//  Explosion
//
//  Created by NickPiatt on 5/8/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContentViewController : UIViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NSURLConnectionDataDelegate>

@property BOOL isAddFriend;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *filterTextField;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


-(IBAction)cancel:(id)sender;
@end
