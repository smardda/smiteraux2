&progfiles
  vtk_input_file='jdiv11.vtk'
  eqdsk_input_file='jet297.eqdsk'
  antenna_input_file='ant10.vtk'
  radiation_input_file='kprad_00224_6.txt'
/
&miscparameters
/
&plotselections
   plot_gnu=.true.
   plot_vtk=.true.
   plot_powx=.true.
/
&antestparameters
    !number_of_samples_in_theta = 10
    !number_of_samples_in_phi = 10
    case_select_for_sampling_pattern = 1
/
&antennaparameters
   plot_diagvtk=.false.
/
&radnsourceparameters
   radnsource_formula='file_input'
/
&rayparameters
   nsample = 35
   termdistance = 100 
   distance_strategy=0
/
&beqparameters
   beq_fldspec=3,
   beq_cenopt=2,
   beq_bdryopt=8,
   beq_xiopt=2,
   beq_nzetap=1,
/   
