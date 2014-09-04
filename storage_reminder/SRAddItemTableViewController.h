//
//  SRAddItemTableViewController.h
//  storage_reminder
//
//  Created by You Kobayashi on 2014/09/01.
//  Copyright (c) 2014年 youk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Items.h"

@protocol SRAddItemViewDelegate <NSObject>

- (void)itemAdded;

@end

@interface SRAddItemTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) id <SRAddItemViewDelegate> addItemViewDelegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *placeTextField;

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
