&inputfiles
 vtk_input_file='../S/jwallr360_geoqm.vtk',
/
&hdsgenparameters
 geometrical_type=2,
 limit_geobj_in_bin=40,
 margin_type=2,
 quantising_number=16384
/
&btreeparameters
 btree_sizel=20000000
 tree_type=3, ! multi-octree
 tree_ttalg=2, ! use nxyz
 tree_nxyz=1,1,4,
/
&positionparameters
position_transform=1,
/
&plotselections
      plot_hdsm = .false.,
      plot_hdsq = .false.,
      plot_geobjq = .false.,
      plot_geoptq = .false.,
/
