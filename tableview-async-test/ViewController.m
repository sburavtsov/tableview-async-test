//
//  ViewController.m
//  tableview-async-test
//
//  Created by Sergey Buravtsov on 17.07.15.
//  Copyright (c) 2015 Sergey Buravtsov. All rights reserved.
//

#import "PersonDataProvider.h"
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *personModels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.personModels = [PersonDataProvider getPersonModelsArray:100];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)asyncUpdatesDidChange:(UISwitch *)sender {
    
}

@end
