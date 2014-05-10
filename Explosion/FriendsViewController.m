//
//  FriendsViewController.m
//  Explosion
//
//  Created by NickPiatt on 5/8/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import "FriendsViewController.h"
#import "AddContentViewController.h"
#import "AppDelegate.h"
#import "FriendsTableViewCell.h"

@interface FriendsViewController ()
{
    AppDelegate *aDelegate;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation FriendsViewController

@synthesize myTableView;

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
    aDelegate = DELEGATE;
    // Do any additional setup after loading the view.
    NSError *error = nil;
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    
    
    
}

#pragma mark - Data Stuff

-(NSManagedObjectContext*)managedObjectContext {
    return [(AppDelegate*)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

-(void)setupDummyData
{
    
    NSLog(@"Generating USER data");
    
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:0];
    
    if ([sectionInfo numberOfObjects] == 0) {
        
        
        
        NSArray *userArray = @[
                               @"mSwag",
                               @"kFrog",
                               @"MaHAHAHAHAHA",
                               @"TestUser1"
                               ];
        
        
        for (NSString *userName in userArray) {
            Users *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:[self managedObjectContext]];
            
            newUser.name = userName;
            
            if ([userName isEqualToString:@"kFrog"]) {
                
                Users *SUPERMAN = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:[self managedObjectContext]];
                SUPERMAN.name = @"kFrogs Friend";
                
                NSMutableSet *testing = [NSMutableSet setWithSet:newUser.friends];
                [testing addObject:SUPERMAN];
                NSSet *finalSet = [NSSet setWithSet:testing];
                
                newUser.friends = finalSet;
                
                SUPERMAN = newUser;
                
            }
            
            
        }
        
        
        
        NSError *error = nil;
        if([self.managedObjectContext hasChanges]) {
            if(![self.managedObjectContext save:&error]) {
                NSLog(@"Save Failed: %@", [error localizedDescription]);
            } else {
                NSLog(@"Save Succeeded");
            }
        }
        
        [myTableView reloadData];
    }
    
    
    

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddContentViewController *addContentViewController = (AddContentViewController*)segue.destinationViewController;
    
    addContentViewController.isAddFriend = TRUE;
    
    
    
}

#pragma mark - Table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
//    Users *returnedUser = [[sectionInfo objects] objectAtIndex:0];
    
    if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
        Users *fetchedUser = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
        
        NSLog(@"testing %d", [fetchedUser.friends count]);
        return [fetchedUser.friends count];
    }
    
    return 0;
    
//    return [sectionInfo numberOfObjects];
//    return [returnedUser.friends count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FriendsTableViewCell *cell = (FriendsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Users *users = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    NSArray *test = [users.friends sortedArrayUsingDescriptors:sortDescriptors];
    
    Users *friendAtIndex = [test objectAtIndex:indexPath.row];
    cell.user = friendAtIndex;
    cell.nameLabel.text = friendAtIndex.name;
    cell.goingSwitch.on = [friendAtIndex.isGoing boolValue];
//    cell.textLabel.text = friendAtIndex.name;
//    cell.detailTextLabel.text = prescription.instructions;
    
    return cell;
}

#pragma mark - Fetched Results Controller Section

-(NSFetchedResultsController*) fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
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
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.fetchedResultsController = nil;
    NSError *error;
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    [myTableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
