//
//  FoodTableViewCell.h
//  Explosion
//
//  Created by NickPiatt on 5/10/14.
//  Copyright (c) 2014 iPiatt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Opinions.h"

@interface FoodTableViewCell : UITableViewCell <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, strong) Opinions *opinion;

- (IBAction)changeLike:(UIButton *)sender;

@end
