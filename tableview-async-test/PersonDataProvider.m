//
//  PersonDataProvider.m
//  tableview-async-test
//
//  Created by Sergey Buravtsov on 17.07.15.
//  Copyright (c) 2015 Sergey Buravtsov. All rights reserved.
//

#import "PersonDataProvider.h"
#import "PersonModel.h"

@implementation PersonDataProvider

+ (NSArray *)getPersonModelsArray:(NSUInteger)count {

    NSMutableArray * countriesArray = [[NSMutableArray alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier: @"ru_RU"];
    
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    
    for (NSString *countryCode in countryArray) {
        
        NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
        [countriesArray addObject:displayNameString];
    }
    
    [countriesArray sortUsingSelector:@selector(compare:)];
    
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        
        PersonModel *personModel = [[PersonModel alloc] init];
        personModel.personId = i;
        personModel.personName = [NSString stringWithFormat:@"Name-%tu", i];
        personModel.personCountry = [countriesArray objectAtIndex:arc4random() % countriesArray.count];
        
        [result addObject:personModel];
    }
    
    return result;
}

@end
