//
//  DocumentsMainToolbar.m
//  Vault
//
//  Created by Jace Allison on 4/25/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "DocumentsMainToolbar.h"

@implementation DocumentsMainToolbar

@synthesize delegate;
@synthesize docFilters;
@synthesize localSearch;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)docFilterTapped:(id)sender {
    [delegate tappedInToolbar:self filters:sender];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [delegate tappedInToolbar:self searchBar:searchBar textDidChange:searchText];
}

@end
