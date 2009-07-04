//
//  UKPaintPathTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKPaintPathTool.h"
#import "UKPaintView.h"


@implementation UKPaintPathTool

-(void)	dealloc
{
	[currentPath release];
	
	[super dealloc];
}


/* Override this to draw a brush during tracking:
	The drawings you do in here will end up in the actual image buffer. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)lastPos to: (NSPoint)currPos
{
	//[currentPath moveToPoint: *lastPos];
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
