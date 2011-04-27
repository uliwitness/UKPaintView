//
//  NSCursor+CrossHair.h
//  UKPaintView
//
//  Created by Uli Kusterer on Mon Nov 03 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import <AppKit/AppKit.h>


@interface NSCursor (UKCrossHair)

+(id)	crossHairCursor;
+(id)	crossHairCursorWithLineSize: (NSSize)size;
+(id)	crossHairCursorWithLineSize: (NSSize)size color: (NSColor*)lineColor;

@end
