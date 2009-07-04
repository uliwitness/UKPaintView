//
//  UKPaintLassoTool.h
//  UKPaintView
//
//  Created by Uli Kusterer on Fri Oct 31 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

/* This tool lets the user draw an arbitrarily-shaped selection. */

#import <Foundation/Foundation.h>
#import "UKPaintPathTool.h"


@interface UKPaintLassoTool : UKPaintPathTool
{
	BOOL	dragNotCreate;
}

@end
