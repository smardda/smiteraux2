&inputfiles
 vtk_input_file='../S/gshad_geoqm.vtk',
/
&hdsgenparameters
 geometrical_type=2,
 limit_geobj_in_bin=30,
 margin_type=2,
 quantising_number=1000000
/
&btreeparameters
 btree_sizel=50000000
 btree_size=5000000
 tree_type=3, ! multi-octree
 tree_ttalg=2, ! use nxyz
 tree_nxyz=2,2,1,
/
&positionparameters
position_transform=1,
/
&plotselections
      plot_hdsm = .true.,
      plot_hdsq = .true.,
      plot_geobjq = .true.,
      plot_geoptq = .true.,
/
