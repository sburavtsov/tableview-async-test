//
//  PersonModel.h
//  tableview-async-test
//
//  Created by Sergey Buravtsov on 17.07.15.
//  Copyright (c) 2015 Sergey Buravtsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property (nonatomic, assign) NSUInteger personId;
@property (nonatomic, strong) NSString * personName;
@property (nonatomic, strong) NSString * personCountry;

@end
