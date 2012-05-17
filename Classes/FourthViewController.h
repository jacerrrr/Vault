//
//  FourthViewController.h
//  Vault
//
//  Created by Jace Allison on 12/22/11.
//  Copyright (c) 2011 Issaquah High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "Document.h"
#import "TableView.h"
#import "VaultSearch.h"

static NSString* const SEARCH_BASE_URL = @"/query/?q=select id, name__v, type__v, format__v from documents find '*";

@interface FourthViewController : UIViewController <RKObjectLoaderDelegate, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>

{
    IBOutlet UITableView *documents;
    IBOutlet UISearchBar *mySearchBar;
}

@property (nonatomic, retain) UITableView *documents;               /* Table view containing documents */
@property (nonatomic, retain) UISearchBar *mySearchBar;
@property (nonatomic, retain) NSMutableArray *vaultSearchResults;        /* Array that stores all document names matching a search text */


-(void)updateVaultSearchResults:(NSArray *)resultSet;



@end
