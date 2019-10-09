
package require topotools
mol delete all
set structdir "./structure_files"
set dnaseq T10


#Generate this with 3d-dart online
mol new ./dna_structures/$dnaseq.pdb type pdb
set sel [atomselect top all]
$sel move [trans center {0 0 0} axis x 3.8]
set sel [atomselect top "chain A"]
$sel writepdb $structdir/$dnaseq.A.pdb

#Load and generate the psf for the dna
set inpdb $structdir/$dnaseq.A.pdb
source make-psf.tcl


#center the strand
mol delete all
mol new $structdir/ssdna.psf
mol addfile $structdir/ssdna.pdb

set sel [atomselect top all]
#Center the strand
$sel moveby [vecsub {0 0 0} [measure center $sel]]
#rotate the strand
set sel [atomselect top all] 
set com [measure center $sel weight mass] 
set matrix [transaxis x 90] 
$sel move $matrix 
$sel moveby {0 0 20}

$sel writepsf $structdir/ssdna_rot.psf
$sel writepdb $structdir/ssdna_rot.pdb

mol delete all

mol new repeated_mos2.pdb
set sel [atomselect top all]
$sel moveby [vecsub {0 0 0} [measure center $sel]]
set sel [atomselect top "z>0"] 
$sel writepdb $structdir/single_mos2.pdb

package require pbctools

pbc writexst $structdir/ssdna_mos2.xst

mol delete all

set mos2 [mol new $structdir/single_mos2.pdb]
set sel [atomselect top all]
$sel set resname MOS
for {set i 0} {$i<[$sel num]} {incr i} {
    set cursel [atomselect top "index $i"]
    $cursel set resid [expr $i+50]
}
#$sel set resid 0
$sel set segname MOS
$sel set chain M
set sel [atomselect top "type Mo"]
$sel set type N
$sel set name N


set dna [mol new $structdir/ssdna_rot.psf]
mol addfile $structdir/ssdna_rot.pdb

::TopoTools::mergemols [list $mos2 $dna]


animate write psf $structdir/ssdna_mos2.psf
animate write pdb $structdir/ssdna_mos2.pdb

mol delete all
mol new $structdir/ssdna_mos2.psf
mol addfile $structdir/ssdna_mos2.pdb

exit

