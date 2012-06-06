/* 
 * FirstViewController.m
 * Vault
 *
 * Created by Jace Allison on December 21, 2011
 * Last modified on May 24, 2011 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 * 
 * This class contains all functions that pertain to the User Interface
 * for filters, selecting, and viewing all documents. This Interface is the
 * first tab on the tab bar named "Documents".  Examples of functions this
 * class holds are:
 *
 *  - A function called when the user uses the search bar
 *  - A function called when the user clicks on a document
 *  - A function called when a request from vault is finished
 */

#import "FirstViewController.h"

extern BOOL initLogin;

@implementation FirstViewController

@synthesize filters;            /* UISegmentedControl buttons */

@synthesize documents;          /* The custom table view cells being used */
@synthesize localSearch;
@synthesize mainView;
@synthesize docData;

@synthesize nameButton;         /* Name button at top left-mid */
@synthesize typeButton;         /* Type button at top middle */
@synthesize dateButton;         /* Date button at top right */

@synthesize documentTypes;      /* Dictionary with all the document types for id */
@synthesize documentNames;      /* Dictionary with all the document names for id */
@synthesize rawDates;
@synthesize datesModified;      /* Dates with all the last modified times for id */
@synthesize fileFormats;        /* Dictionary with all the file formats for id */
@synthesize documentPaths;      /* Dictionary will all the document paths for each file */

@synthesize numOfDocuments;     /* Integer counter for number of documents use has */
@synthesize currentDoc;         /* The current document counter for filter arrays */
@synthesize objResponseCount;   /* The count for the number of object response there are */

@synthesize namePressCount;
@synthesize typePressCount;
@synthesize datePressCount;

@synthesize recentDocsIds;      /* Array containing id's for all recent documents */
@synthesize favoriteDocsIds;    /* Array containing id's for all favorite documents */
@synthesize myDocumentDocsIds;  /* Array containing id's for all "my documents" documents */
@synthesize allDocIds;          /* Array containing all id's in documentNames dictionary */
@synthesize searchResults;      /* Array containing all id's for documents that match search words */

@synthesize docProperties;

@synthesize filterIdentifier;   /* String which identifies which filter the user is currently on */
@synthesize searchFilterIdentifier;

@synthesize pdfData;            /* Data that is brought down and reset each time to store pdf's locally */
@synthesize changedDocs;

@synthesize sortedByName;       /* Array containing document id's sorted by name */
@synthesize sortedByType;       /* Array containing document id's sorted by type */
@synthesize sortedByDate;       /* Array containing document id's sorted by date */
@synthesize sortedBySearch;     
@synthesize sortedKeys, sortedFlags, reverseSortedSearch;
@synthesize sortedDateFlag, sortedNameFlag, sortedTypeFlag, sortedSearchFlag;

@synthesize keychain;
@synthesize invalidSession;
@synthesize authManager;
@synthesize loginCycle;

/* Release any cached data, images, etc that aren't in use. */


#pragma mark - Memory management methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc 
{
    /* Set all properties to nil for ARC */
    
    /* Remove our table view */
    documents = nil;
    
    /* Remove current instances of document information dictionaries */
    documentTypes = nil;
    documentNames = nil;
    datesModified = nil;
    fileFormats = nil;
    documentPaths = nil;
    
    /* Remove current instance of pdfData */
    pdfData = nil;
    
    /* Remove current instances of all filter arrays */
    recentDocsIds = nil;
    favoriteDocsIds = nil;
    myDocumentDocsIds = nil;
    allDocIds = nil;
    searchResults = nil;
    
    /* Set counters to 0 */
    numOfDocuments = 0;
    currentDoc = 0;
    objResponseCount = 0;
    
    /* Remove current instances of sortedFlags */
    sortedFlags = nil;
    
    /* Reset filter identifier to nil */
    filterIdentifier = nil;
}


#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    /* Set the style for our table view */
    self.documents.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /* Initialize all properties */
    
    /* Set up the keychain login manager */
    NSURL *loginUrl = [[NSURL alloc] initWithString:LOGIN_URL];
    authManager = [RKObjectManager objectManagerWithBaseURL:loginUrl];
    invalidSession = NO;
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:USER_CRED accessGroup:nil];
    loginCycle = 0;
    
    /* Set up a authorization object manager to refresh user sessions */
    authManager.serializationMIMEType = RKMIMETypeFormURLEncoded;
    
    /* Serialize the the AuthUserDetail class to send POST data to vault */
    RKObjectMapping *authSerialMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [authSerialMapping mapAttributes:@"username", @"password", nil];
    
    /* Set the mapping attributes to obtain relevent information from Vault */
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[VaultUser class]];
    userMapping.setNilForMissingRelationships = YES;
    [userMapping mapAttributes:@"sessionid", @"responseStatus", nil];
    
    /* Set object mappings */
    [authManager.mappingProvider setObjectMapping:userMapping forResourcePathPattern:@"/auth/api"];
    
    /* Map the properties of the AuthUserDetail class to POST authentication parameters */
    [authManager.mappingProvider setSerializationMapping:authSerialMapping forClass:[AuthUserDetail class]];
    
    /* Set up a router to route the POST call to the right path for authentication */
    [authManager.router routeClass:[AuthUserDetail class] toResourcePath:@"/auth/api"];

    
    /*Initialize dictionaries containing all document information */
    documentTypes = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:DOC_TYPES]];
    documentNames = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:DOC_NAMES]];
    rawDates = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:RAW_DATES]];
    datesModified = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:DATE_MOD]];
    fileFormats = [[NSMutableDictionary alloc] 
                initWithDictionary:[Document loadDocInfoForKey:FILE_FORMAT]];
    documentPaths = [[NSMutableDictionary alloc] initWithDictionary:[Document loadDocInfoForKey:DOC_PATHS]];
    
    docData = [[DocumentsData alloc] init];

    /* Allocate data to be used for pdf binary */
    pdfData = [[NSMutableData alloc] init];
    changedDocs = [[NSMutableArray alloc] init];
    
    /* Allocate each mutable array to be used for filtering */
    recentDocsIds = [[NSMutableArray alloc] 
                initWithArray:[Document loadFiltersForKey:RECENTS]];
    favoriteDocsIds = [[NSMutableArray alloc] 
                initWithArray:[Document loadFiltersForKey:FAVORITES]];
    myDocumentDocsIds = [[NSMutableArray alloc] 
                initWithArray:[Document loadFiltersForKey:MY_DOCUMENTS]];
    allDocIds = [[NSMutableArray alloc] initWithArray:[Document loadFiltersForKey:ALL_DOC_IDS]];
    searchResults = [[NSMutableArray alloc] init];
    
    docProperties = [[DocumentProperties alloc] init];
    
    /* Initialized sorting flags and arrays */
    sortedNameFlag = 0;
    sortedDateFlag = 0;
    sortedTypeFlag = 0;
    sortedSearchFlag = 0;
    sortedByName = [[NSMutableArray alloc] init];
    sortedByType = [[NSMutableArray alloc] init];
    sortedByDate = [[NSMutableArray alloc] init];
    sortedBySearch = [[NSMutableArray alloc] init];
    sortedKeys = [[NSArray alloc] init];
    reverseSortedSearch = [[NSArray alloc] init];
    
    /* Initialized number of documents */
    numOfDocuments = [allDocIds count];
    
    /* Initialize class counters */
    currentDoc = 0;
    objResponseCount = 0;
    namePressCount = 0;
    typePressCount = 0;
    datePressCount = 0;
    
    /* Initilized dictionary to determine when to sort something */
    sortedFlags = [[NSMutableDictionary alloc] 
                   initWithObjectsAndKeys:@"0", @"documentTypes"
                   , @"0", @"datesModified"
                   , @"0", @"documentNames", nil];
    
    /* Set filter Identifier has not been set, set it to all documents */
    if (filterIdentifier == nil)
        filterIdentifier = MY_DOCUMENTS;

    searchFilterIdentifier = false;
}

