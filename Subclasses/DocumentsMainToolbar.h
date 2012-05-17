//
//  DocumentsMainToolbar.h
//  Vault
//
//  Created by Jace Allison on 4/25/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DocumentsMainToolbar;

@protocol DocumentsMainToolbarDelegate <NSObject>

- (void)tappedInToolbar:(DocumentsMainToolbar *)toolbar filters:(UISegmentedControl *)filters;
- (void)tappedInToolbar:(DocumentsMainToolbar *)toolbar searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;

@end

@interface DocumentsMainToolbar : UIToolbar <UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UISegmentedControl *docFilters;
@property (nonatomic, strong) IBOutlet UISearchBar *localSearch;
@property (nonatomic, strong) id <DocumentsMainToolbarDelegate> delegate;

@end
