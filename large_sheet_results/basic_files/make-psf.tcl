package require psfgen
resetpsf
topology top_all27_na.rtf
mol delete all
mol new $inpdb
set all [atomselect top all]
foreach chain [lsort -unique [$all get chain]] {
    set sel [atomselect top "chain $chain and name C1'"]
    set seg DNA$chain
    $sel set segname $seg
    segment $seg {
	first 5TER
	last 3TER
	pdb $inpdb
    }
    foreach resid [$sel get resid] resname [$sel get resname] {
	if { $resname eq "THY" || $resname eq "CYT" } {
	    patch DEO1 $seg:$resid
	} elseif { $resname eq "ADE" || $resname eq "GUA" } {
	    patch DEO2 $seg:$resid
	}
    }
    coordpdb $inpdb $seg
}
guesscoord

set sel [atomselect top "chain A"]
writepsf $structdir/ssdna.psf
writepdb $structdir/ssdna.pdb
