/* 
 * AppDelegate.h
 * Vault
 *
 * Created by Jace Allison on December 21, 2011
 * Last modified on December 22, 2011 by Jace Allison
 *
 * Copyright 2011 Oregon State University. All rights reserved.
 */

#import "FirstViewController.h"

extern BOOL initLogin;

@implementation FirstViewController

@synthesize filters;            /* UISegmentedControl buttons */

@synthesize documents;          /* The custom table view cells being used */
@synthesize mainView;

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

@synthesize filterIdentifier;   /* String which identifies which filter the user is currently on */
@synthesize searchFilterIdentifier;

@synthesize pdfData;            /* Data that is brought down and reset each time to store pdf's locally */
@synthesize changedDocs;

@synthesize sortedByName;       /* Array containing document id's sorted by name */
@synthesize sortedByType;       /* Array containing document id's sorted by type */
@synthesize sortedByDate;       /* Array containing document id's sorted by date */
@synthesize sortedKeys;
@synthesize sortedFlags;
@synthesize sortedDateFlag, sortedNameFlag, sortedTypeFlag;

@synthesize keychain;
@synthesize invalidSession;
@synthesize authManager;
@synthesize loginCycle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/* Release any cached data, images, etc that aren't in use. */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
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
    
    
    /* Initialized sorting flags and arrays */
    sortedNameFlag = 0;
    sortedDateFlag = 0;
    sortedTypeFlag = 0;
    sortedByName = [[NSMutableArray alloc] init];
    sortedByType = [[NSMutableArray alloc] init];
    sortedByDate = [[NSMutableArray alloc] init];
    sortedKeys = [[NSMutableArray alloc] init];
    
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
    
    [super viewDidLoad];
}

/* Release any retained subviews of the main view. e.g. self.myOutlet = nil; */

- (void)viewDidUnload {
    
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
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *session = [VaultUser loadSession];
    /* Sync documents if user just logged into Vault */
    if (initLogin == TRUE) {
        initLogin = FALSE;  /* Reset sync global */
        
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
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   
    /* Return YES for supported orientations */
    return YES;                                                                 
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [mainView setNeedsDisplay];
    
    /* Going to Landscape Orientation */
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight
        || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        /* Reset locations of all sorting buttons */
        nameButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE + 2, 44, DOCNAME_WIDTHLANDSCAPE - 3, 36);
        typeButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE + DOCNAME_WIDTHLANDSCAPE + 2, 44, DOCTYPE_WIDTHLANDSCAPE - 3, 36);
        dateButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTHLANDSCAPE + DOCNAME_WIDTHLANDSCAPE + DOCTYPE_WIDTHLANDSCAPE + 2, 44, DOCLASTMODIFIED_WIDTHLANDSCAPE - 3, 36);
        
        [self.documents reloadData];
        
    }
    
    else {  /* Going back to Portrait Orientation */
        
        /* Reset locations of all sorting buttons */
        nameButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTH + 2, 44, DOCNAME_WIDTH - 3, 36);
        typeButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTH + DOCNAME_WIDTH + 2, 44, DOCTYPE_WIDTH - 3, 36);
        dateButton.frame = CGRectMake(DOCTYPEIMAGE_WIDTH + DOCNAME_WIDTH + DOCTYPE_WIDTH + 2, 44, DOCLASTMODIFIED_WIDTH - 3, 36);
        
        [self.documents reloadData];
        
    }
}

/* Customize the number of sections in the Table View */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

/* Customize the number of visible cells depending on the orientation */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([documentNames count] > 24)
        return [documentNames count];
    else
        return PORTRAIT_COUNT;
}

/* Set the cells up to have alternating background colors */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row % 2 == 0) {
        UIColor *altCellColor = [UIColor colorWithRed:237/256.0 green:243/256.0 blue:254/256.0 alpha:1.0];
        cell.backgroundColor = altCellColor;
    }
    else { 
        UIColor *altCellColor2 = [UIColor whiteColor];
        cell.backgroundColor = altCellColor2;
    }
}

