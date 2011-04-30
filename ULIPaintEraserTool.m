//
//  UKPaintEraserTool.m
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

#import "ULIPaintEraserTool.h"
#import "ULIPaintView.h"
#import "NSCursor+Box.h"
#import "UlisBresenham.h"


@implementation ULIPaintEraserTool

void	UKPaintEraserBresenhamPixelProc( float x, float y, void* data )
{
	ULIPaintEraserTool*	tool = (ULIPaintEraserTool*) data;
	NSSize				lineSize = [[tool owner] lineSize];
	NSRect				box;
	
	box.origin.x = x -truncf(lineSize.width / 2);
	box.origin.y = y -truncf(lineSize.height / 2);
	box.size = lineSize;
	
	NSRectFill( box );
}


/* Draw a brush during tracking:
	The drawings you do in here will end up in the actual image buffer. */
-(void)			drawTrackingToolShapeFrom: (NSPoint*)lastPos to: (NSPoint)currPos
{
	// Draw a brush line using the owning paint view's line color:
	[NSBezierPath setDefaultLineWidth: 0];
	[[NSColor clearColor] set];
	DrawBresenhamLine( lastPos->x, lastPos->y, currPos.x, currPos.y,
							UKPaintEraserBresenhamPixelProc, self );
	
	[owner setNeedsDisplayInRect: [self rectWithLineSizeFrom: *lastPos to: currPos]];	// Cause redraw so user sees what we did.
	
	*lastPos = currPos;		// Make sure we continue drawing at end of this line segment.
}


// Return the name of an image to use as the icon for this tool in the tool palette.
-(NSString*)	toolIconName
{
	return @"UKPaintEraserTool";
}


-(NSCursor*)	drawingCursor
{
	return [NSCursor boxCursorOfSize: [owner lineSize]];
}


-(BOOL)			isSaveableTool
{
	return NO;
}

@end
