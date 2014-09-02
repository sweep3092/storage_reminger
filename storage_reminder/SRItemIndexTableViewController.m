//
//  SRItemIndexTableViewController.m
//  storage_reminder
//
//  Created by You Kobayashi on 2014/09/01.
//  Copyright (c) 2014年 youk. All rights reserved.
//

#import "SRItemIndexTableViewController.h"

@interface SRItemIndexTableViewController ()

@end

@implementation SRItemIndexTableViewController

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
    
    _items = [self loadAllData];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.15 green:0.13 blue:0.11 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.83 green:0.71 blue:0.56 alpha:1.0]};
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"items"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[_items objectAtIndex:indexPath.row] objectForKey:@"place"];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete:
            [self deleteDataWithObjectIdURI:[[_items objectAtIndex:indexPath.row] objectForKey:@"objectId"]];
            break;
        
        default:
            break;
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



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

- (NSMutableArray *)loadAllData {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_NAME
                                              inManagedObjectContext:[self managedObjectContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchResults = [[self managedObjectContext] executeFetchRequest:request
                                                                       error:&error];
    
    if ( [fetchResults count] > 0 ) {
        for (Items *item in fetchResults) {
            NSDictionary *dictionary_item = @{ @"objectId": [item.objectID URIRepresentation], @"name": item.name, @"place": item.place };
            [items addObject:dictionary_item];
        }
    }
    return items;
}

- (void)deleteDataWithObjectIdURI:(NSURL *)objectIdURI {
    NSFetchRequest *deleteRequest = [[NSFetchRequest alloc] init];
    [deleteRequest setEntity:[NSEntityDescription entityForName:ENTITY_NAME
                                         inManagedObjectContext:[self managedObjectContext]]];
    [deleteRequest setIncludesPropertyValues:NO]; // only NSManagedObjectID
    
    NSError *error = nil;
    
    NSArray *results = [[self managedObjectContext] executeFetchRequest:deleteRequest
                                                                  error:&error];
    
    // TODO: 高効率化
    for (NSManagedObject *data in results) {
        if ([[data.objectID URIRepresentation] isEqual:objectIdURI]) {
            [[self managedObjectContext] deleteObject:data];
            break;
        }
    }
    
    NSError *saveError = nil;
    
    [[self managedObjectContext] save:&saveError];
    
    [self itemAdded];
}


- (NSURL *)applicationDocumentsDirectory
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return url;
}




- (void)itemAdded {
    _items = [self loadAllData];
    [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller
    SRAddItemTableViewController *addItemVC = (SRAddItemTableViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
    addItemVC.addItemViewDelegate = self;
}


@end
