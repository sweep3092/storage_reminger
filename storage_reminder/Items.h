//
//  Items.h
//  storage_reminder
//
//  Created by You Kobayashi on 2014/09/01.
//  Copyright (c) 2014年 youk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define ENTITY_NAME @"Items"
#define MODEL_NAME  @"SRItems"
#define DB_NAME     @"SRItems.sqlite"


@interface Items : NSManagedObject

@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *place;
@property (nonatomic, retain) NSDate *modified;

@end
