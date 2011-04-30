//
//  NSCursor+CrossHair.m
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

#import "NSCursor+CrossHair.h"


@implementation NSCursor (UKCrossHair)

+(id)	crossHairCursor
{
	return [self crossHairCursorWithLineSize: NSMakeSize(1,1)];
}


+(id)	crossHairCursorWithLineSize: (NSSize)size
{
	return [self crossHairCursorWithLineSize: size color: [NSColor blackColor]];
}


+(id)	crossHairCursorWithLineSize: (NSSize)size color: (NSColor*)lineColor
{
	float		desiredSize = ((size.width > size.height)? size.width : size.height) * 5;
	if( desiredSize < 16 ) desiredSize = 16;
	NSImage*	cursorImage = [[[NSImage alloc] initWithSize: NSMakeSize(desiredSize,desiredSize)] autorelease];
	NSPoint		left = { 0, 0.5 }, right = { 1, 0.5 },
				bottom = { 0.5, 0 }, top = { 0.5, 1 };
	
	left.x = truncf(left.x * desiredSize) + 0.5;
	left.y = truncf(left.y * desiredSize) + 0.5;
	right.x = truncf(right.x * desiredSize) + 0.5;
	right.y = truncf(right.y * desiredSize) + 0.5;
	bottom.x = truncf(bottom.x * desiredSize) + 0.5;
	bottom.y = truncf(bottom.y * desiredSize) + 0.5;
	top.x = truncf(top.x * desiredSize) + 0.5;
	top.y = truncf(top.y * desiredSize) + 0.5;
	
	if( size.width < 1 ) size.width = 1;
	if( size.height < 1 ) size.height = 1;
//	size.width = ( size.width >= 16 ) ? 15 : size.width;
//	size.height = ( size.height >= 16 ) ? 15 : size.height;
	
	[cursorImage lockFocus];
		[lineColor set];
		[NSBezierPath setDefaultLineWidth: size.height];
		[NSBezierPath strokeLineFromPoint: left toPoint: right];
		[NSBezierPath setDefaultLineWidth: size.width];
		[NSBezierPath strokeLineFromPoint: top toPoint: bottom];
	[cursorImage unlockFocus];
	
	return [[[NSCursor alloc] initWithImage: cursorImage hotSpot: NSMakePoint(bottom.x, left.y)] autorelease];
}

@end
