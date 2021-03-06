//
//  NSCursor+Box.m
//  UKPaintView
//
//  Created by Uli Kusterer on Mon Nov 03 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//
//	This software is provided 'as-is', without any express or implied
//	warranty. In no event will the authors be held liable for any damages
//	arising from the use of this software.
//
//	Permission is granted to anyone to use this software for any purpose,
//	including commercial applications, and to alter it and redistribute it
//	freely, subject to the following restrictions:
//
//	   1. The origin of this software must not be misrepresented; you must not
//	   claim that you wrote the original software. If you use this software
//	   in a product, an acknowledgment in the product documentation would be
//	   appreciated but is not required.
//
//	   2. Altered source versions must be plainly marked as such, and must not be
//	   misrepresented as being the original software.
//
//	   3. This notice may not be removed or altered from any source
//	   distribution.
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
