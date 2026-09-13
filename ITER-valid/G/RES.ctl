&inputfiles
 vtk_input_file='RES',
 eqdsk_input_file='EQDSK'
/
&miscparameters
/
&plotselections
      plot_geoqx = .false.,
      plot_geoqvolx = .false.,
      plot_geoqm = .true.,
      plot_geofldx = .false.,
      plot_gnu = .false.,
      plot_gnusil = .false.,
/
&beqparameters
      beq_fldspec=3,
      beq_cenopt=2,
      beq_bdryopt=8,
      beq_psiref=1,
      beq_nzetap=1,
/
