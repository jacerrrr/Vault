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

#define TEXT_FIELD_HEIGHT   31
#define CONNECT_ALERT_TAG   1
#define LOGIN_ALERT_TAG     2
#define CANCEL              0

/* Number of Cells displayed in Orientation */
#define PORTRAIT_COUNT 24
#define LANDSCAPE_COUNT 17

/* Size of Cells in Portrait */
#define DOCTYPEIMAGE_WIDTH 80
#define DOCNAME_WIDTH 300 
#define DOCTYPE_WIDTH 200
#define DOCLASTMODIFIED_WIDTH 200
#define CELLHEIGHT 50

/* Size of Cells in Landspace */
#define DOCTYPEIMAGE_WIDTHLANDSCAPE 130
#define DOCNAME_WIDTHLANDSCAPE 425 
#define DOCTYPE_WIDTHLANDSCAPE 250
#define DOCLASTMODIFIED_WIDTHLANDSCAPE 250

/* Set of defined constants */

/* Keys used for NSUserDefaults */
static NSString* const DOC_TYPES = @"doc_types";
static NSString* const DOC_NAMES = @"doc_names";
static NSString* const CONTENT_F = @"content_files";
static NSString* const DOC_PATHS = @"doc_paths";
static NSString* const DATE_MOD = @"date_mod";

/* NSString constants for determining request success or failure */
static NSString* const FAILURE = @"FAILURE";
static NSString* const SUCCESS = @"SUCCESS"; 

/* NSString constants for images */
static NSString* const PPT = @"ppt.png";
static NSString* const PDF = @"pdf.png";
static NSString* const DOC = @"doc.png";
static NSString* const XLS = @"xls.png";
static NSString* const UNKOWN = @"unknown.png";

/* NSString constants for paths to send request to server */
static NSString* const DOCUMENT_INFO = @"/objects/documents"; 
static NSString* const RENDITIONS = @"/renditions/viewable_rendition__v";
static NSString* const FAVORITES = @"/objects/documents?named_filter=Favorites";
static NSString* const RECENTS = @"/objects/documents?named_filter=Recent Documents";
static NSString* const MY_DOCUMENTS= @"/objects/documents?named_filter=My Documents";




#endif
