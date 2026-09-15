&inputfiles
 vtk_input_file='../S_upside_down/dwallr360_geoqm.vtk', ! shadowing geometry
 vtkres_input_file='../G_upside_down/powd_geoqm.vtk', ! results geometry
 geoq_input_file='../S_upside_down/dwallr360_geoq.out',
 hds_input_file='../H_upside_down/dwallr360_hds.hds'
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
      power_in_pfr=.false.
/
&termplaneparameters
      termplane_intersection=1
      termplane_direction=0,
      termplane_position=0.75
/
&edgprofparameters
      decay_length= 0.050 0.050 0.050 0.050,
      decay_length_near= 0.075 0.075 0.075 0.075,
     !lambda_q       1       2      3      4
      power_loss=69.0e+06 69.0e+06 69.0e+06 69.0e+06,
      diffusion_length=0.0  0.0   0.0   0.0,
      profile_formula='expdouble' 'expdouble' 'expdouble' 'expdouble',
      ratio_of_q_parallel0_near=0.5
/
&lambdaqparameters
/
&odesparameters
      abs_error=1.e-7,
      initial_dt=1.e-6,
      max_numsteps=100000,
      max_zeta=60.0,
      rel_error=1.e-7,
!      termination_parameters(1)=1.,
!      termination_parameters(2)=0.1,
/
