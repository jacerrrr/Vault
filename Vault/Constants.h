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

/* NSString constants for determining request success or failure */
static NSString * const FAILURE = @"FAILURE";
static NSString * const SUCCESS = @"SUCCESS";

/* NSString constants for paths to send request to server */
static NSString *const DOCUMENT_INFO = @"/objects/documents"; 





#endif
