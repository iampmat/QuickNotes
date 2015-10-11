//
//  SecondViewController.m
//  QuickNote
//
//  Created by Patrick Matherly on 6/9/15.
//  Copyright (c) 2015 Patrick Matherly. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UITextView *newnote;
@property (strong, nonatomic) NSMutableArray *valueToSave;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic) int priValue;
@property (nonatomic) BOOL sliderMoved;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide Keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    // Load init Data
    [self loadData];
    _valueToSave = [[NSMutableArray alloc]initWithArray:[self loadData]];
    
    // Set slider
    [self initSlider];

}

- (IBAction)save:(id)sender {
    _valueToSave = [[NSMutableArray alloc]initWithArray:[self loadData]];
    
    if (([_valueToSave count] == 0)) {
        [_valueToSave insertObject:_newnote.text atIndex:[_valueToSave count]];
    }
    else { [_valueToSave insertObject:_newnote.text atIndex:_priValue]; }
    
    NSUserDefaults *mySharedDefaults = [NSUserDefaults standardUserDefaults];
    [mySharedDefaults setObject:_valueToSave forKey:@"notes"];
    [mySharedDefaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotesChanged" object:self userInfo:nil];
    
    // Reset textview
     _newnote.text = @"";
    
    // Reset Slider
    [self initSlider];
}

// Add listener to NSUserDefaults
- (void) onAppSettingsChanged:(NSNotification *)notification {
    _valueToSave = [[NSMutableArray alloc]initWithArray:[self loadData]];
}

- (NSArray *)loadData {
    NSUserDefaults *mySharedDefaults = [NSUserDefaults standardUserDefaults];
    [mySharedDefaults synchronize];
    return [mySharedDefaults arrayForKey:@"notes"];
}

- (IBAction)adjustSlider:(UISlider *)sender {
    _sliderMoved = true;
    _priValue = (int) ceilf([_valueToSave count] - (sender.value));
}

- (void)initSlider {
    _sliderMoved = false;
    // Load array to count length
    NSUserDefaults *mySharedDefaults = [NSUserDefaults standardUserDefaults];
    [mySharedDefaults synchronize];
    // initialize slider
    _slider.value = 0;
    _slider.maximumValue = [_valueToSave count];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
