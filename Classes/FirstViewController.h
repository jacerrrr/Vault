/* 
 * FirstViewController.h
 * Vault
 *
 * Created by Jace Allison on December 21, 2011
 * Last modified on December 22, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "VaultUser.h"
#import "DocumentProperties.h"
#import "DocumentsData.h"
#import "Document.h"
#import "TableView.h"
#import "DocumentUser.h"
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
@property (nonatomic, strong) IBOutlet UISegmentedControl *filters; /* Text field where user inputs username */
@property (nonatomic, strong) IBOutlet UISearchBar *localSearch;    /* Search bar for searching local documents */
@property (nonatomic, strong) IBOutlet DocumentsView *mainView;     /* Main overlaying view of documents */
@property (nonatomic, strong) DocumentsData *docData;               /* Object that holds document data */


/* Buttons in the view */
@property (nonatomic, strong) IBOutlet UIButton *nameButton;        /* Name button for sorting by name */    
@property (nonatomic, strong) IBOutlet UIButton *typeButton;        /* Type button for sorting by type */
@property (nonatomic, strong) IBOutlet UIButton *dateButton;        /* Date button for sorting by date */

@property (nonatomic, strong) UITableView* documents;               /* Table view containing documents */


/* Document property dictionaries 
 *
 * TODO
 *  - Move to DocumentsData class
 */
@property (nonatomic, strong) NSMutableDictionary *documentTypes;   /* Mutable Dictionary containing document types */
@property (nonatomic, strong) NSMutableDictionary *documentNames;   /* Mutable Dictionary containing document names */
@property (nonatomic, strong) NSMutableDictionary *rawDates;        /* The date information as is from Vault */
@property (nonatomic, strong) NSMutableDictionary *datesModified;   /* Mutable Dictionary containing dates modified */
@property (nonatomic, strong) NSMutableDictionary *fileFormats;     /* Mutable Dictionary containing document format */
@property (nonatomic, strong) NSMutableDictionary *documentPaths;   /* Mutable Dictionary containing document paths */


/* Filter Arrays 
 *
 * TODO
 *  - Move to DocumentsData class
*/
@property (nonatomic, strong) NSMutableArray *recentDocsIds;        /* Array for storing all document id's in the recent catagory */
@property (nonatomic, strong) NSMutableArray *favoriteDocsIds;      /* Array for storing all document id's in the favorites catagory */
@property (nonatomic, strong) NSMutableArray *myDocumentDocsIds;    /* Array for storing all ducment id's in the my documents catagory */
@property (nonatomic, strong) NSMutableArray *searchResults;        /* Array that stores all documents matching a search text */
@property (nonatomic, strong) NSMutableArray *allDocIds;            /* All document id's that the user has pulled down */

@property (nonatomic, strong) NSMutableData *pdfData;               /* Pdf data to be retrieved from Vault server */
@property (nonatomic, strong) NSMutableArray *changedDocs;          /* Array to hold documents that have been modified */

@property (nonatomic,strong) NSString *filterIdentifier;            /* String that determines which document filter is currently selected */
@property (nonatomic) BOOL searchFilterIdentifier;                  /* Determines if the use is using the search bar */

/* Counters */
@property (nonatomic) int numOfDocuments;                           /* The number of documents being retrieved */
@property (nonatomic) int currentDoc;                               /* The current document just retrieved */
@property (nonatomic) int objResponseCount;                         /* Variable to store the maximum number of object mapping responses */
@property (nonatomic) int namePressCount;                           /* Count for number of times named filter has been tapped */
@property (nonatomic) int typePressCount;                           /* Count for number of times type filter has been tapped */
@property (nonatomic) int datePressCount;                           /* Count for number of times date filter has been tapped */

@property (nonatomic, strong) DocumentProperties *docProperties;    /* Object containing information on document properties */

/* Sort Arrays */
@property (nonatomic, strong) NSMutableArray *sortedByName;         /* NSArray containing the documents sorted by name */
@property (nonatomic, strong) NSMutableArray *sortedByType;         /* NSArray containing the documents sorted by type */
@property (nonatomic, strong) NSMutableArray *sortedByDate;         /* NSArray containing the documents sorted by name */
@property (nonatomic, retain) NSMutableArray *sortedBySearch;       /* NSArray containing the searched document sorted in a certain order*/ 
@property (nonatomic, retain) NSArray *sortedKeys;                  /* NSArray containing the document keys in a sorted order */ 
@property (nonatomic, retain) NSArray *reverseSortedSearch;         /* NSArray containing the searched documents in reverse order */ 

@property (nonatomic, strong) NSMutableDictionary *sortedFlags;     /* Mutable Dictionary containing user sort preferences */

/* Flags */
@property (nonatomic) int sortedNameFlag;                           /* Flag that determines if name is being sorted */
@property (nonatomic) int sortedTypeFlag;                           /* Flag that determines if type is being sorted */
@property (nonatomic) int sortedDateFlag;                           /* Flag that determines if date is being sorted */
@property (nonatomic) int sortedSearchFlag;                         /* Flag that determines if search results should be sorted */

@property (nonatomic, strong) KeychainItemWrapper *keychain;        /* Keychain object used to save user credetials securely */
@property (nonatomic) BOOL invalidSession;                          /* BOOL that says if users session is invalid */
@property (nonatomic, strong) RKObjectManager *authManager;         /* An authentication object manager for refreshing user session */
@property (nonatomic) int loginCycle;                               /* Integer number that hold number of requests sent checking loging in */

- (NSMutableArray *)setDwnldInfoForDocs:(NSArray *)objects;
- (void)resetLayoutPortrait:(BOOL)portrait;
- (void)sendPdfRequest;
- (void) resetSorting;
- (IBAction)filterPressed:(id)sender;
- (NSMutableArray *)removeDuplicates:(NSMutableArray *)sortedArray;
-(NSMutableArray *) sortSearchResults:(NSMutableDictionary *)docInformation 
                          withResults:(NSMutableArray *)sortedResults inOrderOf:(NSString *)typeToSort;
- (NSMutableArray *) sortKeys:(NSMutableDictionary *)docInformation 
                  withResults:(NSMutableArray *)sortedResults inOrderOf:(NSString *)typeToSort;
- (IBAction)sortByName:(id)sender;
- (IBAction)sortbyType:(id)sender;
- (IBAction)sortByDateModified:(id)sender;
- (void)loginWithKeychain;
- (void)refreshDocuments;

@end
