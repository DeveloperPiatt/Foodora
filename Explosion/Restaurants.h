//
//  Restaurants.h
//  Explosion
//
//  Created by NickPiatt on 5/9/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Opinions;

@interface Restaurants : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *opinions;
@end

@interface Restaurants (CoreDataGeneratedAccessors)

- (void)addOpinionsObject:(Opinions *)value;
- (void)removeOpinionsObject:(Opinions *)value;
- (void)addOpinions:(NSSet *)values;
- (void)removeOpinions:(NSSet *)values;

@end
