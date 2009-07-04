//
//  UKPaintEraseRectTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Sat Nov 01 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKPaintEraseRectTool.h"
#import "UKPaintView.h"
#import "NSCursor+CrossHair.h"


@implementation UKPaintEraseRectTool

/* Override this to draw a shape during tracking:
	The drawings you do in here will be undone before you're called again.
	This is also called when tracking has finished by drawFinalToolShapeFrom:to: by default. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	NSRect		box = [self rectFrom: [owner initialPos] to: currPos];
	NSRect		oldBox = [self rectWithLineSizeFrom: [owner initialPos] to: *prevPos];
	
	[[NSColor blackColor] set];
	[NSBezierPath setDefaultLineWidth: 1];
	[[NSColor colorWithCalibratedRed: NSLightGray green: NSLightGray blue: 1.0 alpha: NSDarkGray] set];
	[NSBezierPath fillRect: box];
	[[NSColor blackColor] set];
	[NSBezierPath strokeRect: box];
	
	box = [self rectWithLineSizeFrom: [owner initialPos] to: currPos];
	
	[owner setNeedsDisplayInRect: oldBox];
	[owner setNeedsDisplayInRect: box];
	
	*prevPos = currPos;
}


-(void)			drawFinalToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	NSRect		box = [self rectFrom: [owner initialPos] to: currPos];
	NSRect		oldBox = [self rectWithLineSizeFrom: [owner initialPos] to: *prevPos];
	
	[[NSColor colorWithCalibratedWhite: 1.0 alpha: 0.0] set];
	[NSBezierPath setDefaultLineWidth: 1];
	NSRectFill(box);
	
	box = [self rectWithLineSizeFrom: [owner initialPos] to: currPos];
	
	[owner setNeedsDisplayInRect: oldBox];
	[owner setNeedsDisplayInRect: box];
	
	*prevPos = currPos;
}


-(NSCursor*)		drawingCursor
{
	return [NSCursor crossHairCursor];
}


-(NSString*)	toolIconName
{
	return @"UKPaintEraseRectTool";
}



@end
