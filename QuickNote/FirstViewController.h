//
//  FirstViewController.h
//  QuickNote
//
//  Created by Patrick Matherly on 6/9/15.
//  Copyright (c) 2015 Patrick Matherly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction)refresh:(UIRefreshControl *)sender;

@end

