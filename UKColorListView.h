//
//  UKColorListView.h
//  UKPaintView
//
//  Created by Uli Kusterer on Mon Nov 03 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import <AppKit/AppKit.h>


#define MIN_SWATCH_WIDTH			18
#define SWATCH_DISTANCE				4
#define SWATCH_BORDER				(SWATCH_DISTANCE /2)
#define SWATCH_WIDTH_HEIGHT_RATIO	0.75


@interface UKColorListView : NSView
{
	NSColorList*		colorList;
}

@end


@interface NSColorList (UKFindNameForColor)

-(NSString*)	nameForColor: (NSColor*) col;

@end