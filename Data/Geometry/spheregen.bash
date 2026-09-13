#!/bin/bash
# insert values of theta/phi resolution into spheregen.py script and run
# First input specifies theta resolution
# Second input specifies phi resolution
# Third optional input specifies antenna name
nth=11
nph=11
ant=ant0_vtk
if [ $# -gt 3 ] || [ $# -lt 2 ] ; then        # 2 or 3 arguments must be present.
   echo "Usage: $0 <ntheta nphi> [<antenna_name>]"
   exit
fi
nth=$1
nph=$2
if [ $# -gt 2 ] ; then        # Antenna argument is present
   ant=$3
fi
rm -f temp_spheregen.py $ant.vtk temp_$ant.vtk
sed -e "7i theta = $nth; phi = $nph" -e "s/ant0_vtk/$ant/"< spheregen.py > temp_spheregen.py
pvbatch temp_spheregen.py  
#sed -i "7d" spheregen.py
sed -e '/METADATA/,+3 d' -e "s/vtk output/Mesh___Parameters=  2  $nth  $nph/" -e "4i\ "< $ant.vtk > temp_$ant.vtk
sed -e '/POINT_DATA/Q' < temp_$ant.vtk > $ant.vtk
rm -f temp_spheregen.py temp_$ant.vtk
