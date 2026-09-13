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
      decay_length=0.0001,
      power_loss=0.0001,
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
   radnsource_formula='physics'
   bremsstrahlung_switch=1,
   ne=1.0E+20,
   ne_a_exponent=2,
   ne_b_exponent=2,
   te=10000,
   te_a_exponent=2,
   te_b_exponent=2,
   total_power=-1,
   frac_impurity= 0.00 0.01 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00
  !frac_impurity= f_ar f_c  f_h  f_kr f_ne f_o  f_w  f_be f_fe f_he f_n  f_ni f_si f_xe
/
&rayparameters
   distance_strategy=0
/
