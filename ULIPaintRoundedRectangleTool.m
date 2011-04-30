//
//  UKPaintRoundrectTool.m
//  UKPaintView
//
//  Created by Uli Kusterer on Wed Feb 04 2004.
//  Copyright (c) 2004 M. Uli Kusterer. All rights reserved.
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

#import "ULIPaintRoundedRectangleTool.h"
#import "ULIPaintView.h"
#import "NSBezierPath+RoundRect.h"


@implementation ULIPaintRoundedRectangleTool

@synthesize cornerRadius = mCornerRadius;


-(id)	initWithPaintView:(ULIPaintView *)pv
{
	if(( [super initWithPaintView: pv] ))
	{
		mCornerRadius = 8;
	}
	
	return self;
}


/* Draw a shape during tracking:
	The drawings we do in here will be undone before we're called again.
	This is also called when tracking has finished by drawFinalToolShapeFrom:to: by default. */
-(void)			drawTemporaryTrackingToolShapeFrom: (NSPoint*)prevPos to: (NSPoint)currPos
{
	NSRect		box = [self rectFrom: [owner initialPos] to: currPos];
	NSRect		oldBox = [self rectWithLineSizeFrom: [owner initialPos] to: *prevPos];
	
	[[owner lineColor] setStroke];
	[[owner fillColor] setFill];
	[NSBezierPath setDefaultLineWidth: [owner lineSize].width];
	[NSBezierPath strokeRoundRectInRect: box radius: mCornerRadius];
	[NSBezierPath fillRoundRectInRect: box radius: mCornerRadius];
	
	box = [self rectWithLineSizeFrom: [owner initialPos] to: currPos];
	
	[owner setNeedsDisplayInRect: oldBox];
	[owner setNeedsDisplayInRect: box];
	
	*prevPos = currPos;
}


-(NSString*)	toolIconName
{
	return @"UKPaintRoundrectTool";
}



@end
