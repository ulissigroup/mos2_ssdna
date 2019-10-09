import ase.io
import numpy as np
atoms = ase.io.read('MoS2_mp-2815_primitive.cif')
# repeated = atoms.repeat((30,30,1))
repeated = atoms.repeat((60,60,1))

cell = repeated.get_cell()
repeated.set_cell([[cell[0][0], 0, 0], [0,cell[0][0]*np.sqrt(3.)/2.0,0],[0,0,20]])
repeated.wrap()
repeated.write('repeated_mos2.pdb')
repeated.write('repeated_mos2.traj')

