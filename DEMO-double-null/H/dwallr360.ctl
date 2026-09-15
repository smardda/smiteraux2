&inputfiles
 vtk_input_file='../S/dwallr360_geoqm.vtk',
/
&hdsgenparameters
 geometrical_type=2,
 limit_geobj_in_bin=200,
 margin_type=2,
 quantising_number=16384
/
&btreeparameters
 btree_sizel=20000000
 btree_size=20000000
 tree_type=3, ! multi-octree
 tree_ttalg=2, ! use nxyz
 tree_nxyz=1,1,4,
/
&positionparameters
position_transform=0,
/
&plotselections
      plot_hdsm = .true.,
      plot_hdsq = .true.,
      plot_geobjq = .true.,
      plot_geoptq = .true.,
/
