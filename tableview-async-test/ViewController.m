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

@property (atomic, strong) NSArray *personModelsArray;
@property (atomic, strong) NSArray *modelIndexesArray;
@property (atomic, assign) BOOL doAsyncUpdates;
@property (atomic, assign) NSUInteger indexToChange;

@end

const NSUInteger personsSampleCount = 20;
const NSUInteger personsRandomChangePerBlock = 4;

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.personModelsArray = [PersonDataProvider getPersonModelsArray:personsSampleCount];
    
    NSMutableArray *indexesArray = [NSMutableArray arrayWithCapacity:personsSampleCount];
    
    for (NSUInteger i = 0; i < personsSampleCount; i++) {
     
        NSUInteger index = arc4random() % personsSampleCount;
        [indexesArray addObject: [NSNumber numberWithUnsignedInteger:index]];
        [indexesArray addObject: [NSNumber numberWithUnsignedInteger:index]];
    }
    
    self.modelIndexesArray = indexesArray;
    
    self.doAsyncUpdates = NO;
    
    self.indexToUpdateSlider.minimumValue = 0;
    self.indexToUpdateSlider.maximumValue = personsSampleCount - 1;
    self.indexToUpdateSlider.continuous = YES;
    self.indexToUpdateSlider.value = 0.0f;
    
    [self.asyncUpdatesSwitch setOn:self.doAsyncUpdates animated:NO];
    
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)indexToUpdateDidChange:(UISlider *)sender {
    
    NSUInteger index = (NSUInteger)(sender.value + 0.5);
    [sender setValue:index animated:NO];
    self.indexToChange = index;
    self.indexToUpdate.text = [NSString stringWithFormat:@"%tu", index];
}

- (IBAction)asyncUpdatesDidChange:(UISwitch *)sender {

    self.doAsyncUpdates = sender.isOn;

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
        while (self.doAsyncUpdates) {

            NSMutableArray *indexesToUpdate = [NSMutableArray arrayWithCapacity:personsRandomChangePerBlock];
            
            NSUInteger modelIndex = self.indexToChange;
        
            NSIndexSet *indexSet = [self.modelIndexesArray indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                
                return (modelIndex == [(NSNumber *)obj unsignedIntegerValue]);
            }];
        
            [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {

                NSIndexPath *indexPathToUpdate = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexesToUpdate addObject:indexPathToUpdate];
            }];
            
            PersonModel *model = [self.personModelsArray objectAtIndex:modelIndex];
            
            model.personName = [NSString stringWithFormat:@"Name: %tu", model.personId + arc4random() % 100];

            dispatch_sync(dispatch_get_main_queue(), ^{

                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:indexesToUpdate withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            });
        } // while doAsyncUpdates
    });
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
    cell.personID.text = [NSString stringWithFormat:@"%tu", model.personId];

    return cell;
}


@end

