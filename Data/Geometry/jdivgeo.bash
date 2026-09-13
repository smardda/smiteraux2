# using jetdiv_RZ.dat, for antest and JET use
# generate vtk file consisting of a 2deg toroidal tile 5 wih quads
datvtk -c jdiv00.ctl
# convert units of jdiv00_out.vtk to mm
vtktfm jdiv41.ctl
# generate vtk file consisting of a 10deg toroidal triangulated tile 5
datvtk -c jdiv01.ctl
# convert units of jdiv01_out.vtk to mm
vtktfm jdiv11.ctl
# tidy up
rm -f jdiv00_out.vtk jdiv01_out.vtk
