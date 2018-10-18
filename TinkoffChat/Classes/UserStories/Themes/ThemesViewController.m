//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 10/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

#import "ThemesViewController.h"
#import "Themes.h"

@interface ThemesViewController ()

@property (nonatomic, retain) NSArray *themesArray;

@end

@implementation ThemesViewController

@synthesize model = _model;
@synthesize delegate = _delegate;
@synthesize themesArray = _themesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [[[Themes alloc] init] autorelease];
    self.themesArray = [[[NSArray alloc] initWithObjects:self.model.theme1, self.model.theme2, self.model.theme3, nil] autorelease];
}

- (IBAction)didTapThemeButton:(UIButton *)sender {
    UIColor *color = [self.themesArray objectAtIndex:sender.tag];
    self.view.backgroundColor = color;
    [self.delegate themesViewController:self didSelectTheme:color];
}

- (IBAction)didTapCloseButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setDelegate:(id<​ThemesViewControllerDelegate>)delegate {
    _delegate = delegate;
}

- (id<​ThemesViewControllerDelegate>)delegate {
    return _delegate;
}

- (void)setModel:(Themes *)model {
    if (_model != model) {
        Themes *oldValue = _model;
        _model = [model retain];
        [oldValue release];
    }
}

- (Themes *)model {
    return _model;
}

- (void)setThemesArray:(NSArray *)themesArray {
    if (_themesArray != themesArray) {
        NSArray *oldValue = _themesArray;
        _themesArray = [themesArray retain];
        [oldValue release];
    }
}

- (NSArray *)themesArray {
    return _themesArray;
}

- (void)dealloc {
    [_model release];
    [_themesArray release];
    [super dealloc];
}

@end
