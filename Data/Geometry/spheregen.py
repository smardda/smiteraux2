#### import the simple module from the paraview
from paraview.simple import *
#### disable automatic camera reset on 'Show'
paraview.simple._DisableFirstRenderCameraReset()
# create a new 'Sphere'
sphere1 = Sphere()

# Properties modified on sphere1
sphere1.Radius = 1.0
sphere1.ThetaResolution = theta
sphere1.PhiResolution = phi

# get active view
renderView1 = GetActiveViewOrCreate('RenderView')
# uncomment following to set a specific view size
# renderView1.ViewSize = [1235, 566]

# show data in view
sphere1Display = Show(sphere1, renderView1)
# trace defaults for the display properties.
sphere1Display.Representation = 'Surface'
sphere1Display.ColorArrayName = [None, '']
sphere1Display.OSPRayScaleArray = 'Normals'
sphere1Display.OSPRayScaleFunction = 'PiecewiseFunction'
sphere1Display.SelectOrientationVectors = 'None'
sphere1Display.ScaleFactor = 0.1
sphere1Display.SelectScaleArray = 'None'
sphere1Display.GlyphType = 'Arrow'
sphere1Display.GlyphTableIndexArray = 'None'
sphere1Display.DataAxesGrid = 'GridAxesRepresentation'
sphere1Display.PolarAxes = 'PolarAxesRepresentation'


# create a new 'Clip'
clip1 = Clip(Input=sphere1)
clip1.ClipType = 'Plane'
clip1.Scalars = [None, '']

# init the 'Plane' selected for 'ClipType'
clip1.ClipType.Origin = [0.020253509283065796, 0.0, 0.0]

# Properties modified on clip1.ClipType
clip1.ClipType.Origin = [0.0202535092830658, 0.0, 0.0]

# Properties modified on clip1
clip1.Scalars = ['POINTS', '']

# Properties modified on clip1.ClipType
clip1.ClipType.Origin = [0.0202535092830658, 0.0, 0.0]

# show data in view
clip1Display = Show(clip1, renderView1)
# trace defaults for the display properties.
clip1Display.Representation = 'Surface'
clip1Display.ColorArrayName = [None, '']
clip1Display.OSPRayScaleArray = 'Normals'
clip1Display.OSPRayScaleFunction = 'PiecewiseFunction'
clip1Display.SelectOrientationVectors = 'None'
clip1Display.ScaleFactor = 0.19935842752456667
clip1Display.SelectScaleArray = 'None'
clip1Display.GlyphType = 'Arrow'
clip1Display.GlyphTableIndexArray = 'None'
clip1Display.DataAxesGrid = 'GridAxesRepresentation'
clip1Display.PolarAxes = 'PolarAxesRepresentation'
clip1Display.ScalarOpacityUnitDistance = 0.6183164335790884

# hide data in view
Hide(sphere1, renderView1)

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on clip1.ClipType
clip1.ClipType.Origin = [0.0202535092830658, 0.0, 0.01]

# Properties modified on clip1.ClipType
clip1.ClipType.Origin = [0.0202535092830658, 0.0, 0.01]

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on clip1.ClipType
clip1.ClipType.Normal = [0.0, 0.0, 1.0]

# Properties modified on clip1.ClipType
clip1.ClipType.Normal = [0.0, 0.0, 1.0]

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on clip1
clip1.Crinkleclip = 1

# update the view to ensure updated data information
renderView1.Update()

# get layout
layout1 = GetLayout()

# split cell
layout1.SplitHorizontal(0, 0.5)

# set active view
SetActiveView(None)

# Create a new 'SpreadSheet View'
spreadSheetView2 = CreateView('SpreadSheetView')
spreadSheetView2.ColumnToSort = ''
spreadSheetView2.BlockSize = 1024
# uncomment following to set a specific view size
# spreadSheetView2.ViewSize = [400, 400]

# place view in the layout
layout1.AssignView(2, spreadSheetView2)

# show data in view
clip1Display_1 = Show(clip1, spreadSheetView2)

# set active view
SetActiveView(None)

# set active view
SetActiveView(renderView1)

# reset view to fit data
renderView1.ResetCamera()

# change representation type
clip1Display.SetRepresentationType('Surface With Edges')

# save data
SaveData('ant0_vtk.vtk', proxy=clip1, FileType='Ascii')

#### saving camera placements for all active views

# current camera placement for renderView1
renderView1.CameraPosition = [8.045752232464242, -0.5802916267267657, 0.7860357900474909]
renderView1.CameraFocalPoint = [0.020253539085388184, 0.0, 0.010000050067901611]
renderView1.CameraViewUp = [-0.08576122156793459, 0.13416921702508539, 0.9872404135153967]
renderView1.CameraParallelScale = 2.092237821765404

#### uncomment the following to render all views
# RenderAllViews()
# alternatively, if you want to write images, you can use SaveScreenshot(...).
