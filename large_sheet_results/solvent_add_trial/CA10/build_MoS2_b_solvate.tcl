package require topotools
package require pbctools
package require solvate
package require autoionize

set structdir "./structure_files"

set pdb_file CA10no_water_result.pdb
set psf_file ssdna_mos2_ions_CA10.psf

package require cionize



# solvate $structdir/ssdna_mos2_nowater_ions.psf $structdir/ssdna_mos2_nowater_ions.pdb -o $structdir/solvate +z 50

#################### change occured ##########################
# Thought that ssdna_mos2_nowater_ions.psf/pdb file is equal to the pdb and psf file we have extracted #

set sel [atomselect top "type Mo"]
$sel set type N
solvate $psf_file $pdb_file -o $structdir/solvate +z 50
set sel [atomselect top "type N"]
$sel set type Mo

##############################################################
mol delete all
mol new $structdir/solvate.psf
mol addfile $structdir/solvate.pdb


# autoionize -psf $structdir/solvate.psf -pdb $structdir/solvate.pdb -sc 0 -o $structdir/ionize

mol delete all
mol new $structdir/solvate.psf
mol addfile $structdir/solvate.pdb
mol new $psf_file
mol addfile $pdb_file



set solvatecell [pbc get]
pbc readxst structure_files/ssdna_mos2.xst -noskipfirst
set mos2cell [pbc get]
lset mos2cell 0 2 [lindex $solvatecell 0 2]
pbc set $mos2cell
pbc writexst structure_files/ssdna_mos2_ions.xst

set sel [atomselect top "resname MOS and type N"]
$sel set type Mo
$sel set name Mo
set sel [atomselect top "resname MOS and type S"]
$sel set type SM
$sel set name SM

set selection [atomselect top all]
$selection set occupancy 0
$selection writepsf $structdir/ssdna_mos2_ions.psf
$selection writepdb $structdir/ssdna_mos2_ions.pdb

mol delete all

mol new $structdir/ssdna_mos2_ions.psf
mol addfile $structdir/ssdna_mos2_ions.pdb
set Selection [atomselect top "all"]
$Selection set occupancy 0

set Selection [atomselect top "resname MOS"]
$Selection set occupancy 1
animate write pdb $structdir/ssdna_mos2_ions_fixed.pdb

#package require pbctools

#pbc writexst $structdir/ssdna_mos2_ions.xst
#set Selection [atomselect top "not type SOD "]
##set Selection [atomselect top "resname CNT"]
#$Selection set occupancy 1


#animate write pdb $structdir/ssdnaout_stretched_cnt_ion_fixedI.pdb

exit