/* Since the dictionaries start at 1, we want to hide the cell at row 0 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* Hide first cell */
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
    
    /* If there are files to load into table view */
    if ([fileFormats count] != 0 || fileFormats != nil) {
        
        if (searchFilterIdentifier == true) {
            if ((indexPath.row - 1 >= 0) &&
                (indexPath.row - 1 < [searchResults count])) {
                
                NSLog(@"Got in searchResults with indexPath %@\n",indexPath);
                docId = [searchResults objectAtIndex:indexPath.row -1];
            } else {
                NSLog(@"Got in the search else with indexPath %@\n",indexPath);
                docId = @"";
            }
        }
        
        else {
    
            /* Filter is set to My documents */
             if ([filterIdentifier isEqualToString:MY_DOCUMENTS] 
                     && (indexPath.row - 1 >= 0 
                     && indexPath.row - 1 < [myDocumentDocsIds count])) 
                docId = [myDocumentDocsIds objectAtIndex:indexPath.row - 1];
            
            /* Filter is set to Favorites */
            else if ([filterIdentifier isEqualToString:FAVORITES] 
                     && (indexPath.row - 1 >= 0 
                     && indexPath.row - 1 < [favoriteDocsIds count])) 
                docId = [favoriteDocsIds objectAtIndex:indexPath.row - 1];
                
            /* Filter is set to Recents */
            else if ([filterIdentifier isEqualToString:RECENTS] 
                     && (indexPath.row - 1 >= 0 
                         && indexPath.row - 1 < [recentDocsIds count])) 
                docId = [recentDocsIds objectAtIndex:indexPath.row - 1];
                    
            /* Filter is set to all documents */
            else if ([filterIdentifier isEqualToString:DOCUMENT_INFO] 
                     && indexPath.row - 1 >= 0 
                     && indexPath.row - 1 < [allDocIds count]) {
                docId = [allDocIds objectAtIndex:indexPath.row - 1];
                
            }
            /* There are no more documents to show */
            else
                docId = @"";
        }
        
        fileType = [fileFormats objectForKey:docId]; /* Get the format of the file */
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
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        if (fileType != nil) {                  /* Ensure there is a filepath */
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
        else
            cell.docTypeImage.image = nil;  /* Do not show an image */
        
        cell.docName.text = [documentNames objectForKey:docId];
        cell.docType.text = [documentTypes objectForKey:docId];
        cell.docLastModified.text = [Document 
                timeSinceModified:[datesModified objectForKey:docId]];
    }
    
    /* No files to load */
    else {
        cell.docName.text = @"";
        cell.docType.text = @"";
        cell.docLastModified.text = @"";
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
        NSString *docNameText = cell.docName.text;
        NSString *pdfFilePath = [Document loadPDF:docNameText];
        
      
        ReaderDocument *doc = [ReaderDocument withDocumentFilePath:pdfFilePath password:nil];
        
        if (doc != nil) {
           
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:doc];
            
            readerViewController.delegate = self; // Set the ReaderViewController delegate to self
            
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentModalViewController:readerViewController animated:YES];
        }
        
        
    }
    
}


/* Called when a request fails to be sent to the server and cannot retireve a response */

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    NSLog(@"Response is %@ ", [response bodyAsString]);
}

