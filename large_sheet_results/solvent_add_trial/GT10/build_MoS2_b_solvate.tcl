package require topotools
package require pbctools
package require solvate
package require autoionize

set structdir "./structure_files"

set pdb_file GT10_no_water_result.pdb
set psf_file $structdir/ssdna_mos2_ions.psf

package require cionize

# newly added
mol new $psf_file
mol addfile $pdb_file



#[atomselect top "segname MOS"] set resid 0

set mos2_sel [atomselect top "segname MOS"]
#get all of the resid
set mos2_resid [$mos2_sel get resid]
set mos2_segname [$mos2_sel get segname]
set new_resid {}
set new_segname {}
foreach resid $mos2_resid {
    set segnum [expr "$resid%10000"]
    set resnum [expr "round(floor($resid/10000))"]

    lappend new_resid $segnum
    lappend new_segname "MOS$resnum"
}

$mos2_sel set resid $new_resid
$mos2_sel set segname $new_segname
#puts $new_resid
#puts $new_segname
set sel [atomselect top "type Mo"]
$sel set type N
$sel set name N
$sel set element MO

set sel [atomselect top "type SM"]
$sel set type S
$sel set name S
$sel set element S

set sel [atomselect top "segname DNAA"]
set sel_types [$sel get type]
set lst {}
foreach thing $sel_types {
	set i [string index $thing 0]
	lappend lst $i
}
$sel set element $lst
animate write psf $structdir/ssdna_mos2_ions_modified.psf
animate write pdb $structdir/ssdna_mos2_ions_modified.pdb

########### Question 1 why does this one not work???? ##########
# $sel writepsf $structdir/ssdna_mos2_ions_modified.psf
# $sel writepdb $structdir/ssdna_mos2_ions_modified.pdb
################################################################
mol delete all


solvate $structdir/ssdna_mos2_ions_modified.psf $structdir/ssdna_mos2_ions_modified.pdb -o $structdir/solvate +z 50

################### change occured ##########################
# Thought that ssdna_mos2_nowater_ions.psf/pdb file is equal to the pdb and psf file we have extracted #

# set sel [atomselect top "type Mo"]
# $sel set type N
# solvate $psf_file $pdb_file -o $structdir/solvate +z 50
# set sel [atomselect top "type N"]
# $sel set type Mo

################################################################

# autoionize -psf $structdir/solvate.psf -pdb $structdir/solvate.pdb -sc 0 -o $structdir/ionize

mol delete all
mol new $structdir/solvate.psf
mol addfile $structdir/solvate.pdb


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
$selection writepsf $structdir/ssdna_mos2_ions_final.psf
$selection writepdb $structdir/ssdna_mos2_ions.pdb

mol delete all

mol new $structdir/ssdna_mos2_ions_final.psf
mol addfile $structdir/ssdna_mos2_ions.pdb
set Selection [atomselect top "all"]
$Selection set occupancy 0

animate write pdb $structdir/ssdna_mos2_ions.pdb

set Selection [atomselect top "resname MOS"]
$Selection set occupancy 1
animate write pdb $structdir/ssdna_mos2_ions_fixed.pdb



# ########################################################
# ##### this part was commented in zulissi file ######

# # package require pbctools

# # pbc writexst $structdir/ssdna_mos2_ions.xst
# # set Selection [atomselect top "not type SOD "]
# # #set Selection [atomselect top "resname CNT"]
# # $Selection set occupancy 1


# # animate write pdb $structdir/ssdnaout_stretched_cnt_ion_fixedI.pdb

exit
