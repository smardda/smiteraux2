&inputfiles
 vtk_input_file='../S/gshad_geoqm.vtk', ! shadowing geometry
 vtkres_input_file='../G/top1barpart_geoqm.vtk', ! results geometry
 geoq_input_file='../S/gshad_geoq.out',
 hds_input_file='../H/hdshad_hds.hds',
 antenna_input_file='../ant21.vtk'
 radiation_input_file='../iteradn.txt'
/
&miscparameters
/
&plotselections
      plot_gnu = .true.,
      plot_rayg = .false.
      plot_powx = .true.,
      plot_flinx = .false.,
      plot_flinm = .false.,
      plot_flinends = .false.,
/
&powcalparameters
      perform_particle=0,
      shadow_control=1,
      perform_radiation=1,
      shadow_radiation=1,
      refine_level=1,
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
      initial_dt=1.e-5,
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
   radiation_diagnostics=.false.
   radnsource_formula='file_input'
/
&rayparameters
   distance_strategy=0
/
