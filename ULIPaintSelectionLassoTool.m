//
//  UKPaintLassoTool.m
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

#import "ULIPaintSelectionLassoTool.h"
#import "ULIPaintView.h"
#import "NSCursor+CrossHair.h"


@implementation ULIPaintSelectionLassoTool

-(void)			trackingWillStart
{
	dragNotCreate = [[owner selectionPath] containsPoint: [owner initialPos]];	// Are we moving a selection or creating a new one?
	
	// Remove old selection while user is drawing a new one with this tool:
	//	And don't show selection outline during drag for more exact positioning.
	[owner setDrawSelectionHighlight: NO];
	[owner setNeedsDisplay: YES];
	
	if( !dragNotCreate )
		[super trackingWillStart];
}

-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	if( dragNotCreate )
	{
		[owner moveSelectionByX: currPos.x -prevPos->x andY: currPos.y -prevPos->y];
		
		*prevPos = currPos;
	}
	else
		[super drawTemporaryTrackingToolShapeFrom: prevPos to: currPos];
}


-(void)			drawFinalToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	if( !dragNotCreate )
	{
		NSRect		box = [currentPath bounds];
		[currentPath closePath];
		
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
		
		if( box.size.width > 1 || box.size.height > 1 )
		{
			NSBezierPath*		localPath = [[currentPath copy] autorelease];
			NSAffineTransform*	transform = [NSAffineTransform transform];
			[transform translateXBy: -box.origin.x yBy: -box.origin.y];
			[localPath transformUsingAffineTransform: transform];
			
			[selection setSize: box.size];
			[selection lockFocus];
				// ... and copy the new one in:
				NSRect		boundsBox = box;
				boundsBox.origin = NSZeroPoint;
				[[NSGraphicsContext currentContext] setShouldAntialias: NO];
				[localPath setClip];	// But only the selected area!
				[[owner image] drawInRect: boundsBox fromRect: box operation: NSCompositeCopy fraction: 1.0];
			[selection unlockFocus];
			[owner setSelectionPath: currentPath];
			
			// Erase where new selection used to be:
			[[NSColor colorWithCalibratedWhite: 1.0 alpha: 0.0] set];
			[currentPath setLineWidth: 0];
			[[NSGraphicsContext currentContext] setShouldAntialias: NO];
			[[NSGraphicsContext currentContext] setCompositingOperation: NSCompositeCopy];
			[currentPath fill];	// But only the selected area!
		}
		else
		{
			[selection setSize: NSMakeSize(8,8)];	// Save us some memory.
			box.size = NSZeroSize;
			box.origin = [owner initialPos];
			[owner setSelectionFrame: box];
		}
	}
	
	[owner setDrawSelectionHighlight: YES];	// We turned it off, we turn it on again.
	[owner setNeedsDisplay: YES];
	[[owner window] invalidateCursorRectsForView: owner];
	
	*prevPos = currPos;
}


// Return the name of an image to use as the icon for this tool in the tool palette.
-(NSString*)	toolIconName
{
	return @"UKPaintLassoTool";
}


-(BOOL)			isSaveableTool
{
	return NO;
}

-(NSCursor*)		drawingCursor
{
	return [NSCursor crossHairCursor];
}


-(NSCursor*)		selectionCursor
{
	return [NSCursor arrowCursor];
}

@end
