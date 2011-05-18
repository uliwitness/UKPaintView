//
//  UKPaintTextTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Sat Nov 01 2003.
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

#import "ULIPaintTextTool.h"
#import "ULIPaintView.h"


@implementation ULIPaintTextTool

/* Draw a shape during tracking:
	The drawings you do in here will be undone before you're called again.
	This is also called when tracking has finished by drawFinalToolShapeFrom:to: by default. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	NSRect		box = [self rectFrom: [owner initialPos] to: currPos];
	NSRect		oldBox = [self rectWithLineSizeFrom: [owner initialPos] to: *prevPos];
	
	[self toolFinished];	// Remove and "burn in" any previous text boxes.
	
	// Draw an outline so user will know what size text box they'll get:
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
		textImgRep = [[[NSBitmapImageRep alloc] initWithFocusedViewRect: [textbox bounds]] autorelease];
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

@end
