//
//  Users.h
//  Explosion
//
//  Created by NickPiatt on 5/9/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Opinions, Users;

@interface Users : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * isGoing;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *opinions;
@end

@interface Users (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(Users *)value;
- (void)removeFriendsObject:(Users *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (void)addOpinionsObject:(Opinions *)value;
- (void)removeOpinionsObject:(Opinions *)value;
- (void)addOpinions:(NSSet *)values;
- (void)removeOpinions:(NSSet *)values;

@end
