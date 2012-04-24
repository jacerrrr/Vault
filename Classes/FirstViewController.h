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
#import "ReaderViewController.h"
#import "SessionTest.h"
#import "DocumentsView.h"
#import "KeychainItemWrapper.h"
#import "AuthUserDetail.h"

@interface FirstViewController : UIViewController <RKObjectLoaderDelegate, NSURLConnectionDataDelegate, UITableViewDelegate, 
                                                   UITableViewDataSource, UISearchBarDelegate, ReaderViewControllerDelegate>
{
    IBOutlet UITableView* documents;
}

/* UISegmentedControl for doc filters */
@property (nonatomic, retain) IBOutlet UISegmentedControl *filters; /* Text field where user inputs username */
@property (nonatomic, retain) IBOutlet DocumentsView *mainView;

/* Buttons in the view */
@property (nonatomic, retain) IBOutlet UIButton *nameButton;        /* Name button for sorting by name */    
@property (nonatomic, retain) IBOutlet UIButton *typeButton;        /* Type button for sorting by type */
@property (nonatomic, retain) IBOutlet UIButton *dateButton;        /* Date button for sorting by date */

@property (nonatomic, retain) UITableView* documents;               /* Table view containing documents */

/* Document property dictionaries */
@property (nonatomic, retain) NSMutableDictionary *documentTypes;   /* Mutable Dictionary containing document types */
@property (nonatomic, retain) NSMutableDictionary *documentNames;   /* Mutable Dictionary containing document names */
@property (nonatomic, retain) NSMutableDictionary *rawDates;
@property (nonatomic, retain) NSMutableDictionary *datesModified;   /* Mutable Dictionary containing dates modified */
@property (nonatomic, retain) NSMutableDictionary *fileFormats;     /* Mutable Dictionary containing document format */
@property (nonatomic, retain) NSMutableDictionary *documentPaths;   /* Mutable Dictionary containing document paths */

/* Filter Arrays */
@property (nonatomic, retain) NSMutableArray *recentDocsIds;        /* Array for storing all document id's in the recent catagory */
@property (nonatomic, retain) NSMutableArray *favoriteDocsIds;      /* Array for storing all document id's in the favorites catagory */
@property (nonatomic, retain) NSMutableArray *myDocumentDocsIds;    /* Array for storing all ducment id's in the my documents catagory */
@property (nonatomic, retain) NSMutableArray *searchResults;        /* Array that stores all documents matching a search text */
@property (nonatomic, retain) NSMutableArray *allDocIds;            /* All document id's that the user has pulled down */

@property (nonatomic, retain) NSMutableData *pdfData;               /* Pdf data to be retrieved from Vault server */
@property (nonatomic, retain) NSMutableArray *changedDocs;

@property (nonatomic,retain) NSString *filterIdentifier;            /* String that determines which document filter is currently selected */
@property (nonatomic) BOOL searchFilterIdentifier;

/* Counters */
@property (nonatomic) int numOfDocuments;                           /* The number of documents being retrieved */
@property (nonatomic) int currentDoc;                               /* The current document just retrieved */
@property (nonatomic) int objResponseCount;                         /* Variable to store the maximum number of object mapping responses */
@property (nonatomic) int namePressCount;
@property (nonatomic) int typePressCount;
@property (nonatomic) int datePressCount;

/* Sort Arrays */
@property (nonatomic, retain) NSMutableArray *sortedByName;                /* NSArray containing the documents sorted by name */
@property (nonatomic, retain) NSMutableArray *sortedByType;                /* NSArray containing the documents sorted by type */
@property (nonatomic, retain) NSMutableArray *sortedByDate;                /* NSArray containing the documents sorted by name */
@property (nonatomic, retain) NSArray *sortedKeys;

@property (nonatomic, retain) NSMutableDictionary *sortedFlags;     /* Mutable Dictionary containing user sort preferences */

/* Flags */
@property (nonatomic) int sortedNameFlag;
@property (nonatomic) int sortedTypeFlag;
@property (nonatomic) int sortedDateFlag;

@property (nonatomic, retain) KeychainItemWrapper *keychain;
@property (nonatomic) BOOL invalidSession;
@property (nonatomic, retain) RKObjectManager *authManager;
@property (nonatomic) int loginCycle;

- (void)sendPdfRequest;
- (IBAction)filterPressed:(id)sender;
- (IBAction)sortByName:(id)sender;
- (IBAction)sortbyType:(id)sender;
- (IBAction)sortByDateModified:(id)sender;
- (void)loginWithKeychain;
- (void)refreshDocuments;

@end
