//
//  DocumentsData.m
//  Vault
//
//  Created by Jace Allison on 5/1/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "DocumentsData.h"

@implementation DocumentsData

@synthesize docTypes;      /* Dictionary with all the document types for id */
@synthesize loadingTypes;

@synthesize docNames;      /* Dictionary with all the document names for id */
@synthesize loadingNames;

@synthesize rawDates;           /* Dictionary with all actualy document dates */
@synthesize loadingDates;

@synthesize lastMod;      /* Dates with all the last modified times for id */
@synthesize loadingMod;

@synthesize docFormats;        /* Dictionary with all the file formats for id */
@synthesize loadingFormats;

@synthesize docPaths;      /* Dictionary will all the document paths for each file */
@synthesize loadingPaths;

@synthesize recentIds;      /* Array containing id's for all recent documents */
@synthesize favoriteIds;    /* Array containing id's for all favorite documents */
@synthesize myDocIds;  /* Array containing id's for all "my documents" documents */
@synthesize allDocIds;          /* Array containing all id's in documentNames dictionary */

@synthesize changedDocs;

@synthesize pdfData;
@synthesize currentDocWithData;

@end