/* Release any retained subviews of the main view. e.g. self.myOutlet = nil; */

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    [self resetLayoutPortrait:UIInterfaceOrientationIsPortrait(self.interfaceOrientation)];
    
    NSString *session = [VaultUser loadSession];
    
    /* Sync documents if user just logged into Vault */
    if (initLogin == TRUE) {
        initLogin = FALSE;  /* Reset sync global */
        [self clearAllDataOnLogin];
        [self refreshDocuments];
    }
    
    else if (session != nil) {
        
        /* Test to see if the session is still valid */
        [[RKObjectManager sharedManager].client setValue:session forHTTPHeaderField:@"Authorization"];
        [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/metadata/objects" 
                                                        usingBlock:^(RKObjectLoader *loader) {
                                                            loader.method = RKRequestMethodGET;
                                                            loader.delegate = self;
                                                    }];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    /* Return YES for supported orientations */
    return YES;                                                                 
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
    [mainView setNeedsDisplay];
    
    /* Going to Landscape Orientation */
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight
        || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        [self resetLayoutPortrait:NO];
    }
    
    else {  /* Going back to Portrait Orientation */
        [self resetLayoutPortrait:YES];
    }
}


#pragma mark - UITableViewCellDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    /* Only one section in this tableView */
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    /* Customize the number of visible cells depending on the orientation */
    if ([documentNames count] > 24)
        return [documentNames count];
    else
        return PORTRAIT_COUNT;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* Set the cells up to have alternating background colors */
    if ( indexPath.row % 2 == 0) {
        UIColor *altCellColor = [UIColor colorWithRed:237/256.0 green:243/256.0 blue:254/256.0 alpha:1.0];
        cell.backgroundColor = altCellColor;
    }
    else { 
        UIColor *altCellColor2 = [UIColor whiteColor];
        cell.backgroundColor = altCellColor2;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* Since the dictionaries start at 1, we want to hide the cell at row 0 */
    if(indexPath.row == 0){
        return 0.0f;
    }
    
    /* Show all other cells */
    else{
        return CELLHEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        TableView *cell = nil;
        NSString *docId = nil;
        NSString *fileType = nil;
        
        /* If there are files to load into table view, determine the status of the view */
        if ([fileFormats count] != 0 || fileFormats != nil) {
            
            /* If the user has searched and the tableView row is in bounds */
            if (searchFilterIdentifier == true) {
                if ((indexPath.row - 1 >= 0) &&
                    (indexPath.row - 1 < [searchResults count])) {
                    
                    /* If sortedSearchFlag equals 1 the documents are sorted in ascending order */
                    if (sortedSearchFlag == 1){
                        docId = [sortedBySearch objectAtIndex:indexPath.row-1];
                    }
                    /* If sortedSearchFlag equals 2 the documents are sorted in descending order */
                    else if(sortedSearchFlag == 2) {
                        docId = [reverseSortedSearch objectAtIndex:indexPath.row-1];
                    }
                    /*
                     * Else the documents are not sorted and will be shown in the order they were added
                     * to the searchResults array
                     */
                    else {
                        docId = [searchResults objectAtIndex:indexPath.row-1];
                    }
                    
                    /* If there are no more documents to show, docID is set to a blank string so a blank cell appears */
                } else {
                    docId = @"";
                }
            }
            
            /* No searching has occured */
            else {
                
                /* Filter is set to My documents and the tableView row is in bounds, get the document ID */
                if ([filterIdentifier isEqualToString:MY_DOCUMENTS] 
                    && (indexPath.row - 1 >= 0 
                        && indexPath.row - 1 < [myDocumentDocsIds count])) 
                    docId = [myDocumentDocsIds objectAtIndex:indexPath.row - 1];
                
                /* Filter is set to Work In Progress and the tableView row is in bounds, get the document ID */
                else if ([filterIdentifier isEqualToString:WORK_IN_PROGRESS]
                         && indexPath.row - 1 >= 0
                         && indexPath.row - 1 < [allDocIds count]){
                    /* Work In Progress is not implemented so docID is blank for now */
                    docId = @"";
                }
                
                /* Filter is set to Favorites and the tableView row is in bounds, get the document ID */
                else if ([filterIdentifier isEqualToString:FAVORITES] 
                         && (indexPath.row - 1 >= 0 
                             && indexPath.row - 1 < [favoriteDocsIds count])) 
                    docId = [favoriteDocsIds objectAtIndex:indexPath.row - 1];
                
                /* Filter is set to Recents and the tableView row is in bounds, get the document ID */
                else if ([filterIdentifier isEqualToString:RECENTS] 
                         && (indexPath.row - 1 >= 0 
                             && indexPath.row - 1 < [recentDocsIds count])) 
                    docId = [recentDocsIds objectAtIndex:indexPath.row - 1];
                
                /* Filter is set to all documents and the tableView row is in bounds, get the document ID */
                else if ([filterIdentifier isEqualToString:DOCUMENT_INFO] 
                         && indexPath.row - 1 >= 0 
                         && indexPath.row - 1 < [allDocIds count]) {
                    docId = [allDocIds objectAtIndex:indexPath.row - 1];
                    
                }
                /* There are no more documents to show */
                else
                    docId = @"";
            }
            
            /* Get the format of the file */
            fileType = [fileFormats objectForKey:docId];
            /* Strip everything but the last component so it can be easily checked. */
            fileType = [fileType lastPathComponent];
        
        static NSString *CellIdentifier;
        
        if ([[UIApplication sharedApplication] statusBarOrientation ] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown){
            CellIdentifier = @"PortraitCell";
        }else {
            CellIdentifier = @"LandscapeCell";
        }
        
        cell = (TableView*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TableView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.lineColor = [UIColor blackColor];
        }
        
        if (fileType != nil) {                  /* Ensure there is a filepath */
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            if ([searchResults count] == 0){
                /* Sort by document names if user desires */
                if ([[sortedFlags objectForKey:@"documentNames"] isEqual:@"1"]) {
                    id sorteddDocId = [sortedKeys objectAtIndex:indexPath.row-1 ];
                    docId = sorteddDocId;
                    fileType = [fileFormats objectForKey:docId];
                }
                
                /* Sort by document types if user desires */
                else if ([[sortedFlags objectForKey:@"documentTypes"] isEqual:@"1"]) {
                    id sorteddDocId = [sortedKeys objectAtIndex:indexPath.row-1];
                    docId = sorteddDocId;
                    fileType = [fileFormats objectForKey:docId];
                }
                
                /* Sort by dates if user desires */
                else if ([[sortedFlags objectForKey:@"datesModified"] isEqual:@"1"]) {
                    id sorteddDocId = [sortedKeys objectAtIndex:indexPath.row-1];
                    docId = sorteddDocId;
                    fileType = [fileFormats objectForKey:docId];
                }
                fileType = [fileType lastPathComponent];
            }
            /* Set icon to a pdf icon if doucment is pdf document */
            if ([fileType isEqualToString:PDF_FORMAT]) 
                cell.docTypeImage.image = [UIImage imageNamed:PDF_IMG];
            
            /* Set icon to a word icon if document is word document */
            else if ([fileType isEqualToString:MSWORD_FORMAT]) 
                cell.docTypeImage.image = [UIImage imageNamed:DOC_IMG];
            
            /* Set icon to a powerpoint icon if document is powerpoint document */
            else if ([fileType isEqualToString:PPT_FORMAT])
                cell.docTypeImage.image = [UIImage imageNamed:PPT_IMG];
            
            /* Set icon to a excel icon if document is an excel document */
            else if ([fileType isEqualToString:XLS_FORMAT])
                cell.docTypeImage.image = [UIImage imageNamed:XLS_IMG];
            
            /* Do not know what file type the file is, display uknown document icon */
            else
                cell.docTypeImage.image = [UIImage imageNamed:UNKOWN_IMG];
        }
        
        /* There is no file to display */
        else { 
            cell.docTypeImage.image = nil;  /* Do not show an image */
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.docName.text = [documentNames objectForKey:docId];
        cell.docType.text = [documentTypes objectForKey:docId];
        cell.docLastModified.text = [Document timeSinceModified:[datesModified objectForKey:docId]];
    }
            
    return cell;
}

/* Function called when a cell is clicked on by the user */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (([filterIdentifier isEqualToString:MY_DOCUMENTS] && indexPath.row <= [myDocumentDocsIds count])
        || ([filterIdentifier isEqualToString:FAVORITES] && indexPath.row <= [favoriteDocsIds count])
        || ([filterIdentifier isEqualToString:RECENTS] && indexPath.row <= [recentDocsIds count])
        || ([filterIdentifier isEqualToString:DOCUMENT_INFO] && indexPath.row <= [allDocIds count])) {
        
        TableView *cell = ((TableView *)[tableView cellForRowAtIndexPath:indexPath]);
        NSArray *selectedDocArr = [documentNames allKeysForObject:cell.docName.text];
        
        if ([selectedDocArr count] != 0) {
            
            NSString *docNameText = cell.docName.text;
            NSString *pdfFilePath = [Document loadPDF:docNameText];
            NSMutableArray *allProperties = [[NSMutableArray alloc] init];
            NSString *selectedDoc = [selectedDocArr objectAtIndex:0];
            
            NSLog(@"SELECTED DOC IS %@", [docProperties.genProperties objectForKey:selectedDoc]);
            ReaderDocument *doc = [ReaderDocument withDocumentFilePath:pdfFilePath password:nil];
            
            [allProperties addObject:[docProperties.genProperties objectForKey:selectedDoc]];
            
            NSLog(@"PROPERTIES ARE %@", [[allProperties objectAtIndex:0] objectForKey:@"Name"]);
            doc.docProperties = allProperties;
            
            if (doc != nil) {
               
                ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:doc];
                
                readerViewController.delegate = self; // Set the ReaderViewController delegate to self
                
                readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                
                [self presentModalViewController:readerViewController animated:YES];
            }
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - RKObjectLoader Delegate methods

/* This delegate function is called when a request is sent to Vault and an error repsonse is recieved.
 *
 * PARAMETER(S)
 *
 * (RKObjectLoader *)objectLoader   The objectloader used to load the request response
 * (NSError *)error                 Error recieved from HTTP response
 *
 */

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error 
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/* Called when a successfull response is recieved from Vault by use of an RKObjectManager.
 *
 * RETURN VALUE(S)
 *
 * (RKObjectLoader *)objectLoader   The objectloader used to load the request response
 *  (NSArray *)objects              The array containing objects to map to iOS class properties
 */

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects 
{
    objResponseCount++;                                                 /* A new response recieved */
    
    /* Use this if statement when the program tests if the user's session is still valid */
    if ([objectLoader.resourcePath isEqualToString:AUTH_TEST] || objectLoader.isPOST) {
        objResponseCount = 0;                                           /* This statement is not a objResponseCount */
        SessionTest *test = [objects objectAtIndex:0];                  /* Load the test object */
        
        /* If the test failed */
        if ([test.responseStatus isEqualToString:FAILURE] && loginCycle == 0){ 
            
            invalidSession = YES;                                       /* Users session is invalid */
            loginCycle++;                                               /* Increment the loginCycle */
            [self loginWithKeychain];
        }
        
        /* If the test failed because the user changed his/her password on Vault via the Web */
        else if ([test.responseStatus isEqualToString:FAILURE] 
                 && invalidSession == YES 
                 && loginCycle == 1) {
            
            loginCycle++;
            
            /* Create an alert */
            UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"You username and/or password has changed! Please enter you new credentials" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [loginAlert show]; 
        }
    
        /* If refreshing the user's session succeeded */
        else if (invalidSession == YES && (loginCycle == 1 || loginCycle == 2)) {
            loginCycle = 0;                                             /* The loginCycle is over */
            invalidSession = NO;                                        /* Session is no longer invalid */
            
            VaultUser *user = [objects objectAtIndex:0];                /* VaultUser class for JSON object mapping */
            
            /* If the newly aquired session is not different than the old session */
            if (![user.sessionid isEqualToString:[VaultUser loadSession]])
                [VaultUser saveSession:user.sessionid];                 /* Save the new session */
            
            [self refreshDocuments];
        }
        
        /* If any unforseen occurence happens, turn of the network activity indicator */
        else {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }
    
    /* The returned mapped objects are user documents */
    else if ([objectLoader.resourcePath isEqualToString:MY_DOCUMENTS]) {
        myDocumentDocsIds = [self setDwnldInfoForDocs:objects];
        [Document saveFilters:myDocumentDocsIds forKey:MY_DOCUMENTS];
    }
    
    /* The returned mapped objects are favorite documents */
    else if ([objectLoader.resourcePath isEqualToString:FAVORITES]) {
        favoriteDocsIds = [self setDwnldInfoForDocs:objects];
        [Document saveFilters:favoriteDocsIds forKey:FAVORITES];
    }
    
    /* The returned mapped documents are recent documents */
    else if ([objectLoader.resourcePath isEqualToString:RECENTS]) {
        recentDocsIds = [self setDwnldInfoForDocs:objects];
        [Document saveFilters:recentDocsIds forKey:RECENTS];
    }
    
    /* If a response is recieved regarding the Vault users of a document from a request with a user id */
    else if ([[objectLoader.resourcePath substringToIndex:[USERS length]] isEqualToString:USERS]) {
        DocumentUser *docUser = [objects objectAtIndex:0];              /* DocumentUser for JSON object mapping */
        
        /*
         * When a response is recieved regarding users, the objectLoader.username is set to the 
         * the type of user (i.e. OWNER) when sent.  The objectLoader.password is set to the document
         * id that the user is part of (i.e. "1").  These fields make it easy to identify which users
         * are of what type and which documents that they are a part of.
         */
        NSString *whichUser = objectLoader.username;                   
        NSString *propertiesDocId = objectLoader.password;              
        NSString *propertyText = nil;
        
        objResponseCount = 0;                                           /* Not part of objResponseCount */
        
        /* If there is a users first and last name sent with the response from Vault */
        if (docUser.firstName != nil || docUser.lastName != nil) {
        
            /* Make the first and last name of a user into one string */
            propertyText = [docUser.firstName stringByAppendingString:@" "];
            propertyText = [propertyText stringByAppendingString:docUser.lastName];
            
            /* Get a general properties dictionary for a document with the id propertiesDocId */
            NSMutableDictionary *genPropForDoc = [docProperties.genProperties objectForKey:propertiesDocId];
           
            /* If the user is an owner of the document*/
            if ([whichUser isEqualToString:@"OWNER"]) {
                [genPropForDoc setObject:propertyText forKey:@"Created By"];
                [docProperties.genProperties setObject:genPropForDoc forKey:propertiesDocId];
            }
            
            /* If the user is the last modifier of the document */
            else if ([whichUser isEqualToString:@"LASTMOD"]) {
                [genPropForDoc setObject:propertyText forKey:@"Last Modified By"];
                [docProperties.genProperties setObject:genPropForDoc forKey:propertiesDocId];
            }
            
            /* If this is the last response to be recieved regarding users of documents */
            else if ([whichUser isEqualToString:@"LASTMOD LAST"]) {
                [genPropForDoc setObject:propertyText forKey:@"Last Modified By"];
                [docProperties.genProperties setObject:genPropForDoc forKey:propertiesDocId];
                [Document saveDocInfo:docProperties.genProperties forKey:GEN_PROPERTIES];
            }
        }
    }
    
    /* Every object has been retrieved */
    if (objResponseCount == LAST_DOC_OBJ_REQ && ![objectLoader.resourcePath isEqualToString:AUTH_TEST]) {
        objResponseCount = 0;                                           /* No more object responses */
        currentDoc = 0;                                                 /* Restart to first document */
        
        NSMutableArray *tempAllDocIds = [NSMutableArray array];
        for (NSString *key in documentNames)
            [tempAllDocIds addObject:key];
        
        allDocIds = tempAllDocIds;                                      /* New array containing all old and new Doc ids */
        
        /* Save the newly populated dictionaries NSUserDefaults */
        [Document saveDocInfo:documentTypes forKey:DOC_TYPES];
        [Document saveDocInfo:documentNames forKey:DOC_NAMES];
        [Document saveDocInfo:fileFormats forKey:FILE_FORMAT];
        [Document saveDocInfo:rawDates forKey:RAW_DATES];
        [Document saveDocInfo:datesModified forKey:DATE_MOD];
        [Document saveFilters:allDocIds forKey:ALL_DOC_IDS];
        
        numOfDocuments = [allDocIds count];                             /* Number of documents to be on the device */

        [self sendPdfRequest];    
    }
}


#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    /* Reset the NSData property back to 0 to prepare for the new NSData to be retreived */
    [pdfData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    /* Retrieves all binary data from the pdf retrieved from Vault server in multiple calls */
    [pdfData appendData:data];                                          /* Append all data for each request */
}
 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    /* Convert current document Id to a string to use for retrieving the name of the file */
    NSString *pdfName = [documentNames                                                  /* Retrieve documents file name */
            objectForKey:[changedDocs objectAtIndex:currentDoc]];   
    NSString *docPath = [Document savePDF:pdfData withFileName:pdfName];                /* Document path */
    
    [documentPaths setObject:docPath forKey:[changedDocs objectAtIndex:currentDoc]];    /* Save the file path */
    
    currentDoc++;                                                                       /* Increment document count */
    
    /* If there are not more documents to download */
    if (currentDoc < [changedDocs count]) {
        [self sendPdfRequest];                                                          /* Retrieve next document */
    }
    
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;         /* Hide network activity indicator */
        [changedDocs removeAllObjects];                                                 /* Reset the changed documents array */
        [Document saveDocInfo:documentPaths forKey:DOC_PATHS];                          /* Save paths to NSUserDefaults */
        [self.documents reloadData];                                                    /* Update the view */
    }
}


#pragma mark - UISearchBarDelegate methods

-(void)searchDocuments:(NSArray *)filterType withSearchText:(NSString *)searchText{
    
    NSString *document_name = nil;  /* NSString containing the name of the current document from documentNames */
    NSRange textRange;              /* NSRange to test if searchText is a substring of a document_name */
    
    /* Search through the correct dictionary based on the sorted order */
    for (NSString *key in filterType) {
        
        /* Store current document name */
        document_name = [documentNames objectForKey:key];
        
        /* Use rangeOfString to search for searchText in document_name
         Both strings are converted to lowercase first to inforce case insensitivity */
        textRange = [[document_name lowercaseString] rangeOfString:[searchText lowercaseString]];
        
        /* If not NSNotFound then we know that searchText is a substring of document_name */
        if (textRange.location != NSNotFound) {
            [self.searchResults addObject:key];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
   
    /* If a user presses 'Enter' after searching, we want the keyboard to go away */
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    /* The text in the search bar has been manipulated. The old search results are no longer relevant
     *so searchResults needs to be emptied 
     */
    [searchResults removeAllObjects];
    
    searchFilterIdentifier = true;
    
    int isSorted = 0;               /* Flag for checking if the documents have been sorted by name, type, or date */
    NSString *value;                /* The value (0 or 1) of the different keys in sortedFlags */
    
    /* Determine if the documents are sorted */
    for (NSString *key in sortedFlags){
        value = [sortedFlags objectForKey:key];
        
        /* If value is 1, the documents are sorted. They will always only be sorted by one type */
        if ([value isEqualToString:@"1"]) 
            isSorted = [value intValue];
    }
    
    if (isSorted){
        [self searchDocuments:sortedKeys withSearchText:searchText];
    }
    /* If filterIdentifier is set to My Documents, iterate through myDocumentDocsIds to find substrings */
    else if ([filterIdentifier isEqualToString:MY_DOCUMENTS]) {
        [self searchDocuments:myDocumentDocsIds withSearchText:searchText];
    }
    
    /* Filter is set to Favorites */
    else if ([filterIdentifier isEqualToString:FAVORITES]) {
        [self searchDocuments:favoriteDocsIds withSearchText:searchText];
    }
    
    /* Filter is set to Recents */
    else if ([filterIdentifier isEqualToString:RECENTS]) {
        [self searchDocuments:recentDocsIds withSearchText:searchText];
    }
    else{
        /* Filter is set to All Documents */
        [self searchDocuments:allDocIds withSearchText:searchText];
    }
    if ([searchText isEqualToString:@""]) {
        searchFilterIdentifier = false;
    }
    
    /* If sorting has occured, we have to update the correct arrays to the new search results */
    if (sortedSearchFlag == 1) {
        sortedBySearch = searchResults;
    }
    else if (sortedSearchFlag == 2) {
        reverseSortedSearch = searchResults;
        reverseSortedSearch = [[reverseSortedSearch reverseObjectEnumerator] allObjects];
    }
    
    [self.documents reloadData];
}

#pragma mark ReaderViewControllerDelegate methods

/* Called when the user exits out of the PDFViewer.  This dismisses the PDFViewer back
 * to the main documents view.
 *
 * RETURN VALUE(S)
 *
 * (ReaderViewController *)viewController   The reader view controller created by self
 */

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
    
	[self dismissModalViewControllerAnimated:YES];

}


#pragma mark - FirstViewController misc. methods

/* Called when new information about a group of documents is recieved.  This function saves all of this information
 * locally for later use.  Certain document aspects that may be saved would include document name or type.
 *
 * PARAMETER(S)
 *
 * (NSArray *)objects               The array of document objects recieved from the RKObjectLoader request
 * 
 * RETURN VALUE(S)
 *
 * (NSMutableArray *)               An array that is to be set to the array for a specific document filter
 */

- (NSMutableArray *)setDwnldInfoForDocs:(NSArray *)objects
{ 
    /* Initialize function variables */
    Document *document = nil;                                                       /* Document Object */
    NSString *docVersionNumber = nil;                                               /* String to get document version number */
    NSMutableArray *categoryArr = [NSMutableArray array];                           /* Array containing document id's for Vault filters */
    NSMutableDictionary *tempProp = [NSMutableDictionary dictionary];               /* Temporary dictionary to set document properties */
    
    /* Iterate through all documents given in the parameter */
    for (int i = 0; i < [objects count]; i++) {
        document = [objects objectAtIndex:i];                                       /* Set first document */
        
        /* Add all the necessary document information to dictionaries and arrays */
        [categoryArr addObject:document.documentId];                                /* Store document in category array */
        [documentTypes setObject:document.type forKey:document.documentId];         /* Store document type */
        [documentNames setObject:document.name forKey:document.documentId];         /* Store document name */
        [fileFormats setObject:document.format forKey:document.documentId];         /* Store the content file name */
        
        /* If the document has been changed by the user */
        if ((![[rawDates objectForKey:document.documentId] 
               isEqualToString:document.dateLastModified])
            && (![changedDocs containsObject:document.documentId])) {
            [changedDocs addObject:document.documentId];
                
            /* Set the document general properties */
            [tempProp setObject:document.name forKey:@"Name"];                          /* Set document property "Name" */
            
            /* If there is a title (not required) */    
            if (document.title != nil)
                [tempProp setObject:document.title forKey:@"Title"];                    /* Set document property "Title */
            else
                [tempProp setObject:@"" forKey:@"Title"];
            
            [tempProp setObject:document.type forKey:@"Type"];                          /* Set document property "Type" */
            [tempProp setObject:document.docNumber forKey:@"Document Number"];
            [tempProp setObject:[document.size stringByAppendingString:@" KB"] forKey:@"Size"];
            [tempProp setObject:document.format forKey:@"Format"];
            
            docVersionNumber = [document.majorVNum stringByAppendingString:@"."];
            docVersionNumber = [docVersionNumber stringByAppendingString:document.minorVNum];
            
            [tempProp setObject:docVersionNumber forKey:@"Version"];
            [tempProp setObject:document.lifecycle forKey:@"Lifecycle"];
            [tempProp setObject:document.status forKey:@"Status"];
            
            /* Set the properties dictionary of a document with values recived */
            [docProperties.genProperties setObject:[NSMutableDictionary dictionaryWithDictionary:tempProp] forKey:document.documentId];
            
            /* Set user informatoin for each document */
            [docData.createdUsers setObject:document.owner forKey:document.documentId];
            [docData.lastModUsers setObject:document.lastModifier forKey:document.documentId];
            
            /* Clear tempProp for next loop iteration */
            [tempProp removeAllObjects];
        }
        
        [rawDates setObject:document.dateLastModified forKey:document.documentId];  /* Store raw date last modified */
        NSDate *date = [Document convertStringToDate:[rawDates objectForKey:document.documentId]];
        [datesModified setObject:date forKey:document.documentId];
    }
    
    return categoryArr;                 /* Return an array to be set to filter array */
}

/* Called whenever the interface orientation of the iPad needs to be changed.  Depending upon the orientation,
 * this function decides where and how everything should be draw onto the view
 *
 * PARAMETER(S)
 *
 * (BOOL)portrait                   Set to yes if the iPad is in portrait view. Set to NO if not.
 * 
 */

- (void)resetLayoutPortrait:(BOOL)portrait {
    
    if (portrait) {
        
        /* Reset locations of all sorting buttons */
        nameButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTH + 2, 44, DOCNAME_WIDTH - 3, 36);
        typeButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTH + DOCNAME_WIDTH + 2, 44, DOCTYPE_WIDTH - 3, 36);
        dateButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTH + DOCNAME_WIDTH + DOCTYPE_WIDTH + 2, 44, DOCLASTMODIFIED_WIDTH - 3, 36);
    }
    
    else {
        
        /* Reset locations of all sorting buttons */
        nameButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE + 2, 44, DOCNAME_WIDTHLANDSCAPE - 3, 36);
        typeButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE + DOCNAME_WIDTHLANDSCAPE + 2, 44, DOCTYPE_WIDTHLANDSCAPE - 3, 36);
        dateButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE + DOCNAME_WIDTHLANDSCAPE + DOCTYPE_WIDTHLANDSCAPE + 2, 44, DOCLASTMODIFIED_WIDTHLANDSCAPE - 3, 36);
    }
    
    /* Reset all the sorting arrows images on the buttons to disappear */
    nameButton.imageView.image = nil;
    dateButton.imageView.image = nil;
    typeButton.imageView.image = nil;
    
    [mainView setNeedsDisplay];
    [self.documents reloadData];
    
}

