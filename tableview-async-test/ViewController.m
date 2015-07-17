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
     
        [indexesArray addObject: [NSNumber numberWithInt:arc4random() % personsSampleCount]];
    }
    
    self.modelIndexesArray = indexesArray;
    
    self.doAsyncUpdates = NO;
    
    [self.asyncUpdatesSwitch setOn:self.doAsyncUpdates animated:NO];
    
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)asyncUpdatesDidChange:(UISwitch *)sender {

    self.doAsyncUpdates = sender.isOn;

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
        while (self.doAsyncUpdates) {

            NSMutableArray *indexesToUpdate = [NSMutableArray arrayWithCapacity:personsRandomChangePerBlock];
            
            while (personsRandomChangePerBlock > indexesToUpdate.count) {

                NSUInteger index = arc4random() % self.modelIndexesArray.count;

                NSUInteger modelIndex = [[self.modelIndexesArray objectAtIndex:index] unsignedIntegerValue];
                
                NSIndexPath *indexPathToUpdate = [NSIndexPath indexPathForRow:index inSection:0];
                
                if (! [indexesToUpdate containsObject:indexPathToUpdate]) {
                    
                    [indexesToUpdate addObject:indexPathToUpdate];

                    PersonModel *model = [self.personModelsArray objectAtIndex:modelIndex];
                    
                    model.personName = [NSString stringWithFormat:@"Name: %tu", model.personId + arc4random() % 100];
                }
            }
            
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

