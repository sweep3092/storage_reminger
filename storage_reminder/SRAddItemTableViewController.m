//
//  SRAddItemTableViewController.m
//  storage_reminder
//
//  Created by You Kobayashi on 2014/09/01.
//  Copyright (c) 2014年 youk. All rights reserved.
//

#import "SRAddItemTableViewController.h"

@interface SRAddItemTableViewController ()

@end

@implementation SRAddItemTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)cancelButtonPressed:(id)sender {
    [self closeModal];
}

- (IBAction)addButtonPressed:(id)sender {
    NSString *name  = self.nameTextField.text;
    NSString *place = self.placeTextField.text;
    
    if ([self addItemToCoreDataWithName:name place:place]) {
        [self.addItemViewDelegate itemAdded];
    };
    
    [self closeModal];
}

- (void)closeModal {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}



- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:MODEL_NAME withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:DB_NAME];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if ( ![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error] ) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}





- (bool)addItemToCoreDataWithName:(NSString *)name place:(NSString *)place {
    if ( ![self managedObjectContext] ) {
        NSLog(@"context is nil");
        return NO;
    }
    Items *newObject = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME
                                                     inManagedObjectContext:[self managedObjectContext]];
    
    newObject.name  = name;
    newObject.place = place;
    
    NSError *error = nil;
    if ( [[self managedObjectContext] save:&error] ) {
        return YES;
    }
    else {
        return NO;
    }
}


- (NSURL *)applicationDocumentsDirectory
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return url;
}

@end