/* Called when objects are loaded from the server response */

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    Document *document = nil;
    objResponseCount++;
    
    if ([objectLoader.resourcePath isEqualToString:AUTH_TEST] || objectLoader.isPOST) {
        objResponseCount = 0;
        SessionTest *test = [objects objectAtIndex:0];                  /* Load the test object */
        
        if ([test.responseStatus isEqualToString:FAILURE] && loginCycle == 0){ /* If the test failed */
            
            invalidSession = YES;
            loginCycle++;
            [self loginWithKeychain];
        }
        
        else if ([test.responseStatus isEqualToString:FAILURE] 
                 && invalidSession == YES 
                 && loginCycle == 1) {
            
            loginCycle++;
            
            /* Create the alert */
            UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"You username and/or password has changed! Please enter you new credentials" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [loginAlert show]; 
        }
    
        else if (invalidSession == YES && (loginCycle == 1 || loginCycle == 2)) {
            loginCycle = 0;
            invalidSession = NO;
            VaultUser *user = [objects objectAtIndex:0];
            
            if (![user.sessionid isEqualToString:[VaultUser loadSession]])
                [VaultUser saveSession:user.sessionid];
            
            [self refreshDocuments];
        }
        
        else {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }
    
    /* The returned mapped objects are user documents */
    else if ([objectLoader.resourcePath isEqualToString:MY_DOCUMENTS]) {
       
        for (int i = 0; i < [objects count]; i++) {
            document = [objects objectAtIndex:i];
          
            if ([documentNames objectForKey:document.documentId] == nil) {
                
                if ([myDocumentDocsIds count] > i)
                    [myDocumentDocsIds replaceObjectAtIndex:i withObject:document.documentId];  
                else
                    [myDocumentDocsIds insertObject:document.documentId atIndex:i];
                
                [changedDocs addObject:document.documentId];
                [documentTypes setObject:document.type forKey:document.documentId];         /* Store document type */
                [documentNames setObject:document.name forKey:document.documentId];         /* Store document name */
                [fileFormats setObject:document.format forKey:document.documentId];         /* Store the content file name */
                [rawDates setObject:document.dateLastModified forKey:document.documentId];
                [datesModified setObject: [Document                                         /* Store date last modified on document */
                                convertStringToDate:document.dateLastModified]             
                                forKey:document.documentId];   
            }
            
            else {
                
                if ([myDocumentDocsIds count] > i)
                    [myDocumentDocsIds replaceObjectAtIndex:i withObject:document.documentId];  
                else
                    [myDocumentDocsIds insertObject:document.documentId atIndex:i];
                
                if (![document.type isEqualToString:[documentTypes objectForKey:document.documentId]]) 
                    [documentTypes setObject:document.type forKey:document.documentId];
                
                if(![document.name isEqualToString:[documentNames objectForKey:document.documentId]])
                    [documentNames setObject:document.name forKey:document.documentId];
               
                if(![document.format isEqualToString:[fileFormats objectForKey:document.documentId]])
                    [fileFormats setObject:document.format forKey:document.format];
                
                if(![document.dateLastModified isEqualToString:[rawDates objectForKey:document.documentId]]) {
                    [rawDates setObject:document.dateLastModified forKey:document.documentId];
                    [changedDocs addObject:document.documentId];
                    [datesModified setObject: [Document                                         /* Store date last modified on document */
                                    convertStringToDate:document.dateLastModified]             
                                    forKey:document.documentId];  
                }
                
                    
                
            }
        }
        [Document saveFilters:myDocumentDocsIds forKey:MY_DOCUMENTS];
    }
    
    /* The returned mapped objects are favorite documents */
    else if ([objectLoader.resourcePath isEqualToString:FAVORITES]) {
    
        for (int i = 0; i < [objects count]; i++) {
            document = [objects objectAtIndex:i];
            
            if ([documentNames objectForKey:document.documentId] == nil) {
            
                if ([favoriteDocsIds count] > i)
                    [favoriteDocsIds replaceObjectAtIndex:i withObject:document.documentId];
                   
                else
                    [favoriteDocsIds insertObject:document.documentId atIndex:i];
                
            [changedDocs addObject:document.documentId];
            [documentTypes setObject:document.type forKey:document.documentId];         /* Store document type */
            [documentNames setObject:document.name forKey:document.documentId];         /* Store document name */
            [fileFormats setObject:document.format forKey:document.documentId];         /* Store the content file name */
            [rawDates setObject:document.dateLastModified forKey:document.documentId];
            [datesModified setObject: [Document                                         /* Store date last modified on document */
                                convertStringToDate:document.dateLastModified]             
                                forKey:document.documentId];   
            }
            
            else {
                
                if ([favoriteDocsIds count] > i)
                    [favoriteDocsIds replaceObjectAtIndex:i withObject:document.documentId];
                
                else
                    [favoriteDocsIds insertObject:document.documentId atIndex:i];
                
                if (![document.type isEqualToString:[documentTypes objectForKey:document.documentId]]) 
                    [documentTypes setObject:document.type forKey:document.documentId];
                
                if(![document.name isEqualToString:[documentNames objectForKey:document.documentId]])
                    [documentNames setObject:document.name forKey:document.documentId];
                
                if(![document.format isEqualToString:[fileFormats objectForKey:document.documentId]])
                    [fileFormats setObject:document.format forKey:document.format];
                
                if(![document.dateLastModified isEqualToString:[rawDates objectForKey:document.documentId]]) {
                    [rawDates setObject:document.dateLastModified forKey:document.documentId];
                    [changedDocs addObject:document.documentId];
                    [datesModified setObject: [Document                                         /* Store date last modified on document */
                                               convertStringToDate:document.dateLastModified]             
                                      forKey:document.documentId];  
                }

            }
                
        }
        
        [Document saveFilters:favoriteDocsIds forKey:FAVORITES];
    }
    
    /* The returned mapped documents are recent documents */
    else if ([objectLoader.resourcePath isEqualToString:RECENTS]) {
        
        
        for (int i = 0; i < [objects count]; i++) {
            document = [objects objectAtIndex:i];
          
            if ([documentNames objectForKey:document.documentId] == nil) {
            
                if ([recentDocsIds count] > i)
                    [recentDocsIds replaceObjectAtIndex:i withObject:document.documentId];            
                else
                    [recentDocsIds insertObject:document.documentId atIndex:i];
                
                [changedDocs addObject:document.documentId];
                [documentTypes setObject:document.type forKey:document.documentId];         /* Store document type */
                [documentNames setObject:document.name forKey:document.documentId];         /* Store document name */
                [fileFormats setObject:document.format forKey:document.documentId];         /* Store the content file name */
                [rawDates setObject:document.dateLastModified forKey:document.documentId];
                [datesModified setObject: [Document                                         /* Store date last modified on document */
                            convertStringToDate:document.dateLastModified]             
                            forKey:document.documentId]; 
            }
            
            else {
                
                if ([recentDocsIds count] > i)
                    [recentDocsIds replaceObjectAtIndex:i withObject:document.documentId];            
                else
                    [recentDocsIds insertObject:document.documentId atIndex:i];
                
                if (![document.type isEqualToString:[documentTypes objectForKey:document.documentId]]) 
                    [documentTypes setObject:document.type forKey:document.documentId];
                
                if(![document.name isEqualToString:[documentNames objectForKey:document.documentId]])
                    [documentNames setObject:document.name forKey:document.documentId];
                
                if(![document.format isEqualToString:[fileFormats objectForKey:document.documentId]])
                    [fileFormats setObject:document.format forKey:document.format];
                
                if(![document.dateLastModified isEqualToString:[rawDates objectForKey:document.documentId]]) {
                    [rawDates setObject:document.dateLastModified forKey:document.documentId];
                    [changedDocs addObject:document.documentId];
                    [datesModified setObject: [Document                                         /* Store date last modified on document */
                                               convertStringToDate:document.dateLastModified]             
                                      forKey:document.documentId];  
                }

                
            }
        }
        
        [Document saveFilters:recentDocsIds forKey:RECENTS];
    }
    
    /* Every object has been retrieved */
    if (objResponseCount == LAST_DOC_OBJ_REQ && ![objectLoader.resourcePath isEqualToString:AUTH_TEST]) {
        objResponseCount = 0;
        
        [allDocIds removeAllObjects];
        for (NSString *dId in documentNames) 
            [allDocIds addObject:dId];
        
        /* Save the newly populated dictionaries NSUserDefaults */
        [Document saveDocInfo:documentTypes forKey:DOC_TYPES];
        [Document saveDocInfo:documentNames forKey:DOC_NAMES];
        [Document saveDocInfo:fileFormats forKey:FILE_FORMAT];
        [Document saveDocInfo:rawDates forKey:RAW_DATES];
        [Document saveDocInfo:datesModified forKey:DATE_MOD];
        
        [Document saveFilters:allDocIds forKey:ALL_DOC_IDS];
        
        numOfDocuments = [allDocIds count];
        
        currentDoc = 0;
        [self sendPdfRequest];    
    }
}

