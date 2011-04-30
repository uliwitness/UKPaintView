//
//  UKPixelPaintbrushTool.h
//  ULIPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ULIPaintTool.h"


@interface ULIPaintBrushTool : ULIPaintTool
{
	NSImage		*	mBrushImage;
	NSImage		*	mTintedBrushImage;
}

@property (retain) NSImage	*	brushImage;
@property (retain) NSImage	*	tintedBrushImage;

@end
