//
//  FoodViewController.m
//  Explosion
//
//  Created by NickPiatt on 5/8/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import "FoodViewController.h"
#import "AddContentViewController.h"
#import "FoodTableViewCell.h"
#import "Restaurants.h"
#import "Opinions.h"
#import "Users.h"

@interface FoodViewController () {
    AppDelegate *aDelegate;
    Users *_user;
    
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerOpinions;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerGetUser;

@end

@implementation FoodViewController

@synthesize myTable;

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
    
    
    NSError *error;
    if (![[self fetchedResultsControllerGetUser]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    
    
    if ([self.fetchedResultsControllerGetUser fetchedObjects] > 0) {
        NSLog(@"captured logged in user");
        _user = [[self.fetchedResultsControllerGetUser fetchedObjects]objectAtIndex:0];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    NSError *error = nil;
    self.fetchedResultsControllerOpinions = nil;
    
    if (![[self fetchedResultsControllerOpinions]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    
    [myTable reloadData];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddContentViewController *addContentViewController = (AddContentViewController*)segue.destinationViewController;
    
    addContentViewController.isAddFriend = false;
    
    
}

#pragma mark - Table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.fetchedResultsControllerOpinions fetchedObjects]count] > 0) {
        return [[self.fetchedResultsControllerOpinions fetchedObjects]count];
    }
    
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FoodTableViewCell *cell = (FoodTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Opinions *opinion = [self.fetchedResultsControllerOpinions objectAtIndexPath:indexPath];
    
    
    NSString *newOpinion = @"?";
    if ([opinion.like intValue] == 1) {
        newOpinion = @"Like";
    }
    if ([opinion.like intValue]  == 0) {
        newOpinion = @"Meh";
    }
    if ([opinion.like intValue]  == -1) {
        newOpinion = @"Dislike";
    }
    
    
    cell.opinion = opinion;
    cell.nameLabel.text = opinion.restaurant.name;
    
    [cell.likeButton setTitle:newOpinion forState:UIControlStateNormal];
    
    return cell;
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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user = %@", _user];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsControllerOpinions = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsControllerOpinions.delegate = self;
    
    return _fetchedResultsControllerOpinions;
}

-(NSFetchedResultsController*) fetchedResultsControllerGetUser {
    
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

-(NSManagedObjectContext*)managedObjectContext {
    return [(AppDelegate*)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
