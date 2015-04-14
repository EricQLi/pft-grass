#!/bin/bash
 
# script for displaying PFT output in GRASS
 
# start monitor to display data
d.mon x1
 
# interpolate vector data to raster map
v.surf.rst input=test@PERMANENT zcol=dbl_1 tension=40 elev=test5 maskmap=CAT_MASK@PERMANENT --overwrite

# buffer plots
v.buffer input=test@PERMANENT output=plots_buffer type=point,centroid,line,boundary,area layer=1 distance=0.1 minordistance=0.1 angle=0 scale=1.0 tolerance=0.01 --overwrite # distance = 0.07 is optimal
 
# display buffered plots
d.vect map=plots_buffer@PERMANENT display=shape type=area layer=1 color=black fcolor=black render=c
 
# convert buffer to raster
v.to.rast input=plots_buffer@PERMANENT output=plots_buffer_rast use=val type=point,line,area layer=1 value=1 rows=4096 --overwrite
 
# display buffer raster
r.colors map=plots_buffer_rast@PERMANENT color=grey
d.rast -o map=plots_buffer_rast@PERMANENT
# use buffer raster as new mask
r.mask -o input=plots_buffer_rast@PERMANENT maskcats=*
 
# display hillshade map
d.rast map=hillshade@PERMANENT
 
# display raster map
r.colors map=elevation color=grey
r.colors map=test5@PERMANENT color=elevation
#d.shadedmap reliefmap=hillshade4@PERMANENT drapemap=test5@PERMANENT brighten=20
r.blend first=test5@PERMANENT second=elevation@PERMANENT output=test6 percent=50 --overwrite
d.rgb r=test6.r g=test6.g b=test6.b
 
# display vector data in thematic (i.e. classified) format
d.vect.thematic map=test@PERMANENT type=point column=dbl_1 themetype=graduated_colors themecalc=interval layer=1 icon=basic/circle size=4 maxsize=20 nint=4 colorscheme=single_color pointcolor=125:125:125 linecolor=0:0:0 startcolor=255:0:0 endcolor=0:0:255 monitor=x1
 
# display grid
d.grid size=001:00:00 origin=0,0 color=gray bordercolor=black textcolor=black fontsize=10
 
# display boundaries
d.vect map=CAT2@PERMANENT display=shape type=area layer=1 color=black fcolor=none rgb_column=GRASSRGB zcolor=terrain width=2 wscale=1 icon=basic/x size=5 llayer=1 lcolor=red bgcolor=none bcolor=none lsize=8 xref=left yref=center render=c
 
# display legend
d.legend map=test5@PERMANENT color=black lines=1 thin=1 labelnum=7 at=15,20,50,90 -s range=500,2000
  
# save as PNG
d.out.file output=test format=png resolution=1 compression=0 quality=100 --overwrite
