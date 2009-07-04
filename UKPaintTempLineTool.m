//
//  UKPaintTempLineTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Sat Nov 01 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKPaintTempLineTool.h"
#import "UKPaintView.h"


@implementation UKPaintTempLineTool

/* Override this to draw a shape during tracking:
	The drawings you do in here will be undone before you're called again.
	This is also called when tracking has finished by drawFinalToolShapeFrom:to: by default. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	NSRect		box = [self rectFrom: [owner initialPos] to: currPos];
	NSRect		oldBox = [self rectWithLineSizeFrom: [owner initialPos] to: *prevPos];
	
	[[owner lineColor] set];
	[NSBezierPath setDefaultLineWidth: [owner lineSize].width];
	[NSBezierPath strokeLineFromPoint: [owner initialPos] toPoint: currPos];
	
	box = [self rectWithLineSizeFrom: [owner initialPos] to: currPos];
	
	[owner setNeedsDisplayInRect: oldBox];
	[owner setNeedsDisplayInRect: box];
	
	*prevPos = currPos;
}


-(NSString*)	toolIconName
{
	return @"UKPaintTempLineTool";
}


-(void)			drawDisposableToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	[self drawTemporaryTrackingToolShapeFrom: prevPos to: currPos];
}

-(void)			drawFinalToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	// The default calls drawTemporaryTrackingToolShapeFrom:to:, which we don't want here.
}


-(void)			trackingWillStart
{
	[owner setNeedsDisplay: YES];	// Make sure previous marker's area is redrawn.
}


-(void)			paintToolWillUnload: (id)sender
{
	[owner clearMarkersBuffer: nil];
}


@end
