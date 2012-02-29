//
//  InvisibleView.m
//  Vault
//
//  Created by Jace Allison on 2/29/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "InvisibleView.h"

@implementation InvisibleView

@synthesize touchController;
@synthesize touchesCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"asdhasdj");
}

@end