/* Function that resets the data before PDF data is recieved request. */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [pdfData setLength:0];
}

/* Retrieves all binary data from the pdf retrieved from Vault server. */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [pdfData appendData:data];                                                          /* Append all data for each request */
}

/* 
 * After the connection is completed with response, save the pdf file to the iPad 
 * and prepare to recieve the next pdf binary data. 
 */
 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    /* Convert current document Id to a string to use for retrieving the name of the file */
    NSString *pdfName = [documentNames                                                  /* Retrieve documents file name */
            objectForKey:[changedDocs objectAtIndex:currentDoc]];   
    NSString *docPath = [Document savePDF:pdfData withFileName:pdfName];                /* Document path */
    
    [documentPaths setObject:docPath forKey:[changedDocs objectAtIndex:currentDoc]];                               /* Save the file path */
    
    currentDoc++;                                                                     /* Increment document count */
    if (currentDoc < [changedDocs count]) {
        [self sendPdfRequest];
    }
    
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [changedDocs removeAllObjects];
        [Document saveDocInfo:documentPaths forKey:DOC_PATHS];                          /* Save paths to NSUserDefaults */
        [self.documents reloadData];
    }
}

-(void)searchDocuments:(NSMutableArray *)filterType withSearchText:(NSString *)searchText{
    
    NSString *document_name = nil;  /* NSString containing the name of the current document from documentNames */
    NSRange textRange;              /* NSRange to test if searchText is a substring of a document_name */
    
    for (NSString *key in filterType) {
        document_name = [documentNames objectForKey:key];
        textRange = [[document_name lowercaseString] rangeOfString:[searchText lowercaseString]];
        
        if (textRange.location != NSNotFound) {
            [self.searchResults addObject:key];
        }
    }
}