/* Called everytime a new request needs to be sent to Vault to retrieve the binary file of PDF Vault document.
 * This function sets up the request for the PDF binary, sends a request to Vault for the document's user(s)
 * information, and then sends the request to Vault for the pdf binary
 *
 */

- (void) sendPdfRequest {
    
    /* If there are new documents or document changes to be retrieved */
    if ([changedDocs count] != 0) {
        NSString *fileResourcePath = BASE_URL;                /* Resource path for rest call to document */
        
        NSMutableURLRequest *pdfRequest = [[NSMutableURLRequest alloc] init];
        NSURLConnection *pdfConnect = [[NSURLConnection alloc] init];
        
        NSString *pdfOwnerPath = [USERS stringByAppendingFormat:
                                  [docData.createdUsers objectForKey:[changedDocs objectAtIndex:currentDoc]]];
        
        NSString *pdfLastModUserPath = [USERS stringByAppendingFormat:
                                        [docData.lastModUsers objectForKey:[changedDocs objectAtIndex:currentDoc]]];
        
        /* Set up the resource path to grab the pdf from */
        fileResourcePath = [fileResourcePath stringByAppendingString:DOCUMENT_INFO];
        fileResourcePath = [fileResourcePath stringByAppendingString:[changedDocs objectAtIndex:currentDoc]];
        fileResourcePath = [fileResourcePath stringByAppendingString:RENDITIONS];
        
        /* If we are not on the last document that needs to be retrieved */
        if (currentDoc == [changedDocs count] - 1) {
            /* GET request to grab the information of the creator of the document for a user id */
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:pdfOwnerPath          
                                                            usingBlock:^(RKObjectLoader *loader) {
                                                                loader.method = RKRequestMethodGET;
                                                                loader.delegate = self;
                                                                loader.username = @"OWNER";         /* User type */
                                                                
                                                                /* Document id the user is part of */
                                                                loader.password = [changedDocs objectAtIndex:currentDoc];
                                                            }];
            
            /* GET request to grab the infomration of the last modifier of the document for a user id */
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:pdfLastModUserPath         
                                                            usingBlock:^(RKObjectLoader *loader) {
                                                                loader.method = RKRequestMethodGET;
                                                                loader.delegate = self;
                                                                loader.username = @"LASTMOD LAST";  /* User type */ 
                                                                
                                                                /* Document id the user is part of */
                                                                loader.password = [changedDocs objectAtIndex:currentDoc];
                                                            }];
        }
        
        /* We are on the last document that needs to be retrieved */ 
        else {
            
            /* 
             * GET request to grab the information of the creator of the document for a user id. However,
             * this is the last request that will be sent for document's owner's information.
             */
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:pdfOwnerPath          
                                                            usingBlock:^(RKObjectLoader *loader) {
                                                                loader.method = RKRequestMethodGET;
                                                                loader.delegate = self;
                                                                loader.username = @"OWNER";
                                                                loader.password = [changedDocs objectAtIndex:currentDoc];
                                                            }];
            
            /* 
             * GET request to grab the infomration of the last modifier of the document for a user id. However, 
             * thus is the last request that will be sent regarding document information.  The binary request is
             * sent after this
             */
            [[RKObjectManager sharedManager] loadObjectsAtResourcePath:pdfLastModUserPath         
                                                            usingBlock:^(RKObjectLoader *loader) {
                                                                loader.method = RKRequestMethodGET;
                                                                loader.delegate = self;
                                                                loader.username = @"LASTMOD";
                                                                loader.password = [changedDocs objectAtIndex:currentDoc];
                                                            }];
        }
        
        /* Set up a request to be sent for the binary PDF file */
        pdfRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fileResourcePath]];
        [pdfRequest setValue:[VaultUser loadSession] forHTTPHeaderField:@"Authorization"];
        [pdfRequest setHTTPMethod:@"GET"];
        pdfConnect = [NSURLConnection connectionWithRequest:pdfRequest delegate:self];  /* Send request */
    }
    
    /* If there are no changes to documents since the last requests were sent */
    else 
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

