//
//  UKPaintShapeTool.h
//  UKPaintView
//
//  Created by Uli Kusterer on Sat Nov 01 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ULIPaintTool.h"


@interface ULIPaintShapeTool : ULIPaintTool
{
	NSBezierPath	*	mShape;
}

@property (retain) NSBezierPath	*	shape;

@end
