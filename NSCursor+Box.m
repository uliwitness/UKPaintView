//
//  NSCursor+Box.m
//  UKPaintView
//
//  Created by Uli Kusterer on Mon Nov 03 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "NSCursor+Box.h"


@implementation NSCursor (UKBox)

+(id)	boxCursor
{
	return [self boxCursorOfSize: NSMakeSize(1,1)];
}


+(id)	boxCursorOfSize: (NSSize)size
{
	return [self boxCursorOfSize: size color: [NSColor blackColor]];
}


+(id)	boxCursorOfSize: (NSSize)size color: (NSColor*)lineColor
{
	NSImage*	cursorImage = [[[NSImage alloc] initWithSize: NSMakeSize(16,16)] autorelease];
	NSRect		box;
	
	if( size.width < 1 ) size.width = 1;
	if( size.height < 1 ) size.height = 1;
	box.size.width = ( size.width > 16 ) ? 16 : size.width;
	box.size.height = ( size.height > 16 ) ? 16 : size.height;
	box.origin = NSMakePoint( truncf(box.size.width /2), truncf(box.size.height /2) );
	//box.origin.x += 0.5; box.origin.y += 0.5;
	
	[cursorImage lockFocus];
		[lineColor set];
		[NSBezierPath setDefaultLineWidth: 1];
		[NSBezierPath strokeRect: box];
	[cursorImage unlockFocus];
	
	return [[[NSCursor alloc] initWithImage: cursorImage hotSpot: NSMakePoint(8,8)] autorelease];
}

@end
