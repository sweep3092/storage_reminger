//
//  SRItemIndexTableViewController.h
//  storage_reminder
//
//  Created by You Kobayashi on 2014/09/01.
//  Copyright (c) 2014年 youk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Items.h"
#import "SRAddItemTableViewController.h"

@interface SRItemIndexTableViewController : UITableViewController <SRAddItemViewDelegate>

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *items;

@end
