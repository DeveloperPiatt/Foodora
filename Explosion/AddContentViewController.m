//
//  AddContentViewController.m
//  Explosion
//
//  Created by NickPiatt on 5/8/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import "AddContentViewController.h"
#import "Users.h"
#import "AppDelegate.h"

@interface AddContentViewController ()
{
    NSMutableArray *_masterFriendsList;
    NSString *_friendFilter;
    
    NSString *_getUser;
    
    NSMutableArray *_masterFoodList;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerFood;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerGetUser;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerThisUser;

@end

@implementation AddContentViewController

@synthesize isAddFriend, titleLabel, filterTextField, myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _friendFilter = @"";
    _getUser = @"";
    [filterTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (isAddFriend) {
        NSLog(@"TRUE!");
        [titleLabel setText:@"Add Friends"];
        [filterTextField setPlaceholder:@"Add friends ..."];
    } else {
        NSLog(@"FALSE");
        [titleLabel setText:@"Add Food"];
        [filterTextField setPlaceholder:@"Add food ..."];
    }
    
    NSError *error = nil;
    
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }

}

-(void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupFriends
{
    
    [myTableView reloadData];
}

#pragma mark - Table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    Users *fetchedUser = [[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
//    
//    NSLog(@"testing %d", [fetchedUser.friends count]);
//    return [fetchedUser.friends count];

    
    return [[self.fetchedResultsController fetchedObjects] count];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Users *users = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.textLabel.text = users.name;
    //    cell.detailTextLabel.text = prescription.instructions;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (isAddFriend) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Add Friend"
                                                          message:[NSString stringWithFormat:@"Add %@ as a friend?", cell.textLabel.text]
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
        [message show];
        
        _getUser = cell.textLabel.text;
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // cancel selected
        _getUser = @"";
    } else {

        self.fetchedResultsControllerGetUser = nil;
        
        NSError *error = nil;
        
        if (![[self fetchedResultsControllerGetUser]performFetch:&error]) {
            NSLog(@"Error! %@", error);
            abort();
        }
        if (![[self fetchedResultsControllerThisUser]performFetch:&error]) {
            NSLog(@"Error! %@", error);
            abort();
        }
        
        NSLog(@"friend -> %d", [[self.fetchedResultsControllerGetUser fetchedObjects]count]);
        Users *userToAdd = [[self.fetchedResultsControllerGetUser fetchedObjects] objectAtIndex:0];
        NSLog(@"me -> %d", [[self.fetchedResultsControllerThisUser fetchedObjects]count]);
        Users *thisUser = [[self.fetchedResultsControllerThisUser fetchedObjects] objectAtIndex:0];
        
        NSMutableSet *newFriendSet = [NSMutableSet setWithSet:thisUser.friends];
        [newFriendSet addObject:userToAdd];
        
        thisUser.friends = newFriendSet;
        
        if([self.managedObjectContext hasChanges]) {
            if(![self.managedObjectContext save:&error]) {
                NSLog(@"Save Failed: %@", [error localizedDescription]);
            } else {
                NSLog(@"Save Succeeded");
            }
        }
        
    }
}

#pragma mark - Data Stuff

-(NSManagedObjectContext*)managedObjectContext {
    return [(AppDelegate*)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

#pragma mark - Fetched Results Controller Section
-(NSFetchedResultsController*) fetchedResultsControllerFood {
    if (_fetchedResultsControllerFood != nil) {
        return _fetchedResultsControllerFood;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsControllerFood = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsControllerFood.delegate = self;
    
    return _fetchedResultsControllerFood;
}

-(NSFetchedResultsController*) fetchedResultsController {
    
//    NSLog(@"testing");
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSLog(@"name LIKE[cd] '*%@*'", _friendFilter);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[cd] %@",
                              [NSString stringWithFormat:@"*%@*", _friendFilter]];
    [fetchRequest setPredicate:predicate];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

-(NSFetchedResultsController*) fetchedResultsControllerGetUser {
    
    //    NSLog(@"testing");
    if (_fetchedResultsControllerGetUser != nil) {
        return _fetchedResultsControllerGetUser;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", _getUser];
    [fetchRequest setPredicate:predicate];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsControllerGetUser = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsControllerGetUser.delegate = self;
    
    return _fetchedResultsControllerGetUser;
}

-(NSFetchedResultsController*) fetchedResultsControllerThisUser {
    
    //    NSLog(@"testing");
    if (_fetchedResultsControllerThisUser != nil) {
        return _fetchedResultsControllerThisUser;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = 'kFrog'"];
    [fetchRequest setPredicate:predicate];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsControllerThisUser = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsControllerThisUser.delegate = self;
    
    return _fetchedResultsControllerThisUser;
}

#pragma mark - Fetched Results Controller Delegates

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [myTableView beginUpdates];
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [myTableView endUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = myTableView; // temp placeholder
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate: {
            Users *changeUser = [self.fetchedResultsController objectAtIndexPath:indexPath];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = changeUser.name;
        }
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    UITableView *tableView = myTableView; // temp placeholder
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == filterTextField) {
        [textField resignFirstResponder];
        
        
        
        return NO;
    }
    return YES;
}

-(void)textFieldDidChange:(UITextField*)textField
{
    
    _friendFilter = textField.text;
    NSLog(@"%@", _friendFilter);
    
    
    self.fetchedResultsController = nil;
    
    
    NSError *error = nil;
    
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    
    [myTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
