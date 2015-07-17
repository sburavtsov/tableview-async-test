//
//  PersonDataProvider.h
//  tableview-async-test
//
//  Created by Sergey Buravtsov on 17.07.15.
//  Copyright (c) 2015 Sergey Buravtsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonDataProvider : NSObject

+ (NSArray *)getPersonModelsArray:(NSUInteger)count;

@end