/* 
 * This function will perform upkeep on all variables related to sorting the documents.
 * It gets called when a user changes filters or pages, to ensure proper sorting can occur
 * the next time a user desires it.
 *
 * PARAMETERS
 *
 * nil
 *
 * RETURN VALUES
 * 
 * nil
 */
- (void) resetSorting {
    [sortedFlags setObject:@"0" forKey:@"documentTypes"];
    [sortedFlags setObject:@"0" forKey:@"datesModified"];
    [sortedFlags setObject:@"0" forKey:@"documentNames"];
    sortedDateFlag = 0;
    sortedNameFlag = 0;
    sortedTypeFlag = 0;
    sortedSearchFlag = 0;
    datePressCount = 0;
    namePressCount = 0;
    typePressCount = 0;
    nameButton.imageView.image = nil;
    typeButton.imageView.image = nil;
    dateButton.imageView.image = nil;
}

/* Called whenever a new filter is selected in the main documents view (i.e. "My Documents").
 *
 * PARAMETER(S)
 *
 * (id)sender               The UIComponent that sent the action
 * 
 * RETURN VALUE(S)
 *
 * (IBAction)               The action to be done upon filter button press
 */

- (IBAction)filterPressed:(id)sender {
    
    /* If the user selected the "My Documents" filter */
    if (filters.selectedSegmentIndex == MY_DOCS_FILTER) 
        filterIdentifier = MY_DOCUMENTS;
    
    /* If the user selected the "Work In Progress" filter */
    else if (filters.selectedSegmentIndex == WIP_FILTER)
        filterIdentifier = WORK_IN_PROGRESS;
    
    /* If the user selected the "Favorites" filter */
    else if (filters.selectedSegmentIndex == FAV_FILTER) 
        filterIdentifier = FAVORITES;
    
    /* If the user selected the "Recent Documents" filter */
    else if (filters.selectedSegmentIndex == RECENT_FILTER) 
        filterIdentifier = RECENTS;
    
    /* If the user selected the "All Documents" filter */
    else if (filters.selectedSegmentIndex == ALL_DOCS_FILTER) 
        filterIdentifier = DOCUMENT_INFO;
    
    [self resetSorting];
    [self.documents reloadData];
}

