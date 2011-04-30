//
//  UKPaintbrushTool.m
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

#import "ULIPaintFreehandTool.h"
#import "ULIPaintView.h"


@implementation ULIPaintFreehandTool


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
