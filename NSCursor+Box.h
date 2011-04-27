//
//  NSCursor+Box.h
//  UKPaintView
//
//  Created by Uli Kusterer on Mon Nov 03 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import <AppKit/AppKit.h>


@interface NSCursor (UKBox)

+(id)	boxCursor;
+(id)	boxCursorOfSize: (NSSize)size;
+(id)	boxCursorOfSize: (NSSize)size color: (NSColor*)lineColor;

@end
