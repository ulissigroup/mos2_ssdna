#!/bin/sh

module load VMD NAMD
# vmd -e build_MoS2.tcl
vmd -e build_MoS2_b_solvate.tcl
sbatch submit_calc.sh
