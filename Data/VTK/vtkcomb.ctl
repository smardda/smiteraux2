&miscparameters
 option='panel',
 max_number_of_panels=80,
 max_number_of_transforms=20,
 angle_units='degrees'
/
&vtkfiles
 vtk_input_file='panels.vtk', 'icrh_antenna_shadow.vtk', 'icrh_antenna_observer.vtk'
 number_of_copies=1,1,1
/
&panelarrayparameters
      panel_bodies=101,201,301
      panel_transform=0,0,0
/
&positionparameters
      position_transform=12,  
/
