//
//  UKPaintShapeTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Sat Nov 01 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKPaintShapeTool.h"
#import "UKPaintView.h"
#import "NSBezierPath+ULIRegularPolygon.h"


@implementation UKPaintShapeTool

@synthesize shape = mShape;

-(id)	initWithPaintView:(UKPaintView *)pv
{
	if(( self = [super initWithPaintView: pv] ))
	{
		mShape = [[NSBezierPath alloc] init];
		[mShape appendRegularPolygonAroundPoint: NSZeroPoint startPoint: NSMakePoint(100, 0) cornerCount: 3 +rand() % 7];
	}
	
	return self;
}


-(void)	dealloc
{
	DESTROY_DEALLOC(mShape);
	
	[super dealloc];
}


/* Override this to draw a shape during tracking:
	The drawings you do in here will be undone before you're called again.
	This is also called when tracking has finished by drawFinalToolShapeFrom:to: by default. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	NSBezierPath	*	currShape = [[mShape copy] autorelease];
	NSRect				box = [self rectFrom: [owner initialPos] to: currPos];
	NSRect				oldBox = [self rectWithLineSizeFrom: [owner initialPos] to: *prevPos];
	NSRect				shapeBounds = [currShape bounds];
	NSAffineTransform*	scaleTransform = [NSAffineTransform transform];
	NSAffineTransform*	moveToZeroTransform = [NSAffineTransform transform];
	NSAffineTransform*	moveToMouseTransform = [NSAffineTransform transform];
	[moveToZeroTransform translateXBy: -shapeBounds.origin.x
						yBy: -shapeBounds.origin.y];
	[scaleTransform scaleXBy: box.size.width / shapeBounds.size.width
						yBy: box.size.height / shapeBounds.size.height];
	[moveToMouseTransform translateXBy: box.origin.x
						yBy: box.origin.y];
	[currShape transformUsingAffineTransform: moveToZeroTransform];
	[currShape transformUsingAffineTransform: scaleTransform];
	[currShape transformUsingAffineTransform: moveToMouseTransform];

	[[owner lineColor] set];
	[currShape setLineWidth: [owner lineSize].width];
	[currShape stroke];
		
	[owner setNeedsDisplayInRect: oldBox];
	NSRect	newBox = [self rectWithLineSizeFrom: [owner initialPos] to: currPos];
	[owner setNeedsDisplayInRect: newBox];
	
	*prevPos = currPos;
}


-(NSString*)	toolIconName
{
	return @"UKPaintShapeTool";
}



@end