/* This will be called every time the text in the search bar is manipulated */

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    /* The text in the search bar has been manipulated. The old search results are no longer relevant
     *so searchResults needs to be emptied 
     */
    [searchResults removeAllObjects];
    
    searchFilterIdentifier = true;
    
    NSString *document_name = nil;  /* NSString containing the name of the current document from documentNames */
    NSRange textRange;              /* NSRange to test if searchText is a substring of a document_name */
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
        /* Search through the correct dictionary based on the sorted order */
        for (NSString *key in sortedKeys) {
            
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
    /*
     * If filterIdentifier is set to My Documents, iterate through myDocumentDocsIds to find substrings
     */
    else if ([filterIdentifier isEqualToString:MY_DOCUMENTS]) {
        [self searchDocuments:myDocumentDocsIds withSearchText:searchText];
    }
    
    /*
     * If filter is set to Favorites, iterate through favoriteDocsIds to find substrings
     */
    else if ([filterIdentifier isEqualToString:FAVORITES]) {
        [self searchDocuments:favoriteDocsIds withSearchText:searchText];
    }
    
    /* Filter is set to Recents */
    else if ([filterIdentifier isEqualToString:RECENTS]) {
        [self searchDocuments:recentDocsIds withSearchText:searchText];
    }
    else{
        /* For each loop that iterates through each index of documentNames and checks for the substring searchText */
        for (NSString *key in documentNames) {
            document_name = [documentNames objectForKey:key];
            textRange = [[document_name lowercaseString] rangeOfString:[searchText lowercaseString]];
            
            if (textRange.location != NSNotFound) {
                [self.searchResults addObject:key];
            }
            
        }
    }
    if ([searchText isEqualToString:@""]) {
        searchFilterIdentifier = false;
    }
    [self.documents reloadData];
}

- (void) sendPdfRequest {
    
    if ([changedDocs count] != 0) {
        NSString *fileResourcePath = BASE_URL;                /* Resource path for rest call to document */
        
        NSMutableURLRequest *pdfRequest = [[NSMutableURLRequest alloc] init];
        NSURLConnection *pdfConnect = [NSURLConnection alloc];
        
        /* Set up the resource path to grab the pdf from */
        fileResourcePath = [fileResourcePath stringByAppendingString:DOCUMENT_INFO];
        fileResourcePath = [fileResourcePath stringByAppendingString:[changedDocs objectAtIndex:currentDoc]];
        fileResourcePath = [fileResourcePath stringByAppendingString:RENDITIONS];

        /* Set up a request to be sent for the binary PDF file */
        pdfRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fileResourcePath]];
        [pdfRequest setValue:[VaultUser loadSession] forHTTPHeaderField:@"Authorization"];
        [pdfRequest setHTTPMethod:@"GET"];
        pdfConnect = [NSURLConnection connectionWithRequest:pdfRequest delegate:self];  /* Send request */
    }
    
    else 
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

