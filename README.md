# Velest Routine
Routine to iteratively run Velest on Ubuntu (tested in Ubuntu 20.04 LTS), saving a record of program outputs and inputs in each iteration.

**VERSION:** 1.0.0

**AUTHOR:**  Pablo Urra-Tapia - <pablourra2016@udec.cl> - [GitHub](https://github.com/pablourrat)

**LICENSE:**  GNU-GPL v3
## Velest_routine

Velest_routine utilizes a copy of the input files and modifications of the control file velest_ori.cmn, updating the file names in the input and output files in each iteration. For example:

1. Start the program.
2. Input file names:
   - Velocity_model.mod  -> m_01.mod
   - station_file.sta -> s_01.sta
   - earthquake_file.cnv -> h_01.cnv

### First Iteration:
   - Input files:
     - m_01.mod
     - s_01.sta
     - h_01.cnv
   - Output files:
     - m_01.out
     - s_01.out
     - h_01.out
   - Proceed to the next iteration?

In each subsequent iteration, a new parameter can be selected for modification. Only one file or the vpvs ratio changes per iteration, while the others remain constant. The used files are moved to the created directory.

For each iteration, the names of the input and output files are saved, along with the specific change made in that iteration.

## Extract_velocity_model.sh

Script to create velocity model output from the main output (you have to edit some parts of this script for your case)

## plot_velest.py

Python script to plot the results obtained for each iteration and a global plot for all iterations


