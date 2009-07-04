//
//  UKPaintSelectTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Sat Nov 01 2003.
//  Copyright (c) 2007 M. Uli Kusterer. All rights reserved.
//

#import "UKPaintSelectTool.h"
#import "UKPaintView.h"
#import "NSCursor+CrossHair.h"


@implementation UKPaintSelectTool

-(void)			trackingWillStart
{
	dragNotCreate = NSPointInRect( [owner initialPos], [owner selectionFrame] );	// Are we moving a selection or creating a new one?
	
	// Remove old selection while user is drawing a new one with this tool:
	//	And don't show selection outline during drag for more exact positioning.
	[owner setDrawSelectionHighlight: NO];
	[owner setNeedsDisplay: YES];
}

/* Override this to draw a shape during tracking:
	The drawings you do in here will be undone before you're called again.
	This is also called when tracking has finished by drawFinalToolShapeFrom:to: by default. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	NSRect		box, oldBox;
		
	if( dragNotCreate )
	{
		oldBox = [owner selectionFrame];
		box = oldBox;
		
		box.origin.x += currPos.x -prevPos->x;
		box.origin.y += currPos.y -prevPos->y;
		
		[owner setSelectionFrame: box];
	}
	else
	{
		NSPoint		initialPos = [owner initialPos];
		box = [self rectFrom: initialPos to: currPos];
		oldBox = [self rectFrom: initialPos to: *prevPos];
		
		[owner drawSelectionHighlightAroundPath: [NSBezierPath bezierPathWithRect: box]];
	}
	
	[owner selectionHighlightNeedsDisplayForRect: oldBox];
	[owner selectionHighlightNeedsDisplayForRect: box];
	
	*prevPos = currPos;
}


-(void)			drawFinalToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	if( !dragNotCreate )
	{
		NSPoint		initialPos = [owner initialPos];
		NSRect		box = [self rectFrom: initialPos to: currPos];
		
		box.origin.x = truncf(box.origin.x);
		box.origin.y = truncf(box.origin.y);
		
		// Merge old selection into our image:
		NSRect		oldSelBounds = NSZeroRect, oldSelFrame;
		NSImage*	selection = [owner floatingSelectionImage];
		oldSelBounds.size = [selection size];
		oldSelFrame = [owner selectionFrame];
		
		[selection drawInRect: oldSelFrame fromRect: oldSelBounds operation: NSCompositeSourceOver fraction: 1.0];
		
		[selection lockFocus];
			// Clear old selection:
			[[NSColor colorWithCalibratedWhite: 1.0 alpha: 0.0] set];
			[NSBezierPath setDefaultLineWidth: 1];
			NSRectFill(oldSelBounds);
		[selection unlockFocus];
		
		if( initialPos.x != currPos.x || initialPos.y != currPos.y )
		{
			[selection setSize: box.size];
			[selection lockFocus];
				// ... and copy the new one in:
				NSRect		boundsBox = box;
				boundsBox.origin = NSZeroPoint;
				[[owner image] drawInRect: boundsBox fromRect: box operation: NSCompositeCopy fraction: 1.0];
			[selection unlockFocus];
			[owner setSelectionFrame: box];
			
			// Erase where new selection used to be:
			[[NSColor colorWithCalibratedWhite: 1.0 alpha: 0.0] set];
			[NSBezierPath setDefaultLineWidth: 1];
			NSRectFill(box);
		}
		else
		{
			[selection setSize: NSMakeSize(8,8)];	// Save us some memory.
			box.size = NSZeroSize;
			box.origin = initialPos;
			[owner setSelectionFrame: box];
		}
	}
	
	[owner setDrawSelectionHighlight: YES];	// We turned it off, we turn it on again.
	[owner setNeedsDisplay: YES];
	[[owner window] invalidateCursorRectsForView: owner];
	
	*prevPos = currPos;
}


-(NSCursor*)		drawingCursor
{
	return [NSCursor crossHairCursor];
}


-(NSCursor*)		selectionCursor
{
	return [NSCursor arrowCursor];
}


-(NSString*)	toolIconName
{
	return @"UKPaintSelectTool";
}



@end
