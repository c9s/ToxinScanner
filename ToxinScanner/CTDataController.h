//
//  CTDataController.h
//  ToxinScanner
//
//  Created by c9s on 13/6/28.
//  Copyright (c) 2013年 Lin Yo-an. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTDataController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
@end
