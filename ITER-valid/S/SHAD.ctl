&inputfiles
 vtk_input_file='SHAD',
 eqdsk_input_file='EQDSK'
/
&miscparameters
/
&plotselections
      plot_geoqx = .true.,
      plot_geoqvolx = .false.,
      plot_geoqm = .true.,
      plot_geofldx = .true.,
      plot_gnu = .true.,
      plot_gnusil = .true.,
/
&beqparameters
      beq_fldspec=3,
      beq_cenopt=2,
      beq_bdryopt=8,
      beq_psiref=0.,
      beq_nzetap=3,
/
