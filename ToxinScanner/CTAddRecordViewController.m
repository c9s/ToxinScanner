//
//  CTAddRecordViewController.m
//  ToxinScanner
//
//  Created by c9s on 13/6/28.
//  Copyright (c) 2013年 Lin Yo-an. All rights reserved.
//

#import "CTAddRecordViewController.h"
#import "CTDataController.h"

@interface CTAddRecordViewController ()

@end

@implementation CTAddRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog( @"CTAddRecordViewController viewDidLoad" );
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    if ( ! self.barcodeScannerLaunched ) {
        [self runBarCodeScanner];
        self.barcodeScannerLaunched = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)dismissAddRecordViewController:(CTAddRecordViewController *)viewController
{
	[self.navigationController popViewControllerAnimated:YES];
	// [self dismissModalViewControllerAnimated:YES];
}

- (void)runBarCodeScanner {
    
    // [self dismissModalViewControllerAnimated:YES];
    
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = (id) self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    // [reader release];
}



- (void) insertNewObject:(id)sender
{
    CTDataController *data = [CTDataController shared];
    
    NSManagedObjectContext *context = [data.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[data.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"createdAt"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}




- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    
    
    ZBarSymbol *symbol = nil;
    for(symbol in results) {
        // just grab the first barcode
        break;
    }
    
    // EXAMPLE: do something useful with the barcode data
    // resultText.text = symbol.data;
    
    
    NSLog([ZBarSymbol nameForType: symbol.type]);
    NSLog(symbol.data);
    
    // EXAMPLE: do something useful with the barcode image
    // resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