/* 
 * This function will remove duplicate values from an array
 *
 * PARAMETERS
 *
 * sortedArray          An array of values sorted in a perticular order
 *
 * RETURN VALUES
 * 
 * filteredArray        An array filled with unique values from sortedArray
 */
-(NSMutableArray *)removeDuplicates:(NSMutableArray *)sortedArray{
    NSMutableSet* valuesAdded = [NSMutableSet set];
    NSMutableArray* filteredArray = [[NSMutableArray alloc] init];
    NSString* object;
    
    /* Iterate over the array checking if the value is a member of the set. If its not add it
     * to the set and to the returning array. If the value is already a member, skip over it.
     */
    for (object in sortedArray){
        if (![valuesAdded member:object]){
            [valuesAdded addObject:object];
            [filteredArray addObject:object];
        }
    }
    return filteredArray;
}

/* 
 * This function will sort keys - which will be an array of strings corresponding to document ID's 
 * in a dictionary - in different orders (ascending or descending), for different types (name, type,
 * or date modified), and for different filters (My Documents, Work In Progress, Favorites, Recent,
 * All Documents).
 * NOTE: Only the first set of code is commented. The rest of the code is exactly same, it is just 
 * using different ID's dependening on what filter is currently selected.
 *
 * PARAMETERS
 *
 * docInformation       A dictionary containing the information relevant to how the sorting will take place.
 *                      This will be documentNames, documentTypes, or datesModified.
 *
 * sortedResults        An array that will hold the keys to be sorted.
 *                      This will be sortedByName, sortedByType, or sortedByDate.
 *
 * typeToSort           A string that is used as a flag to determine what type of sorting is occuring. There are
 *                      certain things that have to happen depending on what type of sort is happening.
 *
 * RETURN VALUES
 * 
 * localSortedKeys      A local array that will hold the sorted keys.
 */
