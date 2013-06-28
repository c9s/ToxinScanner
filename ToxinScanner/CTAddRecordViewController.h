//
//  CTAddRecordViewController.h
//  ToxinScanner
//
//  Created by c9s on 13/6/28.
//  Copyright (c) 2013年 Lin Yo-an. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTAddRecordViewController;

@protocol CTAddRecordViewControllerDelegate <NSObject>

@optional // Delegate protocols

- (void)dismissAddRecordViewController:(CTAddRecordViewController *) viewController;

@end

@interface CTAddRecordViewController : UIViewController <ZBarReaderDelegate>

@property (nonatomic, unsafe_unretained, readwrite) id <CTAddRecordViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL barcodeScannerLaunched;
@property (weak, nonatomic) IBOutlet UITextField *barcodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *barcodeTypeTextField;

@property (weak, nonatomic) NSManagedObject * currentRecord;

@end
