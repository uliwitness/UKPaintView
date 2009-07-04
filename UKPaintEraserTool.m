//
//  UKPaintEraserTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKPaintEraserTool.h"
#import "UKPaintView.h"
#import "NSCursor+Box.h"
#import "UlisBresenham.h"


@implementation UKPaintEraserTool


void	UKPaintEraserBresenhamPixelProc( float x, float y, void* data )
{
	UKPaintEraserTool*	tool = (UKPaintEraserTool*) data;
	NSSize				lineSize = [[tool owner] lineSize];
	NSRect				box;
	
	box.origin.x = x -truncf(lineSize.width / 2);
	box.origin.y = y -truncf(lineSize.height / 2);
	box.size = lineSize;
	
	NSRectFill( box );
}


/* Override this to draw a brush during tracking:
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
