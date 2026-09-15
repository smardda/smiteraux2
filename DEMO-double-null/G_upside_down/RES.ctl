&inputfiles
 vtk_input_file='GEOM/dwall1.vtk',
 eqdsk_input_file='EQUIL/nf6m_CQ2_inverted.eqdsk'
/
&miscparameters
/
&plotselections
      plot_geoqx = .true.,
      plot_geoqvolx = .true.,
      plot_geoqm = .true.,
      plot_geofldx = .true.,
      plot_gnu = .true.,
      plot_gnusil = .true.,
/
&beqparameters
      beq_xsearch=1,
      beq_xzsta=-5.5,
      beq_xrsta=2.0,
      beq_xzend=7.0,
      beq_xrend=8.0,
      beq_psiopt=1,
      beq_psimax=31,
      beq_psimin=1,
      beq_fldspec=3,
      beq_cenopt=2,
      beq_bdryopt=16,
      beq_xiopt=2,
      beq_nzetap=1,
      n_xpoints=2,
      beq_psibig=1,
/
