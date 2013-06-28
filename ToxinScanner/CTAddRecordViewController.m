//
//  CTAddRecordViewController.m
//  ToxinScanner
//
//  Created by c9s on 13/6/28.
//  Copyright (c) 2013年 Lin Yo-an. All rights reserved.
//

#import "CTAddRecordViewController.h"
#import "CTDataController.h"
#import "CTCameraViewController.h"

@interface CTAddRecordViewController ()

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *startStopButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *delayedPhotoButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;


@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;


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
        // [self runBarCodeScanner];
        [self runProductImageCapturer];
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


- (void) runProductImageCapturer {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
    }
    
    self.imagePickerController = imagePickerController;
    // [self presentModalViewController:self.imagePickerController animated:YES completion:nil];
    [self presentModalViewController:self.imagePickerController animated:YES];
 
    // cameraController.delegate = (id) self;
    // [self presentViewController:addController animated:YES completion: nil];
    // [self presentModalViewController:cameraController animated:YES];
}

- (void)runBarCodeScanner {
    
    // [self dismissModalViewControllerAnimated:YES];
    
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    
    reader.readerDelegate = (id) self;
    
    /*
    reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    reader.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
     
     http://stackoverflow.com/questions/10782660/i-can-not-use-sourcetype-as-uiimagepickercontrollersourcetypephotolibrary-in-zba
     */
    /*
    if ([ZBarReaderController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        reader.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
     */
    
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


- (NSManagedObject *) createNewProduct: (NSString*)barcodeId type:(NSString*) barcodeType
{
    CTDataController *data = [CTDataController shared];
    
    NSManagedObjectContext *context = [data.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[data.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    [newManagedObject setValue:[NSDate date] forKey:@"createdAt"];
    [newManagedObject setValue:barcodeId forKey:@"barcodeId"];
    [newManagedObject setValue:barcodeType forKey:@"barcodeType"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return newManagedObject;
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
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    
    ZBarSymbol *symbol = nil;
    for(symbol in results) {
        // just grab the first barcode
        break;
    }
    
    // EXAMPLE: do something useful with the barcode data
    // resultText.text = symbol.data;
    
    
    NSLog([ZBarSymbol nameForType: symbol.type]);
    NSLog(symbol.data);
    
    self.currentRecord = [self createNewProduct:symbol.data
                      type: [ZBarSymbol nameForType: symbol.type]];
    
    
    
    NSString * typeName = [ZBarSymbol nameForType: symbol.type];
    
    // self.imageView.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    self.barcodeTextField.text = symbol.data;
    self.barcodeTypeTextField.text = typeName;
    [reader dismissModalViewControllerAnimated: YES];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
