//
//  MainViewController.m
//  Epiclite
//
//  Created by DURGA PANDEY on 2/8/14.
//  Copyright (c) 2014 12 Labs. All rights reserved.
//

#import "MainViewController.h"
#import "QuartzCore/QuartzCore.h"


@interface MainViewController ()

@property (nonatomic, retain) IBOutlet UIButton *mainButton;
@property (nonatomic, retain) IBOutlet NSNumber *rightPosition;
@property (nonatomic, retain)  UITextField *eventTitle;
@property (nonatomic, retain) UIDatePicker *timePicker;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mainButton addTarget:self action:@selector(finishedDragging:withEvent:)
                    forControlEvents:UIControlEventTouchDragExit];
    self.rightPosition = [NSNumber numberWithBool:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"ContactAccessGrantedNotification"
                                               object:nil];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapRecognizer];

}

- (void)tapAction:(UITapGestureRecognizer*)sender{
    
}



- (void)finishedDragging:(UIButton *)button withEvent:(UIEvent *)event {
    
    UIControl *control = button;
    
    if (!self.rightPosition.boolValue) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        control.center = CGPointMake(270, 533);
        [UIView commitAnimations];
    }
    else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        control.center = CGPointMake(40, 533);
        [UIView commitAnimations];
    }
    
    if (!self.rightPosition.boolValue) {
        self.rightPosition = [NSNumber numberWithBool:YES];
    }
    else {
        self.rightPosition = [NSNumber numberWithBool:NO];
    }

    [self performSelector:@selector(flipPhotos) withObject:nil afterDelay:0.4];

}

-(void)pickerDone {
    [self.timePicker setHidden:YES];
}


-(void)showTimePicker {
    [self.eventTitle resignFirstResponder];
    if (!self.timePicker) {
        self.timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 260, 300, 200)];
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton setTitle:@"Save" forState:UIControlStateNormal];
        [[doneButton titleLabel] setFont:[UIFont fontWithName:@"GillSans" size:17]];
        [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(pickerDone) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setFrame:CGRectMake(260, 2, 50, 30)];
        doneButton.layer.borderColor = [UIColor grayColor].CGColor;
        doneButton.layer.borderWidth = 0.5;
        doneButton.layer.cornerRadius = 6;
        [self.view addSubview:self.timePicker];
        [self.view addSubview:doneButton];
    }
    [self.timePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.timePicker setBackgroundColor:[UIColor whiteColor]];
    [self.timePicker setHidden:NO];
    
}


-(void)flipPhotos {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ContactAccessGrantedNotification"
         object:self];
    });
    
}


- (void) receiveTestNotification:(NSNotification *) notification
{
    NSLog(@"blah");
    UIView *backgroundview = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 300, 200)];
    backgroundview.layer.borderColor = [UIColor grayColor].CGColor;
    backgroundview.layer.borderWidth = 0.5;
    [backgroundview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:backgroundview];
    
    self.eventTitle = [[UITextField alloc] initWithFrame:CGRectMake(20, 6, 280, 30)];
    self.eventTitle.placeholder = @"Title";
    [self.eventTitle setFont:[UIFont fontWithName:@"GillSans" size:15]];
    [backgroundview addSubview:self.eventTitle];
    [self.eventTitle becomeFirstResponder];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 300, 1)];
        line1.layer.borderColor = [UIColor lightGrayColor].CGColor;
        line1.layer.borderWidth = 0.25;
    [backgroundview addSubview:line1];
    
    UIImageView *clock = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45, 30, 30)];
    [clock setImage:[UIImage imageNamed:@"015"]];
    [backgroundview addSubview:clock];
    
    UIButton *time = [[UIButton alloc] initWithFrame:CGRectMake(60, 45, 100, 30)];
    [time setTitle:@"5 Mar 12:33 pm" forState:UIControlStateNormal];
    [time setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [[time titleLabel] setFont:[UIFont fontWithName:@"GillSans" size:15]];
    [time addTarget:self action:@selector(showTimePicker) forControlEvents:UIControlEventTouchUpInside];
    [backgroundview addSubview:time];


    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 300, 1)];
    line2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    line2.layer.borderWidth = 0.25;
    [backgroundview addSubview:line2];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

@end
