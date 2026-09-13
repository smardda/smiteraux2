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
      plot_gnu = .true.,
      plot_gnusil = .true.,
/
&beqparameters
      beq_fldspec=3,
      beq_cenopt=2,
      beq_bdryopt=9,
      beq_psiref=        1.1410012    ,
      beq_xiopt=2,
      beq_nzetap=1,
/
