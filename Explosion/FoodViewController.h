//
//  FoodViewController.h
//  Explosion
//
//  Created by NickPiatt on 5/8/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddFoodButton;
@property (weak, nonatomic) IBOutlet UITableView *myTable;

@end
