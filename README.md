# SSDNA MoS2 interaction analysis
# with VMD and NAMD molecular simulations

# Author
Hyukjae Kwark

# Objective
Use all-atom molecular simulations to investigate the sequence dependence of single-stranded DNA on the dispersion and cytotoxicity(being toxic to cells) of MoS2, MoSe2, WS2, and WSe2 2D layered materials. To address the large design space of DNA sequence he will develop systematic calculation workflows and predictive data-driven molecules of DNA/material interaction.


# Folder structure
| large_sheet_results | basic files : Includes all the basic file requirements necessary to run a simulation. Would have to change
build_MoS2_b.tcl or buid_MoS2.tcl depending on which ssDNA you are using. | solvent_add_trial : Includes trials for adding solvent (water) into the MoS2 - ssDNA system |
|-------------|-------------|-------------|
| small_sheet_results | fixed_mos2_solvate_output_().txt are all output interaction energy files for a small MoS2 ssDNA system | ()_struture files folder includes all strucutre files generated through running the calculations.
|-------------|-------------|-------------|
| sample_plot_folder | CA10.txt ~ T20.txt are sample interaction energy results. | Plot_interaction_energy.ipynb is a jupyter notebook that contains plots using these text files.


# How to run calculations

1. Log in to username@coe.psc.edu

2. Run the following 
```sh
$ module load VMD NAMD
$ vmd -e build_MoS2.tcl
$ vmd -e build_MoS2_b.tcl
$ sbatch submit_calc.sh
``` 
Or you can also run the above lines by building a single executable file.<br/>

```sh
$ nano build file_name.sh
$ chmod +x file_name.sh
$ ./file_name.sh
``` 
You can find an example of an executable file from large_sheet_results\solvent_add_trial\build_submit.sh<br/>

# How to check running status

To check your calculation(work) status do the following.<br/>

```sh
$ squeue -u UserName
``` 
To cancel your job <br/>
```sh
$ scancel jobid
``` 

# Output files
By running the calculations, a new directory "fixed_mos2_solvate_output" is created.
Inside the folder, you will be able to find a .dcd file, which is the output file you will be using in the future.
Be aware that if you run a new calculation, everything inside the fixed_mos2_solvate_output directory will be overwritten by default.


# Running the simulation result on VMD GUI
VMD commannds to observe visualized simulation results on the VMD gui. <br/>
Must use the right pdb, psf, and dcd files representing the same system. <br/>
```sh
mol new ***.pdb
mol addfile ***.psf
mol addfile ***.dcd
``` 

# Fetching Ineraction Energy Data
After finishing your calculations, use interaction_energy.tcl to extract interaction energy data from your .dcd (output) file <br/>
```sh
$ module avail
$ module load NAMD/2.13_nightly-cpu
$ vmd -e interaction_energy.tcl
``` 
Running this command will generate four files, fixed_mos2_solvate_output_CA10.txt, fixed_mos2_solvate_output_GT10.txt, fixed_mos2_solvate_output_T10.txt, and fixed_mos2_solvate_output_T20.txt. These correspond to the interaction energy output data between MoS2 and each corresponding single stranded DNA. 


# Visualizing Results (Plotting)
By the end of the step, you will have all the necessary files (four .txt files) available to plot a interaction energy plot. <br/>
Please reference to Plot_interaction_energy.ipynb inside the sample_plot_folder for an example plot.


# Future Steps
Unfortunately, I have failed to produce a nicely settled interaction energy plot with a system including solvate (water).
I have tried turning on a flexible cell (to avoid pressure explosion) and turning fixedAtom off, which did not work well as desired.
The following observed problem was that the MoS2 sheet expands as time step increases, with out staying still in there original position. 
One solution could be adding a spring between Mo and S molecules to apply a potentail E = 1/2 k x^2 between different MoS2 particles and layers, but needs to be further implemented to
produce reasonable results. 


