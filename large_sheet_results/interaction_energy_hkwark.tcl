# mol new structure_files/ssdna_mos2_ions.psf
# mol addfile structure_files/ssdna_mos2_ions.pdb
# mol addfile fixed_mos2_solvate_output/fixed_cnt_solvate.dcd waitfor -1

package require namdenergy
foreach folder {"CA10" "GT10" "T10" "T20"} {

mol delete all
mol new $folder/structure_files/ssdna_mos2_ions.psf
mol addfile $folder/structure_files/ssdna_mos2_ions_fixed.pdb
mol addfile $folder/fixed_mos2_solvate_output/fixed_cnt_solvate.dcd waitfor -1 step 10

set selmos2 [atomselect top "resname MOS"]
set seldna [atomselect top "segname DNAA"]
namdenergy -vdw -elec -nonb -sel $selmos2 $seldna -par $folder/par_cntgraph.par -extsys $folder/structure_files/ssdna_mos2_ions.xst -ofile $folder.txt -T 300 -switch 9 -cutoff 10 -par $folder/par_all27_prot_lipid_na.inp

}