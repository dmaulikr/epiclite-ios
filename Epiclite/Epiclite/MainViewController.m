//
//  MainViewController.m
//  Epiclite
//
//  Created by DURGA PANDEY on 2/8/14.
//  Copyright (c) 2014 12 Labs. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, retain) IBOutlet UIButton *mainButton;
@property (nonatomic, retain) IBOutlet NSNumber *rightPosition;


@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mainButton addTarget:self action:@selector(finishedDragging:withEvent:)
                    forControlEvents:UIControlEventTouchDragExit];
    self.rightPosition = [NSNumber numberWithBool:NO];
    
}



- (void)finishedDragging:(UIButton *)button withEvent:(UIEvent *)event {
    
    UIControl *control = button;
    
    if (!self.rightPosition.boolValue) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        control.center = CGPointMake(270, 533);
        [UIView commitAnimations];
        self.rightPosition = [NSNumber numberWithBool:YES];
    }
    else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        control.center = CGPointMake(40, 533);
        [UIView commitAnimations];
        self.rightPosition = [NSNumber numberWithBool:NO];
    }
    
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
