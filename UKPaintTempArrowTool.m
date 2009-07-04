//
//  UKPaintTempArrowTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Sat Nov 01 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKPaintTempArrowTool.h"
#import "UKPaintView.h"
#import "NSCursor+CrossHair.h"


@implementation UKPaintTempArrowTool

/* Override this to draw a shape during tracking:
	The drawings you do in here will be undone before you're called again.
	This is also called when tracking has finished by drawFinalToolShapeFrom:to: by default. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	NSImage*	theImg = [NSImage imageNamed: @"UKPaintTempArrowTool"];
	NSRect		box;
	NSRect		oldBox;
	
	// Calculate rect to draw new marker in:
	box.size = oldBox.size = [theImg size];
	
	box.origin = currPos;
	box.origin.x -= box.size.width;
	box.origin.y -= box.size.height;
	
	box.origin.x += 5;	// Nudge so we're on tip of arrow.
	box.origin.y += 5;	// Nudge so we're on tip of arrow.
	
	// Calculate rect old marker used to occupy:
	oldBox.origin = *prevPos;
	oldBox.origin.x -= oldBox.size.width;
	oldBox.origin.y -= oldBox.size.height;
	
	oldBox.origin.x += 5;	// Nudge so we're on tip of arrow.
	oldBox.origin.y += 5;	// Nudge so we're on tip of arrow.
	
	// Paint new marker into tracking buffer: (has been cleared by UKPaintView)
	[theImg dissolveToPoint: box.origin fraction: 1.0];
	
	// Cause redraw of changed areas:
	[owner setNeedsDisplayInRect: oldBox];
	[owner setNeedsDisplayInRect: box];
	
	// Keep around previous position so we can still refresh previous tool's position next time around:
	*prevPos = currPos;
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


-(NSCursor*)	drawingCursor
{
	return [NSCursor crossHairCursorWithLineSize: NSMakeSize(1,1) color: [NSColor grayColor]];
}


-(NSString*)	toolIconName
{
	return @"UKPaintTempArrowTool";
}



@end
