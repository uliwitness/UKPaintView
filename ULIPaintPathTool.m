//
//  UKPaintPathTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
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

#import "ULIPaintPathTool.h"
#import "ULIPaintView.h"
#import "UKHelperMacros.h"


@implementation ULIPaintPathTool

-(void)	dealloc
{
	DESTROY_DEALLOC(currentPath);
	
	[super dealloc];
}


/* Draw a brush during tracking:
	The drawings you do in here will end up in the actual image buffer. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)lastPos to: (NSPoint)currPos
{
	[currentPath lineToPoint: currPos];
	
	[[NSColor blackColor] set];
	[currentPath stroke];
	
	[owner setNeedsDisplayInRect: NSInsetRect( [currentPath bounds], -2, -2 )];
	
	*lastPos = currPos;		// Make sure we continue drawing at end of this line segment.
}

-(void)			drawFinalToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	// Subclass and override this to add it to your list of paths.
}


-(void)	trackingWillStart
{
	[currentPath release];
	currentPath = [[NSBezierPath alloc] init];
	[currentPath setLineWidth: 0];
	
	[currentPath moveToPoint: [owner initialPos]];
}


// Return the name of an image to use as the icon for this tool in the tool palette.
-(NSString*)	toolIconName
{
	return @"UKPaintPathTool";
}


-(BOOL)			isSaveableTool
{
	return NO;
}


-(BOOL)			adjustCoordinates
{
	return NO;
}

@end
