/* 
 * AppDelegate.h
 * Vault
 *
 * Created by Jace Allison on December 21, 2011
 * Last modified on December 22, 2011 by Jace Allison
 *
 * Copyright 2011 Oregon State University. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "VaultUser.h"
#import "Document.h"
#import "TableView.h"

@interface FirstViewController : UIViewController <RKObjectLoaderDelegate, NSURLConnectionDataDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView* documents;
}

@property(strong, nonatomic) IBOutlet UISegmentedControl *filters;      /* Text field where user inputs username */

@property (nonatomic, retain) UITableView* documents;               /* Table view containing documents */
@property (nonatomic, retain) NSMutableDictionary *documentTypes;   /* Mutable Dictionary containing document types */
@property (nonatomic, retain) NSMutableDictionary *documentNames;   /* Mutable Dictionary containing document names */
@property (nonatomic, retain) NSMutableDictionary *datesModified;   /* Mutable Dictionary containing dates modified */
@property (nonatomic, retain) NSMutableDictionary *contentFiles;    /* Mutable Dictionary containing document file name */
@property (nonatomic, retain) NSMutableDictionary *documentPaths;   /* Mutable Dictionary containing document paths */
@property (nonatomic, retain) NSMutableArray *recentDocsIds;
@property (nonatomic, retain) NSMutableArray *favoriteDocsIds;
@property (nonatomic, retain) NSMutableArray *myDocumentDocsIds;
@property (nonatomic, retain) NSMutableData *pdfData;               /* Pdf data to be retrieved from Vault server */
@property (nonatomic,retain) NSString *filterIdentifier;
@property (nonatomic) int numOfDocuments;                           /* The number of documents being retrieved */
@property (nonatomic) int currentDocId;                             /* The current document just retrieved */

- (void)sendPdfRequest;

- (IBAction)filterPressed:(id)sender;

@end
