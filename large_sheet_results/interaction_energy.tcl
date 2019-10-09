mol new dna_mos2/structure_files/ssdna_mos2_ions.psf
mol addfile dna_mos2/structure_files/ssdna_mos2_ions.pdb
mol addfile dna_mos2/fixed_mos2_solvate_output/fixed_cnt_solvate.dcd waitfor -1

package require namdenergy
foreach folder {"fixed_mos2_solvate_output_T20" "fixed_mos2_solvate_output_T10" "fixed_mos2_solvate_output_CA10" "fixed_mos2_solvate_output_gt10"} {
mol delete all
mol new $folder/structure_files/ssdna_mos2_ions.psf
mol addfile $folder/structure_files/ssdna_mos2_ions.pdb
mol addfile $folder/fixed_mos2_solvate_output/fixed_cnt_solvate.dcd waitfor -1 step 10

set selmos2 [atomselect top "resname MOS"]
set seldna [atomselect top "segname DNAA"]
namdenergy -vdw -elec -nonb -sel $selmos2 $seldna -par dna_mos2/par_cntgraph.par -extsys $folder/structure_files/ssdna_mos2_ions.xst -ofile $folder.txt -T 300 -switch 9 -cutoff 10 -par dna_mos2/par_all27_prot_lipid_na.inp
}