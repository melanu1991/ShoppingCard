//
//  AppDelegate.h
//  ShoppingCard
//
//  Created by melanu1991 on 19.07.17.
//  Copyright © 2017 melanu1991. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

