//
//  DocumentsData.h
//  Vault
//
//  Created by Jace Allison on 5/1/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "Document.h"

@interface DocumentsData : NSObject

/* Document property dictionaries */
@property (nonatomic, strong) NSMutableDictionary *docTypes;        /* Mutable Dictionary containing document types */
@property (nonatomic, strong) NSMutableDictionary *loadingTypes;

@property (nonatomic, strong) NSMutableDictionary *docNames;        /* Mutable Dictionary containing document names */
@property (nonatomic, strong) NSMutableDictionary *loadingNames;

@property (nonatomic, strong) NSMutableDictionary *rawDates;        /* Mutable Dictionary containing actual dates */
@property (nonatomic, strong) NSMutableDictionary *loadingDates;

@property (nonatomic, strong) NSMutableDictionary *lastMod;         /* Mutable Dictionary containing dates modified */
@property (nonatomic, strong) NSMutableDictionary *loadingMod;

@property (nonatomic, strong) NSMutableDictionary *docFormats;      /* Mutable Dictionary containing document format */
@property (nonatomic, strong) NSMutableDictionary *loadingFormats;

@property (nonatomic, strong) NSMutableDictionary *docPaths;        /* Mutable Dictionary containing document paths */
@property (nonatomic, strong) NSMutableDictionary *loadingPaths;

/* Filter Arrays */
@property (nonatomic, strong) NSMutableArray *recentIds;        /* Array for storing all document id's in the recent catagory */
@property (nonatomic, strong) NSMutableArray *favoriteIds;      /* Array for storing all document id's in the favorites catagory */
@property (nonatomic, strong) NSMutableArray *myDocIds;    /* Array for storing all ducment id's in the my documents catagory */
@property (nonatomic, strong) NSMutableArray *allDocIds;            /* All document id's that the user has pulled down */

@property (nonatomic, strong) NSMutableArray *changedDocs;

@property (nonatomic, strong) NSMutableData *pdfData;               /* Pdf data to be retrieved from Vault server */
@property (nonatomic) int currentDocWithData;

@end
