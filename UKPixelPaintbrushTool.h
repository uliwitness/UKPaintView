//
//  UKPixelPaintbrushTool.h
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UKPaintTool.h"


@interface UKPixelPaintbrushTool : UKPaintTool
{
	NSImage		*	mBrushImage;
	NSImage		*	mTintedBrushImage;
}

@property (retain) NSImage	*	brushImage;
@property (retain) NSImage	*	tintedBrushImage;

@end