-(void) resetSorting {
    [sortedFlags setObject:@"0" forKey:@"documentTypes"];
    [sortedFlags setObject:@"0" forKey:@"datesModified"];
    [sortedFlags setObject:@"0" forKey:@"documentNames"];
    sortedDateFlag = 0;
    sortedNameFlag = 0;
    sortedTypeFlag = 0;
}

- (IBAction)filterPressed:(id)sender {
    
    if (filters.selectedSegmentIndex == MY_DOCS_FILTER) 
        filterIdentifier = MY_DOCUMENTS;
      
    else if (filters.selectedSegmentIndex == FAV_FILTER) 
        filterIdentifier = FAVORITES;
    
    else if (filters.selectedSegmentIndex == RECENT_FILTER) 
        filterIdentifier = RECENTS;
    
    else if (filters.selectedSegmentIndex == ALL_DOCS_FILTER) 
        filterIdentifier = DOCUMENT_INFO;
        
    [self resetSorting];
    [self.documents reloadData];
}

-(NSMutableArray *)removeDuplicates:(NSMutableArray *)sortedArray{
    NSMutableSet* valuesAdded = [NSMutableSet set];
    NSMutableArray* filteredArray = [[NSMutableArray alloc] init];
    NSString* object;
    
    for (object in sortedArray){
        if (![valuesAdded member:object]){
            [valuesAdded addObject:object];
            [filteredArray addObject:object];
        }
    }
    return filteredArray;
}

