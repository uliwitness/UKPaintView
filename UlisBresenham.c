/* =============================================================================
	PROJECT:	Mediator 4
	
	FILE:		UlisBresenham.c
	
	PURPOSE:	Utility routine that allows computing lines. E.g. to draw
				shapes that are on a line, hit-testing on a line or whatever.
	
	COPYRIGHT:	(c) 2001 by M. Uli Kusterer, all rights reserved.
	
	AUTHORS:	UK	-	M. Uli Kusterer <witness@weblayout.com>
	
	REVISIONS:
		2003-11-03	UK	Changed to use float.
		2001-12-25	UK	Created.
   ========================================================================== */

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