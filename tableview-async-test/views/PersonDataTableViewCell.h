//
//  PersonDataTableViewCell.h
//  tableview-async-test
//
//  Created by Sergey Buravtsov on 17.07.15.
//  Copyright (c) 2015 Sergey Buravtsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonDataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *personCountry;
@property (weak, nonatomic) IBOutlet UILabel *personID;

+ (NSString *)cellReuseIdentifier;

@end
