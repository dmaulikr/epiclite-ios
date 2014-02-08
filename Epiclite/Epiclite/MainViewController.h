//
//  MainViewController.h
//  Epiclite
//
//  Created by DURGA PANDEY on 2/8/14.
//  Copyright (c) 2014 12 Labs. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
