&inputfiles
 vtk_input_file='../S/dwallr360_geoqm.vtk', ! shadowing geometry
 vtkres_input_file='../G/powd_geoqm.vtk', ! results geometry
 geoq_input_file='../S/dwallr360_geoq.out',
 hds_input_file='../H/dwallr360_hds.hds'
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
      refine_level=1,
      shadow_control=1,
      calculation_type='global',
      termination_planes = .true.,
      more_profiles = .true.,
      power_in_pfr=.true.,
      flux_from_pfc=.true.
/
&termplaneparameters
      termplane_intersection=1
      termplane_direction=0,
      termplane_position(1)=7.4162101308496293
/
&edgprofparameters
      decay_length= 0.050 0.050 0.050 0.050,
     !lambda_q       1       2      3      4
      power_loss=69.0e+06 69.0e+06 69.0e+06 69.0e+06,
      diffusion_length=0.005  0.005   0.005   0.005,
      profile_formula='eich' 'eich' 'eich' 'eich',
/
&lambdaqparameters
/
&odesparameters
      abs_error=1.e-6,
      initial_dt=1.e-6,
      max_numsteps=100000,
      max_zeta=60.0,
      rel_error=1.e-6,
!      termination_parameters(1)=0.001,
!      termination_parameters(2)=0.1,
/
