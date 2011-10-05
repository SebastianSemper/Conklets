require 'cairo'
require 'imlib2'

cs, cr = nil

function conky_text(string)
	return string
end

function conklets_rect(x,y,w,h,r)
	cairo_move_to(cr,x+r,y)	
	cairo_arc(cr,x+w-r,y+r,r,-math.pi/2,0)	
	cairo_arc(cr,x+w-r,y+h-r,r,0,math.pi/2)	
	cairo_arc(cr,x+r,y+h-r,r,math.pi/2,math.pi)	
	cairo_arc(cr,x+r,y+r,r,math.pi,1.5*math.pi)
	cairo_close_path (cr)
	cairo_fill_preserve(cr)
	cairo_stroke(cr)
end

function conklets_polygon(poly,l,r,s)
	cairo_move_to(cr,poly[1],poly[2])	
	cairo_set_source_rgba (cr, 1, 1, 1, 0.5);
	cairo_set_line_width (cr,1.0);
	--hilfslinien
	local n,p = 0,0
	local alpha,beta
	local x1,x2,x3,x4,y1,y2,y3,y4 = 0,0,0,0,0,0,0,0
	for i=0,l-1 do
		n = (i+1) % l
		p = (i-1) % l
		
		alpha = math.atan2((poly[2*i+2]-poly[2*n+2]),(poly[2*i+1]-poly[2*n+1]))
		beta = math.atan2((poly[2*p+2]-poly[2*i+2]),(poly[2*p+1]-poly[2*i+1]))
		
		x1 = poly[2*p+1]-r*math.cos(beta)
		y1 = poly[2*p+2]-r*math.sin(beta)
		x2 = poly[2*i+1]+s*r*math.cos(beta)
		y2 = poly[2*i+2]+s*r*math.sin(beta)
		x3 = poly[2*i+1]-s*r*math.cos(alpha)
		y3 = poly[2*i+2]-s*r*math.sin(alpha)
		x4 = poly[2*i+1]-r*math.cos(alpha)
		y4 = poly[2*i+2]-r*math.sin(alpha)
		
		cairo_move_to(cr,x1,y1)		
		cairo_line_to(cr,poly[2*i+1]+r*math.cos(beta),poly[2*i+2]+r*math.sin(beta))
		cairo_curve_to(cr,x2,y2,x3,y3,x4,y4)

					
	end
	--cairo_close_path(cr)
	--cairo_fill_preserve(cr)
	cairo_stroke(cr)
	
end

function conky_conklets_startup()	
	if conky_window == nil then return end
	if cs == nil or cairo_xlib_surface_get_width(cs) ~= conky_window.width or cairo_xlib_surface_get_height(cs) ~= conky_window.height then
		if cs then cairo_surface_destroy(cs) end
		cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
	end
	if cr then cairo_destroy(cr) end
	cr = cairo_create(cs)
	
	cairo_set_source_rgba (cr, 1, 0.5, 0.5, 0.5);
	cairo_set_line_width (cr, 2.0);

	conky_conklets_draw()
end

function conky_conklets_draw()
	conklets_rect(20,20,70,50,10)
	polygon_1 = {100,100, 150,100, 150,150, 200,150, 200,200, 100,200}
	conklets_polygon(polygon_1,6,20,0.5)
end

function conky_conklets_cleanup()
	cairo_surface_destroy(cs)
	cs = nil
end
