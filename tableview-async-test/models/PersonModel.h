//
//  PersonModel.h
//  tableview-async-test
//
//  Created by Sergey Buravtsov on 17.07.15.
//  Copyright (c) 2015 Sergey Buravtsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property (atomic, assign) NSUInteger personId;
@property (atomic, strong) NSString * personName;
@property (atomic, strong) NSString * personCountry;

@end
