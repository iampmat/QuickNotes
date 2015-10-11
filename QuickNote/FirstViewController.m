//
//  FirstViewController.m
//  QuickNote
//
//  Created by Patrick Matherly on 6/9/15.
//  Copyright (c) 2015 Patrick Matherly. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import <UIKit/UIKit.h>

@interface FirstViewController ()
@property (strong, nonatomic) NSMutableArray *valuesToSave;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view, typically from a nib.
    
    _valuesToSave = [[NSMutableArray alloc]initWithArray:[self loadData]];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppSettingsChanged:) name:@"NotesChanged" object:nil];
    
    // Show instructions on first open
    if (![@"1" isEqualToString:[[NSUserDefaults standardUserDefaults]
                                objectForKey:@"firstTimeOpened"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"firstTimeOpened"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
    }
    
    [super viewDidLoad];
}


// Add listener to NSUserDefaults
- (void) onAppSettingsChanged:(NSNotification *)notification {
    _valuesToSave = [[NSMutableArray alloc]initWithArray:[self loadData]];
    [self.tableView reloadData];
}

- (NSArray *)loadData {
     NSUserDefaults *mySharedDefaults = [NSUserDefaults standardUserDefaults];
    [mySharedDefaults synchronize];
    NSLog(@"%@", [mySharedDefaults arrayForKey:@"notes"]);
    return [mySharedDefaults arrayForKey:@"notes"];
}

- (void)save {
    NSUserDefaults *mySharedDefaults = [NSUserDefaults standardUserDefaults];
    [mySharedDefaults setObject:_valuesToSave forKey:@"notes"];
    [mySharedDefaults synchronize];
}

- (void)reloadTable {
    _valuesToSave = [[NSMutableArray alloc]initWithArray:[self loadData]];
    [self.tableView reloadData];
}


// To delete rows
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_valuesToSave removeObjectAtIndex:indexPath.row];
        [self save];
        _valuesToSave = [[NSMutableArray alloc]initWithArray:[self loadData]];
        [self.tableView reloadData];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_valuesToSave count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier =@"Cell";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text=[_valuesToSave objectAtIndex:indexPath.row];
    
    return cell;
}

- (IBAction)refresh:(UIRefreshControl *)sender {
    [self reloadTable];
    [sender endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
