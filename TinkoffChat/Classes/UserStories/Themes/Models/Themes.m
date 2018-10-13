//
//  Themes.m
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 10/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

#import "Themes.h"

@implementation Themes

@synthesize theme1 = _theme1;
@synthesize theme2 = _theme2;
@synthesize theme3 = _theme3;

- (instancetype)init {
    self = [super init];
    if (self) {
        _theme1 = [UIColor blackColor];
        _theme2 = [UIColor blueColor];
        _theme3 = [UIColor whiteColor];
    }
    return self;
}

- (void)setTheme1:(UIColor *)theme1 {
    if (_theme1 != theme1) {
        UIColor *oldValue = _theme1;
        _theme1 = [theme1 retain];
        [oldValue release];
    }
}

- (void)setTheme2:(UIColor *)theme2 {
    if (_theme2 != theme2) {
        UIColor *oldValue = _theme2;
        _theme2 = [theme2 retain];
        [oldValue release];
    }
}

- (void)setTheme3:(UIColor *)theme3 {
    if (_theme3 != theme3) {
        UIColor *oldValue = _theme3;
        _theme3 = [theme3 retain];
        [oldValue release];
    }
}

- (UIColor *)theme1 {
    return _theme1;
}

- (UIColor *)theme2 {
    return _theme2;
}

- (UIColor *)theme3 {
    return _theme3;
}

- (void)dealloc {
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];
    [super dealloc];
}

@end
