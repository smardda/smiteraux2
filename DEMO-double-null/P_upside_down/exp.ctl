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
      power_in_pfr=.false., 
      flux_from_pfc=.true.,
/
&termplaneparameters
      termplane_intersection=2
      termplane_direction=0,
      termplane_position(2)=0.75
/
&edgprofparameters
      decay_length= 0.050 0.050 0.050 0.050,
     !decay_length=0.0330 0.0330 0.0066 0.0066
     !lambda_q       1       2      3      4
      power_loss=69.0e+06 69.0e+06 69.0e+06 69.0e+06,
      diffusion_length=0.0  0.0   0.0   0.0,
      profile_formula='exp' 'exp' 'exp' 'exp',
/
&lambdaqparameters
/
&odesparameters
      abs_error=1.e-7,
      initial_dt=1.e-6,
      max_numsteps=10000000,
      max_zeta=60.0,
      rel_error=1.e-7,
!      termination_parameters(1)=0.0001,
!      termination_parameters(2)=0.1,
/
