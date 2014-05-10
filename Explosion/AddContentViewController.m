//
//  AddContentViewController.m
//  Explosion
//
//  Created by NickPiatt on 5/8/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import "AddContentViewController.h"
#import "Users.h"
#import "Restaurants.h"
#import "AppDelegate.h"

@interface AddContentViewController ()
{
    NSMutableArray *_masterFriendsList;
    NSString *_friendFilter;
    
    
    
    
    NSString *_getUser;
    NSString *_getRestaurant;
    
    NSMutableArray *_masterFoodList;
    
    NSMutableData *webData;
    NSURLConnection *connection;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerFood;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerGetRestaurant;

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
    _getRestaurant = @"";
    [filterTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    NSError *error;
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    
    if (isAddFriend) {
        NSLog(@"TRUE!");
        [titleLabel setText:@"Add Friends"];
        [filterTextField setPlaceholder:@"Add friends ..."];
        [self setupFriendConnection];
    } else {
        NSLog(@"FALSE");
        [titleLabel setText:@"Add Food"];
        [filterTextField setPlaceholder:@"Add food ..."];
        [self setupFoodConnection];
    }
    
    
}

-(void)setupFriendConnection
{
    //Idicates activity while table view loads data
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //Initilizes NSURL object and and creates request
    NSURL *url = [NSURL URLWithString:@"http://fishslice2000.appspot.com/users.jsp"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //Loads url request and sends messages to delegate as the load progresses
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(connection)
    {
        NSLog(@"connection true");
        webData = [[NSMutableData alloc]init];
    }
}

-(void)setupFoodConnection
{
    //Idicates activity while table view loads data
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //Initilizes NSURL object and and creates request
    NSURL *url = [NSURL URLWithString:@"http://fishslice2000.appspot.com/restaurants.jsp"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //Loads url request and sends messages to delegate as the load progresses
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(connection)
    {
        NSLog(@"connection true");
        webData = [[NSMutableData alloc]init];
    }
}

#pragma mark - Connection

//Sent when the connection has received sufficient data to construct the URL response
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //Resets webData on valid response
    [webData setLength:0];
}


//Sets the recieved data to webData for use later. We are currently expecting it to receive JSON
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
    NSLog(@"SetData");
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"FailWithError");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (isAddFriend) {
        NSLog(@"ConnectionFinishedLoading");
        NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
        for (NSDictionary *user in allDataDictionary)
        {
            
            if (![[user objectForKey:@"username"] isKindOfClass:[NSNull class]]) {
                NSLog(@"found a user -> %@", [user objectForKey:@"username"]);
                [self createUser:user];
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
        
        self.fetchedResultsController = nil;
        
        if (![[self fetchedResultsController]performFetch:&error]) {
            NSLog(@"Error! %@", error);
            abort();
        }
        
        [myTableView reloadData];
    } else {
        NSLog(@"ConnectionFinishedLoading");
        NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
        for (NSDictionary *restaurant in allDataDictionary)
        {
            
            if (![[restaurant objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
                NSLog(@"found a restaurant -> %@", [restaurant objectForKey:@"name"]);
                [self createRestaurant:restaurant];
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
        
        self.fetchedResultsControllerFood = nil;
        
        if (![[self fetchedResultsControllerFood]performFetch:&error]) {
            NSLog(@"Error! %@", error);
            abort();
        }
        
        [myTableView reloadData];
    }
    

}

-(void)createUser:(NSDictionary*)newUser
{
    
    _getUser = [newUser objectForKey:@"username"];
    
    self.fetchedResultsControllerGetUser = nil;
    
    NSError *error = nil;
    if (![[self fetchedResultsControllerGetUser]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }
    
    if ([[self.fetchedResultsControllerGetUser fetchedObjects] count] == 0) {
        Users *user = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:[self managedObjectContext]];
        
        user.name = [newUser objectForKey:@"username"];
        user.database_id = [NSString stringWithFormat:@"%@", [newUser objectForKey:@"id"]];
    }
    
    
}

-(void)createRestaurant:(NSDictionary*)newRestaurant
{
    _getRestaurant = [newRestaurant objectForKey:@"name"];
    
    self.fetchedResultsControllerGetRestaurant = nil;
    NSError *error = nil;
    if (![[self fetchedResultsControllerGetRestaurant]performFetch:&error]) {
        NSLog(@"Error! %@", error);
        abort();
    }

    if ([[self.fetchedResultsControllerGetRestaurant fetchedObjects] count] == 0) {
        Restaurants *restaurant = [NSEntityDescription insertNewObjectForEntityForName:@"Restaurants" inManagedObjectContext:[self managedObjectContext]];
        
        restaurant.name = [newRestaurant objectForKey:@"name"];
        restaurant.database_id = [NSString stringWithFormat:@"%@", [newRestaurant objectForKey:@"id"]];
    }
    
}



-(void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (isAddFriend) {
        return [[self.fetchedResultsController fetchedObjects] count];
    } else {
        return [[self.fetchedResultsControllerFood fetchedObjects]count];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (isAddFriend) {
        Users *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = user.name;
    } else {
        Restaurants *restaurant = [self.fetchedResultsControllerFood objectAtIndexPath:indexPath];
        cell.textLabel.text = restaurant.name;
    }
    
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
    
    if (isAddFriend) {
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
            
            //Initilizes NSURL object and and creates request
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://fishslice2000.appspot.com/new_friend.jsp?user_id=%@&friend_id=%@", thisUser.database_id, userToAdd.database_id]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            //Loads url request and sends messages to delegate as the load progresses
            connection = [NSURLConnection connectionWithRequest:request delegate:self];
            
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
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Restaurants" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsControllerFood = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsControllerFood.delegate = self;
    
    return _fetchedResultsControllerFood;
}
-(NSFetchedResultsController*) fetchedResultsControllerGetRestaurant {
    if (_fetchedResultsControllerGetRestaurant != nil) {
        return _fetchedResultsControllerGetRestaurant;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Restaurants" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSLog(@"Predicate -> name = %@", _getRestaurant);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", _getRestaurant];
    [fetchRequest setPredicate:predicate];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsControllerGetRestaurant = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsControllerGetRestaurant.delegate = self;
    
    return _fetchedResultsControllerGetRestaurant;
    
}
-(NSFetchedResultsController*) fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSLog(@"name LIKE[cd] '*%@*'", _friendFilter);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name LIKE[cd] %@) AND (name <> 'Nick Piatt')",
                              [NSString stringWithFormat:@"*%@*", _friendFilter]];
    [fetchRequest setPredicate:predicate];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", _getUser];
    [fetchRequest setPredicate:predicate];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsControllerGetUser = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsControllerGetUser.delegate = self;
    
    return _fetchedResultsControllerGetUser;
}

-(NSFetchedResultsController*) fetchedResultsControllerThisUser {
    
    if (_fetchedResultsControllerThisUser != nil) {
        return _fetchedResultsControllerThisUser;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = 'Nick Piatt'"];
    [fetchRequest setPredicate:predicate];
    
    NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    fetchRequest.sortDescriptors = sortDescriptors;
    
    _fetchedResultsControllerThisUser = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsControllerThisUser.delegate = self;
    
    return _fetchedResultsControllerThisUser;
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
    if (isAddFriend) {
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
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
