//
//  Opinions.h
//  Explosion
//
//  Created by NickPiatt on 5/9/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Restaurants, Users;

@interface Opinions : NSManagedObject

@property (nonatomic, retain) NSNumber * like;
@property (nonatomic, retain) Restaurants *restaurant;
@property (nonatomic, retain) Users *user;

@end
