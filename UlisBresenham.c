//
//  UlisBresenham.c
//  Mediator 4
//
//  Created by Uli Kusterer on 2001-12-25
//  Copyright (c) 2001 Uli Kusterer.
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

/* -----------------------------------------------------------------------------
	Headers:
   -------------------------------------------------------------------------- */

#include	"UlisBresenham.h"


/* -----------------------------------------------------------------------------
	DrawBresenhamLine:
		Compute a line from startX,startY to endX,endY, passing the coordinates
		to the function specified.
	
	TAKES:
		startX			-	Horizontal coordinate of starting point.
		startY			-	Vertical coordinate of starting point.
		endX			-	Horz. coord. of end pt.
		endY			-	Vert. coord. of end pt.
		pixelDrawProc	-	Function of type void proc( float h, float v )
							that will be called for each pixel to do something
							with it, e.g. draw it.
		userData		-	Any data you wish that will be passed on to your
							pixeldrawProc as a service (i.e. it's a refCon).
	
	REVISIONS:
		2001-12-25	UK	Created.
   -------------------------------------------------------------------------- */

void	DrawBresenhamLine( float startX, float startY, float endX, float endY,
							BresenhamPixelProcPtr pixelDrawProc, void* userData )
{
	float		x, y,
				dx, dy,
				xDirection, yDirection,
				errorTerm = 0,
				i;
	
	// x distance:
	dx = endX -startX;
	if( dx < 0 )
		dx = -dx;
	
	// y distance:
	dy = endY -startY;
	if( dy < 0 )
		dy = -dy;
	
	// Horizontal line direction:
	if( endX - startX < 0 )
		xDirection = -1;
	else if( endX -startX > 0 )
		xDirection = 1;
	else
		xDirection = 0;
	
	// Vertical line direction:
	if( endY - startY < 0 )
		yDirection = -1;
	else if( endY -startY > 0 )
		yDirection = 1;
	else
		yDirection = 0;
	
	// Calculate first pixel:
	x = startX;
	y = startY;
	
	if( dx > dy )
	{
		// More horizontal than vertical:
		for( i = 0; i <= dx; i++ )
		{
			(*pixelDrawProc)( x, y, userData );	// Set this pixel.
			
			// Move horizontally:
			x += xDirection;
			
			// Check to see whether we need to move vertically:
			errorTerm += dy;
			
			if( errorTerm > dx )
			{
				errorTerm -= dx;	// Reset error term.
				y += yDirection; 	// Move one pixel up. 
			}
		}
	}
	else
	{
		// More vertical than horizontal:
		for( i = 0; i <= dy; i++ )
		{
			(*pixelDrawProc)( x, y, userData );	// Set this pixel.
			
			// Move vertically:
			y += yDirection;
			
			// Need to move horizontally?
			errorTerm += dx;
			
			if( errorTerm > dy )
			{
				errorTerm -= dy;	// Reset error term.
				x += xDirection; 	// Move one pixel right. 
			}
		}
	}
	
	
}