-(NSMutableArray *) sortKeys:(NSMutableDictionary *)docInformation withResults:(NSMutableArray *)sortedResults inOrderOf:(NSString *)typeToSort {
    
    NSMutableArray *localSortedKeys = [[NSMutableArray alloc] init];
    NSString *object;
    NSString *objectToKey;
    NSString *key;
    NSArray *keyArray;
    
    /* We have to clear the objects in the array before we add more or else we would double up on files */
    [sortedResults removeAllObjects];
    
    /* Filter is set to My documents */
    if ([filterIdentifier isEqualToString:MY_DOCUMENTS]){
        for (key in myDocumentDocsIds) {
            /* Get the document name as a NSString for every key stored in the filter dictionary */
            [sortedResults addObject:[docInformation objectForKey:key]];
        }
        /* Sort those names into alphabetical order or the dates in ascending order */
        if([typeToSort isEqualToString:@"Date"]){
            [sortedResults sortUsingSelector:@selector(compare:)];
        }
        else{
            [sortedResults sortUsingSelector:@selector(caseInsensitiveCompare:)];
        }
        
        /* If we are sorting by type, we need to remove the duplicate types before we call allKeysForObject */
        if([typeToSort isEqualToString:@"Type"]){
            sortedResults = [self removeDuplicates:sortedResults];
        }
        
        for (object in sortedResults){
            /* Convert the strings back to their keys */
            keyArray = [docInformation allKeysForObject:object];
            
            /* If we need to sort by Type, it takes a little work */
            if([typeToSort isEqualToString:@"Type"]){
                /* The keyArray may have keys in it from the filter we aren't in, we are going to test that */
                for (key in keyArray){
                    /* We'll take each key and test it against the keys in the filter array */
                    for (int i = 0; i<myDocumentDocsIds.count; i++){
                        /* If the key is in the filter array, we add it so it appears, otherwise it doesn't belong */
                        if ([key isEqualToString:[myDocumentDocsIds objectAtIndex:i]]){
                            [localSortedKeys addObject:key];
                        }
                    }
                }
            }
            /* If the sorting isn't by type, convert the objects back to their keys and add them to the array */
            else{
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }
    }
    /* Filter is set to Favorites */
    else if ([filterIdentifier isEqualToString:FAVORITES]){
        for (key in favoriteDocsIds) {
            [sortedResults addObject:[docInformation objectForKey:key]];
        }
        if([typeToSort isEqualToString:@"Date"]){
            [sortedResults sortUsingSelector:@selector(compare:)];
        }
        else{
            [sortedResults sortUsingSelector:@selector(caseInsensitiveCompare:)];
        }
        
        if([typeToSort isEqualToString:@"Type"]){
            sortedResults = [self removeDuplicates:sortedResults];
        }
        
        for (object in sortedResults){
            keyArray = [docInformation allKeysForObject:object];
            if([typeToSort isEqualToString:@"Type"]){
                for (key in keyArray){
                    for (int i = 0; i<favoriteDocsIds.count; i++){
                        if ([key isEqualToString:[favoriteDocsIds objectAtIndex:i]]){
                            [localSortedKeys addObject:key];
                        }
                    }
                }
            }
            else{
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }
    }        
    /* Filter is set to Recents */
    else if ([filterIdentifier isEqualToString:RECENTS]){
        for (key in recentDocsIds) {
            [sortedResults addObject:[docInformation objectForKey:key]];
        }
        if([typeToSort isEqualToString:@"Date"]){
            [sortedResults sortUsingSelector:@selector(compare:)];
        }
        else{
            [sortedResults sortUsingSelector:@selector(caseInsensitiveCompare:)];
        }
        
        if([typeToSort isEqualToString:@"Type"]){
            sortedResults = [self removeDuplicates:sortedResults];
        }
        
        for (object in sortedResults){
            keyArray = [docInformation allKeysForObject:object];
            if([typeToSort isEqualToString:@"Type"]){
                for (key in keyArray){
                    for (int i = 0; i<recentDocsIds.count; i++){
                        if ([key isEqualToString:[recentDocsIds objectAtIndex:i]]){
                            [localSortedKeys addObject:key];
                        }
                    }
                }
            }
            else{
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }
    }
    /* Filter is set to all documents */
    else if ([filterIdentifier isEqualToString:DOCUMENT_INFO]){
        for (key in allDocIds) {
            [sortedResults addObject:[docInformation objectForKey:key]];
        }
        if([typeToSort isEqualToString:@"Date"]){
            [sortedResults sortUsingSelector:@selector(compare:)];
        }
        else{
            [sortedResults sortUsingSelector:@selector(caseInsensitiveCompare:)];
        }
        
        if([typeToSort isEqualToString:@"Type"]){
            sortedResults = [self removeDuplicates:sortedResults];
        }
        
        for (object in sortedResults){
            keyArray = [docInformation allKeysForObject:object];
            if([typeToSort isEqualToString:@"Type"]){
                for (key in keyArray){
                    for (int i = 0; i<allDocIds.count; i++){
                        if ([key isEqualToString:[allDocIds objectAtIndex:i]]){
                            [localSortedKeys addObject:key];
                        }
                    }
                }
            }
            else{
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }
    }
    return localSortedKeys;
}

/* 
 * This function will sort keys - which will be an array of strings corresponding to document ID's 
 * in a dictionary - in different orders (ascending or descending), for different types (name, type,
 * or date modified), and for different filters (My Documents, Favorites, Recent, All Documents).
 * NOTE: This function is exactly the same as sortKeys: but was made into its own function so that
 * sortKeys did not become even more cluttered than it already is. Comments for this code can be 
 * found in the first section (SEE: Filter is set to My Documents) of sortKeys.
 *
 * PARAMETERS
 *
 * docInformation       A dictionary containing the information relevant to how the sorting will take place.
 *                      This will be documentNames, documentTypes, or datesModified.
 *
 * sortedResults        An array that will hold the keys to be sorted.
 *                      This will be sortedByName, sortedByType, or sortedByDate.
 *
 * typeToSort           A string that is used a flag to determine what type of sorting is occuring. There are
 *                      certain things that have to happen depending on what type of sort is happening.
 *
 * RETURN VALUES
 * 
 * localSortedKeys      A local array that will hold the sorted keys.
 */
-(NSMutableArray *) sortSearchResults:(NSMutableDictionary *)docInformation withResults:(NSMutableArray *)sortedResults inOrderOf:(NSString *)typeToSort {
    
    NSMutableArray *localSortedKeys = [[NSMutableArray alloc] init];
    NSString *object;
    NSString *objectToKey;
    NSString *key;
    NSArray *keyArray;
    
    [sortedResults removeAllObjects];
    
    
    for (key in searchResults) {
        [sortedResults addObject:[docInformation objectForKey:key]];
    }
    
    if([typeToSort isEqualToString:@"Date"]){
        [sortedResults sortUsingSelector:@selector(compare:)];
    }
    else{
        [sortedResults sortUsingSelector:@selector(caseInsensitiveCompare:)];
    }
    
    if([typeToSort isEqualToString:@"Type"]){
        sortedResults = [self removeDuplicates:sortedResults];
    }
    
    for (object in sortedResults){
        keyArray = [docInformation allKeysForObject:object];
        if([typeToSort isEqualToString:@"Type"]){
            for (key in keyArray){
                for (int i = 0; i<searchResults.count; i++){
                    if ([key isEqualToString:[searchResults objectAtIndex:i]]){
                        [localSortedKeys addObject:key];
                    }
                }
            }
        }
        else{
            objectToKey = [keyArray objectAtIndex:0];
            [localSortedKeys addObject:objectToKey];
        }
        
    }
    return localSortedKeys;
}


/* 
 * This function will initiate the sorting of the documents. It will place the arrow in the correct
 * location and display whether the documents are being sorted by ascending or descending order. It
 * will do upkeep on the sortedFlags dictionary to ensure the there is no overlapping.
 *
 * PARAMETERS
 *
 * sender               User clicks on the button 'Name' button in the tableView.
 *
 * RETURN VALUES
 * 
 * (IBAction)           The action to be done upon filter button press
 */
- (IBAction)sortByName:(id)sender{
    
    dateButton.imageView.image = nil;
    typeButton.imageView.image = nil;
    
    
    /* Position the arrow buttons for Portrait */
    if ([[UIApplication sharedApplication] statusBarOrientation ] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown){
        if (namePressCount % 2 == 0) {
            [nameButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [nameButton setImageEdgeInsets:UIEdgeInsetsMake(0, 275, 0, 0)];
            [nameButton setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
        }
        else {
            [nameButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [nameButton setImageEdgeInsets:UIEdgeInsetsMake(5, 275, 0, 0)];
            [nameButton setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
        }
        /* Position the arrow buttons for Landscape */
    }else {
        if (namePressCount % 2 == 0) {
            [nameButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [nameButton setImageEdgeInsets:UIEdgeInsetsMake(0, 400, 0, 0)];
            [nameButton setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
        }
        else {
            [nameButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [nameButton setImageEdgeInsets:UIEdgeInsetsMake(5, 400, 0, 0)];
            [nameButton setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
        }
    }
    
    /* Increase the count so we know what direction the arrow goes (Odd Up/Even Down) */
    namePressCount++;
    
    /* Set the appropriate object to 1 to show what we are sorting by */
    [sortedFlags setObject:@"0" forKey:@"documentTypes"];
    [sortedFlags setObject:@"0" forKey:@"datesModified"];
    [sortedFlags setObject:@"1" forKey:@"documentNames"];
    
    /* If the sortedNameFlag is 0, that means we need to sort in ascending order */
    if (sortedNameFlag == 0) {
        
        /* The line directly below this is being called everytime. Ideally it shouldn't be, but
         * sortedKeys has to be filled for a specific case. It goes like this: A user searches
         * for documents, then sorts them, then clears the search bar. The sort is still in effect,
         * and the table will crash if sortedKeys isn't filled with the correct keys
         */
        sortedKeys = [self sortKeys:documentNames withResults:sortedByName inOrderOf:@"Name"];
        
        /* If the user has searched for specific documents, we will sort them and fill the appropriate array */
        if (searchFilterIdentifier == true){
            sortedBySearch = [self sortSearchResults:documentNames withResults:sortedByName inOrderOf:@"Name"];
            sortedSearchFlag = 1;
        }
        
        /* The user hasn't searched, so we fill the sortedKeys array */
        else {
            sortedKeys = [self sortKeys:documentNames withResults:sortedByName inOrderOf:@"Name"];
        }
        
        /* Reload the table and swap the flag */
        [self.documents reloadData];
        sortedNameFlag = 1;
    }
    
    /* If the sortedNameFlag is 1, we just need to reverse the array for descending order */
    else if (sortedNameFlag == 1){
        if (searchFilterIdentifier == true){
            reverseSortedSearch = [[sortedBySearch reverseObjectEnumerator] allObjects];
            sortedSearchFlag = 2;
        }
        else {
            sortedKeys = [[sortedKeys reverseObjectEnumerator] allObjects];
        }
        [self.documents reloadData];
        sortedNameFlag = 0;
    }
}

/* This function is a duplicate of (IBAction)sortByName:(id)sender - All functionality is the same
 * except it uses dictionaries for the document's modified date, instead of document's name. See 
 * sortByName: for all comments explaining the code
 */
- (IBAction)sortByDateModified:(id)sender{
    
    nameButton.imageView.image = nil;
    typeButton.imageView.image = nil;
    
    /* Position the arrow buttons for Portrait */
    if ([[UIApplication sharedApplication] statusBarOrientation ] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown){
        if (datePressCount % 2 == 0) {
            [dateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [dateButton setImageEdgeInsets:UIEdgeInsetsMake(0, 205, 0, 0)];
            [dateButton setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
        }
        else {
            [dateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [dateButton setImageEdgeInsets:UIEdgeInsetsMake(5, 205, 0, 0)];
            [dateButton setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
        }
        /* Position the arrow buttons for Landscape */
    }else {
        if (datePressCount % 2 == 0) {
            [dateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [dateButton setImageEdgeInsets:UIEdgeInsetsMake(0, 255, 0, 0)];
            [dateButton setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
        }
        else {
            [dateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [dateButton setImageEdgeInsets:UIEdgeInsetsMake(5, 255, 0, 0)];
            [dateButton setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
        }
    }
    
    datePressCount++;
    
    [sortedFlags setObject:@"0" forKey:@"documentTypes"];
    [sortedFlags setObject:@"1" forKey:@"datesModified"];
    [sortedFlags setObject:@"0" forKey:@"documentNames"];
    
    if (sortedDateFlag == 0) {
        sortedKeys = [self sortKeys:datesModified withResults:sortedByDate inOrderOf:@"Date"]; 
        if (searchFilterIdentifier == true){
            sortedBySearch = [self sortSearchResults:datesModified withResults:sortedByDate inOrderOf:@"Date"];
            sortedSearchFlag = 1;
        }
        else {
            sortedKeys = [self sortKeys:datesModified withResults:sortedByDate inOrderOf:@"Date"];
        }
        
        [self.documents reloadData];
        sortedDateFlag= 1;
    }
    
    else if (sortedDateFlag == 1){
        if (searchFilterIdentifier == true){
            reverseSortedSearch = [[sortedBySearch reverseObjectEnumerator] allObjects];
            sortedSearchFlag = 2;
        }
        else {
            sortedKeys = [[sortedKeys reverseObjectEnumerator] allObjects];
        }
        [self.documents reloadData];
        sortedDateFlag = 0;
    }
}

/* This function is a duplicate of (IBAction)sortByName:(id)sender - All functionality is the same
 * except it uses dictionaries for the document's type, instead of document's name. See 
 * sortByName: for all comments explaining the code
 */
- (IBAction)sortbyType:(id)sender {
    
    nameButton.imageView.image = nil;
    dateButton.imageView.image = nil;
    
    /* Position the arrow buttons for Portrait */
    if ([[UIApplication sharedApplication] statusBarOrientation ] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown){
        if (typePressCount % 2 == 0) {
            [typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [typeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 150, 0, 0)];
            [typeButton setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
        }
        else {
            [typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [typeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 150, 0, 0)];
            [typeButton setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
        }
        /* Position the arrow buttons for Landscape */
    }else {
        if (typePressCount % 2 == 0) {
            [typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [typeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 195, 0, 0)];
            [typeButton setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
        }
        else {
            [typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [typeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 195, 0, 0)];
            [typeButton setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
        }
    }
    
    typePressCount++;
    
    [sortedFlags setObject:@"1" forKey:@"documentTypes"];
    [sortedFlags setObject:@"0" forKey:@"datesModified"];
    [sortedFlags setObject:@"0" forKey:@"documentNames"];
    
    if (sortedTypeFlag == 0) {
        sortedKeys = [self sortKeys:documentTypes withResults:sortedByType inOrderOf:@"Type"]; //NOTE: Being called every time
        if (searchFilterIdentifier == true){
            sortedBySearch = [self sortSearchResults:documentTypes withResults:sortedByType inOrderOf:@"Type"];
            sortedSearchFlag = 1;
        }
        else {
            sortedKeys = [self sortKeys:documentTypes withResults:sortedByType inOrderOf:@"Type"];
        }
        [self.documents reloadData];
        sortedTypeFlag = 1;
    }
    
    else if (sortedTypeFlag == 1){
        if (searchFilterIdentifier == true){
            reverseSortedSearch = [[sortedBySearch reverseObjectEnumerator] allObjects];
            sortedSearchFlag = 2;
        }
        else {
            sortedKeys = [[sortedKeys reverseObjectEnumerator] allObjects];
        }
        [self.documents reloadData];
        sortedTypeFlag = 0;
    }
}

/* This function is called when the user's documents need to be refreshed because the user's session
 * is no logner valid.  This funcion sends the user's credentials to Vault behind the scenes, allowing
 * the refreshment of documents to be possible 
 */

- (void)loginWithKeychain {
    /* Created an instance of a user to send user credentials to vault */
    AuthUserDetail *userLogin = [[AuthUserDetail alloc] init];
    
    userLogin.username = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    userLogin.password = [keychain objectForKey:(__bridge id)kSecValueData];
    
    /* Send the POST request to vault */
    [authManager postObject:userLogin delegate:self];
    
}

/* Called whenever the user has relogged in using loginWithKeychain or upon the user's manual log in. This function
 Sends all the requests for the document filters "My Documents", "Favorites", and "Recents".
 */
- (void)refreshDocuments {
    /* Show activity indicator in ipad menu bar */
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *session = [VaultUser loadSession];                                /* Load new session */
    
    /* Set the HTTP header to users session id for the "Authorization" paramter */
    [[RKObjectManager sharedManager].client setValue:session 
                                  forHTTPHeaderField:@"Authorization"];
    
    /* GET request to grab recent documents */
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:RECENTS          
                                                    usingBlock:^(RKObjectLoader *loader) {
                                                        loader.method = RKRequestMethodGET;
                                                        loader.delegate = self;
                                                    }];
    /* GET request to user documents */
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:MY_DOCUMENTS     
                                                    usingBlock:^(RKObjectLoader *loader) {
                                                        loader.method = RKRequestMethodGET;
                                                        loader.delegate = self;
                                                    }];
    /* GET request to grab favorite documents */
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:FAVORITES        
                                                    usingBlock:^(RKObjectLoader *loader) {
                                                        loader.method = RKRequestMethodGET;
                                                        loader.delegate = self;
                                                    }]; 
    
}

/* Resign keyboard when enter button on keyboard is pressed */

- (IBAction)hideKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

/* This function prepares the user to log into another Vault account.  If the user wishes to log into another
 * Vault account, this function will first remove all information about the current user that is held by the application.
 * This function removes everything that is saved on the iPad, aside from the document files, which is done
 */
- (void)clearAllDataOnLogin {
    /*Initialize dictionaries containing all document information */
    [documentTypes removeAllObjects];
    [documentNames removeAllObjects];
    [rawDates removeAllObjects];
    [datesModified removeAllObjects];
    [fileFormats removeAllObjects];
    [documentPaths removeAllObjects];
    
    
    /* Allocate each mutable array to be used for filtering */
    [recentDocsIds removeAllObjects];
    [favoriteDocsIds removeAllObjects];
    [myDocumentDocsIds removeAllObjects];
    [allDocIds removeAllObjects];
    
}

@end
