//
//  ViewController.m
//  tableview-async-test
//
//  Created by Sergey Buravtsov on 17.07.15.
//  Copyright (c) 2015 Sergey Buravtsov. All rights reserved.
//

#import "PersonModel.h"
#import "PersonDataProvider.h"
#import "PersonDataTableViewCell.h"
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *personModelsArray;
@property (nonatomic, strong) NSArray *modelIndexesArray;

@end

const NSUInteger personsSampleCount = 100;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.personModelsArray = [PersonDataProvider getPersonModelsArray:personsSampleCount];
    
    NSMutableArray *indexesArray = [NSMutableArray arrayWithCapacity:personsSampleCount];
    
    for (NSUInteger i = 0; i < personsSampleCount; i++) {
     
        [indexesArray addObject: [NSNumber numberWithInt:arc4random() % personsSampleCount]];
    }
    
    self.modelIndexesArray = indexesArray;
    
    [self.asyncUpdatesSwitch setOn:NO animated:NO];
    
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)asyncUpdatesDidChange:(UISwitch *)sender {
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelIndexesArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PersonDataTableViewCell cellReuseIdentifier]];
    
    NSNumber * modelIndex = [self.modelIndexesArray objectAtIndex:indexPath.row];
    
    PersonModel *model = [self.personModelsArray objectAtIndex:modelIndex.unsignedIntegerValue];
    
    cell.personName.text = model.personName;
    cell.personCountry.text = model.personCountry;
    cell.personID.text = [NSString stringWithFormat:@"%ld", model.personId];

    return cell;
}


@end
