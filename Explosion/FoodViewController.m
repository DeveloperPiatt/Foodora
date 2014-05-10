//
//  FoodViewController.m
//  Explosion
//
//  Created by NickPiatt on 5/8/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import "FoodViewController.h"
#import "AddContentViewController.h"

@interface FoodViewController () {
    AppDelegate *aDelegate;
}

@end

@implementation FoodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    aDelegate = DELEGATE;
    NSLog(@"%@ is logged in!", aDelegate.userLogin);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddContentViewController *addContentViewController = (AddContentViewController*)segue.destinationViewController;
    
    addContentViewController.isAddFriend = false;
    
    
}

#pragma mark - Table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