- (IBAction)sortByName:(id)sender{
    
    dateButton.imageView.image = nil;
    typeButton.imageView.image = nil;
    
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
    
    namePressCount++;
        
    [sortedFlags setObject:@"0" forKey:@"documentTypes"];
    [sortedFlags setObject:@"0" forKey:@"datesModified"];
    [sortedFlags setObject:@"1" forKey:@"documentNames"];
    /* Local variable to hold the sorted keys before they are added to sortedKeys */
    NSMutableArray *localSortedKeys = [[NSMutableArray alloc] init];
    NSString *object;
    NSString *objectToKey;
    NSString *key;
    NSArray *keyArray;
    /* We have clear the objects in sortedByName before we add more or else we would double up on files */
    [sortedByName removeAllObjects];
    
    if (sortedNameFlag == 0) {
        /* Filter is set to My documents */
        if ([filterIdentifier isEqualToString:MY_DOCUMENTS]){
            for (key in myDocumentDocsIds) {
                /* Get the document name as a NSString for every key stored in the filter dictionary */
                [sortedByName addObject:[documentNames objectForKey:key]];
            }
            /* Sort those names into alphabetical order */
            [sortedByName sortUsingSelector:@selector(caseInsensitiveCompare:)];
            
            for (object in sortedByName){
                /* Convert the strings back to their keys */
                keyArray = [documentNames allKeysForObject:object];
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }
        /* Filter is set to Favorites */
        else if ([filterIdentifier isEqualToString:FAVORITES]){
            for (key in favoriteDocsIds) {
                [sortedByName addObject:[documentNames objectForKey:key]];
            }
            [sortedByName sortUsingSelector:@selector(caseInsensitiveCompare:)];
            
            for (object in sortedByName){
                keyArray = [documentNames allKeysForObject:object];
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }        
        /* Filter is set to Recents */
        else if ([filterIdentifier isEqualToString:RECENTS]){
            for (key in recentDocsIds) {
                [sortedByName addObject:[documentNames objectForKey:key]];
            }
            [sortedByName sortUsingSelector:@selector(caseInsensitiveCompare:)];
            
            for (object in sortedByName){
                keyArray = [documentNames allKeysForObject:object];
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }
        /* Filter is set to all documents */
        else if ([filterIdentifier isEqualToString:DOCUMENT_INFO]){
            for (key in allDocIds) {
                [sortedByName addObject:[documentNames objectForKey:key]];
            }
            [sortedByName sortUsingSelector:@selector(caseInsensitiveCompare:)];
            
            for (object in sortedByName){
                keyArray = [documentNames allKeysForObject:object];
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }
        sortedKeys = localSortedKeys;
        [self.documents reloadData];
        sortedNameFlag = 1;
    }
    
    else if (sortedNameFlag == 1){
        sortedKeys = [[sortedKeys reverseObjectEnumerator] allObjects];
        [self.documents reloadData];
        sortedNameFlag = 0;
    }
}


- (IBAction)sortByDateModified:(id)sender{
    
    nameButton.imageView.image = nil;
    typeButton.imageView.image = nil;
    
    if (datePressCount % 2 == 0) {
        [dateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [dateButton setImageEdgeInsets:UIEdgeInsetsMake(0, 210, 2, 0)];
        [dateButton setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
    }
    else {
        [dateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [dateButton setImageEdgeInsets:UIEdgeInsetsMake(5, 210, 0, 0)];
        [dateButton setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
    }
    
    datePressCount++;
    
    [sortedFlags setObject:@"0" forKey:@"documentTypes"];
    [sortedFlags setObject:@"1" forKey:@"datesModified"];
    [sortedFlags setObject:@"0" forKey:@"documentNames"];
    /* Local variable to hold the sorted keys before they are added to sortedKeys */
    NSMutableArray *localSortedKeys = [[NSMutableArray alloc] init];
    NSString *object;
    NSString *objectToKey;
    NSString *key;
    NSArray *keyArray;
    /* We have clear the objects in sortedByName before we add more or else we would double up on files */
    [sortedByDate removeAllObjects];
    
    if (sortedDateFlag == 0) {
        /* Filter is set to My documents */
        if ([filterIdentifier isEqualToString:MY_DOCUMENTS]){
            for (key in myDocumentDocsIds) {
                /* Get the document name as a NSString for every key stored in the filter dictionary */
                [sortedByDate addObject:[datesModified objectForKey:key]];
            }
            /* Sort those names into alphabetical order */
            [sortedByDate sortUsingSelector:@selector(compare:)];
            
            for (object in sortedByDate){
                /* Convert the strings back to their keys */
                keyArray = [datesModified allKeysForObject:object];
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }
        /* Filter is set to Favorites */
        else if ([filterIdentifier isEqualToString:FAVORITES]){
            for (key in favoriteDocsIds) {
                [sortedByDate addObject:[datesModified objectForKey:key]];
            }
            [sortedByDate sortUsingSelector:@selector(compare:)];
            
            for (object in sortedByDate){
                keyArray = [datesModified allKeysForObject:object];
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }        
        /* Filter is set to Recents */
        else if ([filterIdentifier isEqualToString:RECENTS]){
            for (key in recentDocsIds) {
                [sortedByDate addObject:[datesModified objectForKey:key]];
            }
            [sortedByDate sortUsingSelector:@selector(compare:)];
            
            for (object in sortedByDate){
                keyArray = [datesModified allKeysForObject:object];
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }
        /* Filter is set to all documents */
        else if ([filterIdentifier isEqualToString:DOCUMENT_INFO]){
            for (key in allDocIds) {
                [sortedByDate addObject:[datesModified objectForKey:key]];
            }
            [sortedByDate sortUsingSelector:@selector(compare:)];
            
            for (object in sortedByDate){
                keyArray = [datesModified allKeysForObject:object];
                objectToKey = [keyArray objectAtIndex:0];
                [localSortedKeys addObject:objectToKey];
            }
        }
        sortedKeys = localSortedKeys;
        [self.documents reloadData];
        sortedDateFlag= 1;
    }
    
    else if (sortedDateFlag == 1){
        sortedKeys = [[sortedKeys reverseObjectEnumerator] allObjects];
        [self.documents reloadData];
        sortedDateFlag = 0;
    }
}

- (IBAction)sortbyType:(id)sender {
    
    nameButton.imageView.image = nil;
    typeButton.imageView.image = nil;
    
    if (typePressCount % 2 == 0) {
        [typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [typeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 150, 1, 0)];
        [typeButton setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
    }
    else {
        [typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [typeButton setImageEdgeInsets:UIEdgeInsetsMake(5, 150, 0, 0)];
        [typeButton setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
    }
    
    typePressCount++;
    
    [sortedFlags setObject:@"1" forKey:@"documentTypes"];
    [sortedFlags setObject:@"0" forKey:@"datesModified"];
    [sortedFlags setObject:@"0" forKey:@"documentNames"];
    /* Local variable to hold the sorted keys before they are added to sortedKeys */
    NSMutableArray *localSortedKeys = [[NSMutableArray alloc] init];
    NSString *object;
    NSString *objectToKey;
    NSString *key;
    NSArray *keyArray;
    /* We have clear the objects in sortedByName before we add more or else we would double up on files */
    [sortedByType removeAllObjects];
    
    if (sortedTypeFlag == 0) {
        /* Filter is set to My documents */
        if ([filterIdentifier isEqualToString:MY_DOCUMENTS]){
            for (key in myDocumentDocsIds) {
                /* Get the document name as a NSString for every key stored in the filter dictionary */
                [sortedByType addObject:[documentTypes objectForKey:key]];
            }
            /* Sort those names into alphabetical order */
            [sortedByType sortUsingSelector:@selector(caseInsensitiveCompare:)];
            
            sortedByType = [self removeDuplicates:sortedByType];
            for (object in sortedByType){
                keyArray = [documentTypes allKeysForObject:object];
                for (int i=0; i<[keyArray count]; i++){
                    objectToKey = [keyArray objectAtIndex:i];
                    [localSortedKeys addObject:objectToKey];
                }
            }
        }
        /* Filter is set to Favorites */
        else if ([filterIdentifier isEqualToString:FAVORITES]){
            for (key in favoriteDocsIds) {
                [sortedByType addObject:[documentTypes objectForKey:key]];
            }
            [sortedByType sortUsingSelector:@selector(caseInsensitiveCompare:)];
            
            sortedByType = [self removeDuplicates:sortedByType];
            for (object in sortedByType){
                keyArray = [documentTypes allKeysForObject:object];
                for (int i=0; i<[keyArray count]; i++){
                    objectToKey = [keyArray objectAtIndex:i];
                    [localSortedKeys addObject:objectToKey];
                }
            }
        }        
        /* Filter is set to Recents */
        else if ([filterIdentifier isEqualToString:RECENTS]){
            for (key in recentDocsIds) {
                [sortedByType addObject:[documentTypes objectForKey:key]];
            }
            [sortedByType sortUsingSelector:@selector(caseInsensitiveCompare:)];
            
            sortedByType = [self removeDuplicates:sortedByType];
            for (object in sortedByType){
                keyArray = [documentTypes allKeysForObject:object];
                for (int i=0; i<[keyArray count]; i++){
                    objectToKey = [keyArray objectAtIndex:i];
                    [localSortedKeys addObject:objectToKey];
                }
            }
        }
        /* Filter is set to all documents */
        else if ([filterIdentifier isEqualToString:DOCUMENT_INFO]){
            for (key in allDocIds) {
                [sortedByType addObject:[documentTypes objectForKey:key]];
            }
            [sortedByType sortUsingSelector:@selector(caseInsensitiveCompare:)];
            
            sortedByType = [self removeDuplicates:sortedByType];
            for (object in sortedByType){
                keyArray = [documentTypes allKeysForObject:object];
                for (int i=0; i<[keyArray count]; i++){
                    objectToKey = [keyArray objectAtIndex:i];
                    [localSortedKeys addObject:objectToKey];
                }
            }
        }
        sortedKeys = localSortedKeys;
        [self.documents reloadData];
        sortedTypeFlag = 1;
    }
    
    else if (sortedTypeFlag == 1){
        sortedKeys = [[sortedKeys reverseObjectEnumerator] allObjects];
        [self.documents reloadData];
        sortedTypeFlag = 0;
    }
}

- (void)loginWithKeychain {
    /* Created an instance of a user to send user credentials to vault */
    AuthUserDetail *userLogin = [[AuthUserDetail alloc] init];
  
    userLogin.username = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    userLogin.password = [keychain objectForKey:(__bridge id)kSecValueData];
    NSLog(@"uname is %@", userLogin.username);
    /* Send the POST request to vault */
    [authManager postObject:userLogin delegate:self];
    
}

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


#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
    
	[self dismissModalViewControllerAnimated:YES];

}


@end
