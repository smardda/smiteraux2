#!/bin/bash

# Get psi values of psicen and psibdry from GEOQ.log
psicen=$(awk '/psicen  =/{print $6}' $1)
psibdry=$(awk '/psi plasma boundary/{print $7}' $1)

# Insert values of psicen and psibdry to.ctl file
sed -i "/psicen=/ s/$/ $psicen/" $2
sed -i "/psibdry=/ s/$/ $psibdry/" $2
more $2
# First infile should be GEOQ logfile
# Second infile should be .ctl file being appended to
