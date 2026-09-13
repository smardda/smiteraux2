# using jetwall_RZ.dat, 360deg poloidal wall of consecutive points (first=last)
# generate vtk file consisting of a single 1deg toroidal line of quads
datvtk -c jwal1.ctl
# convert units of jwal1_out.vtk to mm
vtktfm jwall1.ctl
# generate vtk file consisting of 360 x triangles (surface bounds volume)
datvtk -c jwall360.ctl
# convert units of jwall360_out.vtk to mm
vtktfm jwallr360.ctl
# tidy up
rm -f jwal1_out.vtk jwall360_out.vtk
