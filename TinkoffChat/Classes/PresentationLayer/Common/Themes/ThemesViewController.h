//
//  ThemesViewController.h
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 10/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThemesViewController;
@class Themes;

@protocol ​ThemesViewControllerDelegate <NSObject>

- (void)themesViewController:(ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;

@end

@interface ThemesViewController : UIViewController

@property (nonatomic, retain) Themes *model;
@property (nonatomic, assign) id<​ThemesViewControllerDelegate> delegate;

@end
