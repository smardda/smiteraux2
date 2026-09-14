for i in $(find . -name "*_powx.vtk"); do
paraview --data=$i
done
