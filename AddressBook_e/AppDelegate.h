//
//  AppDelegate.h
//  AddressBook_e
//
//  Created by KeX on 2017/4/13.
//  Copyright © 2017年 KeX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

