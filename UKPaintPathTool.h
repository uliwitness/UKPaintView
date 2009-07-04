//
//  UKPaintPathTool.h
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

/* This tool lets the user draw a path, i.e. an arbitrarily-shaped closed
	region that is mathematically described and can thus be used for clipping,
	selection and lots of other useful things. I.e. this is a vector shape. */

#import <Foundation/Foundation.h>
#import "UKPaintTool.h"


@interface UKPaintPathTool : UKPaintTool
{
	NSBezierPath*		currentPath;
}

@end
