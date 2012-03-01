//
//  Header.h
//  Vault
//
//  Created by Jace Allison on 1/13/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#ifndef Vault_Header_h
#define Vault_Header_h

/* Set of all macros used */

#define TEXT_FIELD_HEIGHT   31          /* Standard text field height */
#define CONNECT_ALERT_TAG   1           /* Tag/identifier for connection alert */
#define LOGIN_ALERT_TAG     2           /* Tag/identifier for login alert */
#define CANCEL              0           /* Cancel button index of any alert view */

#define LAST_DOC_OBJ_REQ    3           /* Number of request sent for initial user documents */

/* Filter indexes */
#define MY_DOCS_FILTER      0           /* First segmented control button index in FirstViewController */
#define WIP_FILTER          1           /* Second segmented control button index in FirstViewController */
#define FAV_FILTER          2           /* Third segmented control button index in FirstViewController */
#define RECENT_FILTER       3           /* Fourth segmented control button index in FirstViewController */
#define ALL_DOCS_FILTER     4           /* Fifth segmented control button index in FirstViewController */


/* Number of Cells displayed in Orientation */
#define PORTRAIT_COUNT 24               /* Default value for displayed cells in Portrait Orientation */
#define LANDSCAPE_COUNT 17              /* Default value for displayed cells in Landscape Orientation */ 

/* Size of Cells in Portrait */
#define DOCTYPEIMAGE_WIDTH 60           /* Width of document image column in First View Controllers table view */
#define DOCNAME_WIDTH 300               /* Width of document name column in First View Controllers table view */
#define DOCTYPE_WIDTH 175               /* Width of document type column in First View Controllers table view */
#define DOCLASTMODIFIED_WIDTH 245       /* Width of document date column in First View Controllers table view */
#define CELLHEIGHT 44                   /* Standard cell height for each cell */

/* Size of Cells in Landspace */
#define DOCTYPEIMAGE_WIDTHLANDSCAPE 100     /* Width of document image column in First View Controllers table view */
#define DOCNAME_WIDTHLANDSCAPE 425          /* Width of document name column in First View Controllers table view */
#define DOCTYPE_WIDTHLANDSCAPE 220          /* Width of document type column in First View Controllers table view */
#define DOCLASTMODIFIED_WIDTHLANDSCAPE 310  /* Width of document date column in First View Controllers table view */

/* Set of defined constants */

/* Keys used for NSUserDefaults */
static NSString* const DOC_TYPES = @"doc_types";
static NSString* const DOC_NAMES = @"doc_names";
static NSString* const FILE_FORMAT = @"file_formats";
static NSString* const DOC_PATHS = @"doc_paths";
static NSString* const DATE_MOD = @"date_mod";
static NSString* const ALL_DOC_IDS = @"all document ids";

/* NSString constants for determining request success or failure */
static NSString* const FAILURE = @"FAILURE";
static NSString* const SUCCESS = @"SUCCESS"; 

/* NSString constants for images */
static NSString* const PPT_IMG = @"ppt.png";
static NSString* const PDF_IMG = @"pdf.png";
static NSString* const DOC_IMG = @"doc.png";
static NSString* const XLS_IMG = @"xls.png";
static NSString* const UNKOWN_IMG = @"unknown.png";
static NSString* const SORT_UP = @"sortUp.png";
static NSString* const SORT_DOWN = @"sortDown.png";

/* Base Url for all requests */
static NSString* const BASE_URL = @"https://vv1.veevavault.com/api/v1.0";

/* Login Url for login requests */
static NSString* const LOGIN_URL = @"https://login.veevavault.com";

/* NSString constants for paths to send request to server */
static NSString* const DOCUMENT_INFO = @"/objects/documents/"; 
static NSString* const RENDITIONS = @"/renditions/viewable_rendition__v";
static NSString* const FAVORITES = @"/objects/documents?named_filter=Favorites";
static NSString* const RECENTS = @"/objects/documents?named_filter=Recent Documents";
static NSString* const MY_DOCUMENTS = @"/objects/documents?named_filter=My Documents";
static NSString* const LOCAL_SEARCH = @"Local Search";

/* NSString constants for file formats */
static NSString* const PPT_FORMAT = @"vnd.ms-powerpoint";
static NSString* const MSWORD_FORMAT = @"msword";
static NSString* const PDF_FORMAT = @"pdf";
static NSString* const XLS_FORMAT = @"vnd.openxmlformats-officedocument.spreadsheetml.sheet";




#endif
