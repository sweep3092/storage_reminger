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
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.15 green:0.13 blue:0.11 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.83 green:0.71 blue:0.56 alpha:1.0]};
    
    _nameTextField.delegate  = self;
    _placeTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (IBAction)cancelButtonPressed:(id)sender {
    [self closeModal];
}

- (IBAction)addButtonPressed:(id)sender {
    [self addItemAndCloseThisModal];
}


#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameTextField) {
        [_placeTextField becomeFirstResponder];
    }
    else if (textField == _placeTextField) {
        [self addItemAndCloseThisModal];
    }
    return YES;
}

#pragma mark - self defined methods

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



-
(void)closeModal {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


- (void)addItemAndCloseThisModal {
    NSString *name  = self.nameTextField.text;
    NSString *place = self.placeTextField.text;
    
    if ([self addItemToCoreDataWithName:name place:place]) {
        [self.addItemViewDelegate itemAdded];
    };
    
    [self closeModal];
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
