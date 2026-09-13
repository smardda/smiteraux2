&inputfiles
 vtk_input_file='../S/jwallr360_geoqm.vtk', ! shadowing geometry
 vtkres_input_file='../G/jone_geoqm.vtk', ! results geometry
 geoq_input_file='../S/jwallr360_geoq.out',
 hds_input_file='../H/jwallr360_hds.hds',
 antenna_input_file='../ant11.vtk'
/
&miscparameters
/
&plotselections
      plot_gnu = .true.,
      plot_powx = .true.,
      plot_flinx = .false.,
      plot_flinm = .false.,
      plot_flinends = .false.,
/
&powcalparameters
      perform_particle=0
      perform_radiation=1
      shadow_radiation=1
      refine_level=1,
      shadow_control=1,
      calculation_type='global',
      termination_planes = .true.,
      more_profiles = .true.
/
&termplaneparameters
      termplane_intersection=2
      termplane_direction=0
      termplane_position=0
/
&edgprofparameters
      decay_length=0.0066,
      power_loss=10.5e+06,
      diffusion_length=0.,
      profile_formula='exp'
/
&odesparameters
      initial_dt=0.0001,
      abs_error=1.e-5,
      rel_error=1.e-5,
      termination_parameters(1)=3.,
      termination_parameters(2)=0.1,
      max_numsteps=40000,
      max_zeta=80.,
/
&antennaparameters
   plot_diagvtk=.false.
/
&radnsourceparameters
   radiation_diagnostics=.true.
   radnsource_formula='circular'
   total_power=1.0e+6
   a_exponent=0.6
/
&rayparameters
   distance_strategy=0
/
