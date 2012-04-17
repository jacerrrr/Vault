//
//  DocumentsView.m
//  Vault
//
//  Created by Jace Allison on 3/1/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import "DocumentsView.h"

@implementation DocumentsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
    }
    return self;
}

/* Function that draws lines to the main view of FirstViewController */

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
