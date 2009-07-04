//
//  UKPaintbrushTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKPaintbrushTool.h"
#import "UKPaintView.h"


@implementation UKPaintbrushTool


/* Override this to draw a brush during tracking:
	The drawings you do in here will end up in the actual image buffer. */
-(void)			drawTrackingToolShapeFrom: (NSPoint*)lastPos to: (NSPoint)currPos
{
	// Draw a brush line using the owning paint view's line color:
	[[owner lineColor] set];
	[NSBezierPath setDefaultLineWidth: [owner lineSize].width];
	[NSBezierPath setDefaultLineJoinStyle: NSRoundLineJoinStyle];
	[NSBezierPath setDefaultLineCapStyle: NSRoundLineCapStyle];
	[NSBezierPath strokeLineFromPoint:*lastPos toPoint:currPos];
	
	[owner setNeedsDisplayInRect: [self rectWithLineSizeFrom: *lastPos to: currPos]];	// Cause redraw so user sees what we did.
	
	[NSBezierPath setDefaultLineJoinStyle: NSMiterLineJoinStyle];
	[NSBezierPath setDefaultLineCapStyle: NSSquareLineCapStyle];
	
	*lastPos = currPos;		// Make sure we continue drawing at end of this line segment.
}


// Return the name of an image to use as the icon for this tool in the tool palette.
-(NSString*)	toolIconName
{
	return @"UKPaintbrushTool";
}


-(BOOL)			isSaveableTool
{
	return NO;
}



@end
