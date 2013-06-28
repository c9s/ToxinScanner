//
//  CTMasterViewController.h
//  ToxinScanner
//
//  Created by Lin Yo-an on 6/27/13.
//  Copyright (c) 2013 Lin Yo-an. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTDetailViewController;

#import <CoreData/CoreData.h>
#import "CTCameraViewController.h"

@interface CTMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) CTDetailViewController *detailViewController;
@property (strong, nonatomic) CTCameraViewController *aplViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
