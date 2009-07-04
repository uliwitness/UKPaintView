//
//  UKPaintTextTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Sat Nov 01 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKPaintTextTool.h"
#import "UKPaintView.h"


@implementation UKPaintTextTool

/* Override this to draw a shape during tracking:
	The drawings you do in here will be undone before you're called again.
	This is also called when tracking has finished by drawFinalToolShapeFrom:to: by default. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	NSRect		box = [self rectFrom: [owner initialPos] to: currPos];
	NSRect		oldBox = [self rectWithLineSizeFrom: [owner initialPos] to: *prevPos];
	
	[self toolFinished];	// Remove and "burn in" any previous text boxes.
	
	[[NSColor blackColor] set];
	[NSBezierPath setDefaultLineWidth: 1.0];
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
	[owner setNeedsDisplayInRect: oldBox];
	
	// Create a text editing view:
	textbox = [[NSTextView alloc] initWithFrame:box];
	[textbox setDrawsBackground: NO];
	[textbox setTextColor: [owner lineColor]];
	[owner addSubview: textbox];
	[[textbox window] makeFirstResponder: textbox];
}


-(void)		toolFinished
{
	if( !textbox )
		return;
	
	// Make sure we don't get any selections or insertion marks in our drawing:
	[textbox setSelectable: NO];
	[textbox setEditable: NO];
	[textbox setSelectedRange: NSMakeRange(0,0)];
	[textbox display];
	
	// Paint text view's text into our image:
  #if 0
	NSImage*			finalImage;
	NSAffineTransform*	at;
	
	finalImage = [owner image];
	[finalImage lockFocus];
		at = [NSAffineTransform transform];
		[at translateXBy: [textbox frame].origin.x
					yBy: [textbox frame].origin.y];
		[at set];
		[textbox drawRect: [textbox bounds]];
	[finalImage unlockFocus];
  #else
	NSImage *			finalImage = nil;
	NSBitmapImageRep *	textImgRep = nil;
	NSPoint				drawPos = [textbox frame].origin;
	drawPos.x -= 0.5;
	drawPos.y += 0.5;
	
	[textbox lockFocus];
		textImgRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect: [textbox bounds]];
	[textbox unlockFocus];
	
	finalImage = [owner image];
	[finalImage lockFocus];
		[textImgRep drawAtPoint: drawPos];
	[finalImage unlockFocus];
  #endif

	// Remove text box:
	[textbox removeFromSuperview];
	[textbox release];
	textbox = nil;
}


-(void)			paintToolWillUnload: (id)sender
{
	[self toolFinished];
}

-(void)			paintToolDidLoad: (id)sender
{
	
}


-(NSString*)	toolIconName
{
	return @"UKPaintTextTool";
}


-(NSCursor*)		drawingCursor
{
	return [NSCursor IBeamCursor];
}


-(BOOL)			isSaveableTool
{
	return NO;
}




@end
