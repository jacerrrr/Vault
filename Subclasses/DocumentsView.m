/* 
 * DocumentsView.m
 * Vault
 *
 * Created by Jace Allison on March 11, 2012
 * Last modified on May 24, 2012 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 *
 * This file contains a function to draw on a specified view.  In this case, the view is the view
 * in the FirstViewController which displays the documents
 */

#import "DocumentsView.h"

@implementation DocumentsView

/* Function that draws lines to the main view of FirstViewController. These lines connect to the lines
 * drawn on the table view which displays the documents.
 *
 * PARAMETER(S)
 *
 *  (CGRect)rect                CGRect that is being drawn on in the view
 */

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context    = UIGraphicsGetCurrentContext();
    
    /* Set black line to be drawn */
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0);
    
    if ([[UIApplication sharedApplication] statusBarOrientation ] 
        == UIInterfaceOrientationPortrait 
        || [[UIApplication sharedApplication] statusBarOrientation] 
        == UIInterfaceOrientationPortraitUpsideDown) {
    
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTH + 0.5 , 44);               /* Start at this point */
        
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTH + 0.5, 81);             /* Draw to this point */
        
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTH                            /* Start at this point */
                             + DOCNAME_WIDTH + 0.5 , 45);
        
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTH                         /* Draw to this point */
                                + DOCNAME_WIDTH + 0.5, 81);
        
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTH                            /* Start at this point */
                             + DOCNAME_WIDTH + DOCTYPE_WIDTH + 0.5 , 45);           
        
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTH                         /* Draw to this point */
                                + DOCNAME_WIDTH + DOCTYPE_WIDTH + 0.5, 81);
    }
    
    else {
        
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE + 0.5 , 44);      /* Start at this point */
        
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE + 0.5, 81);    /* Draw to this point */
        
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE                   /* Start at this point */
                             + DOCNAME_WIDTHLANDSCAPE + 0.5 , 45);
        
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE                /* Draw to this point */
                                + DOCNAME_WIDTHLANDSCAPE + 0.5, 81);
        
        CGContextMoveToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE                   /* Start at this point */
                             + DOCNAME_WIDTHLANDSCAPE + DOCTYPE_WIDTHLANDSCAPE 
                             + 0.5 , 45);   
        
        CGContextAddLineToPoint(context, DOCTYPEIMAGE_WIDTHLANDSCAPE                         /* Draw to this point */
                                + DOCNAME_WIDTHLANDSCAPE + DOCTYPE_WIDTHLANDSCAPE 
                                + 0.5, 81);
    }
 
    // and now draw the Path!
    CGContextStrokePath(context);
}


@end
