# using demowall_RZ.dat, 360deg poloidal wall defined by consecutive points (first=last)
# generate vtk file consisting of a single 1deg toroidal line of quads
datvtk -c dwal1.ctl
# convert units of dwal1_out.vtk to mm
vtktfm dwall1.ctl
# generate vtk file consisting of 360 x triangles (surface bounds volume)
datvtk -c dwall360.ctl
# convert units of dwall360_out.vtk to mm
vtktfm dwallr360.ctl
# tidy up
rm -f dwal1_out.vtk dwall360_out.vtk
