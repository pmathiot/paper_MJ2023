#!/bin/bash
set -x
python /ccc/workflash/cont003/gen6035/mathiotp/TOOLS/PyChart/pychart.py \
 --mapf  eORCA025.L121-OPM026/eORCA025.L121-OPM026_10y_y2009_psi.nc \
         eORCA025.L121-OPM031/eORCA025.L121-OPM031_10y_y2089_psi.nc \
 --cntf  eORCA025.L121-OPM026/eORCA025.L121-OPM026_10y_y2009_psi.nc \
         eORCA025.L121-OPM031/eORCA025.L121-OPM031_10y_y2089_psi.nc \
 --mapv   sobarstf \
 --cntv   sobarstf \
 --mapjk  0        \
 --mapjt  1    1   \
 --mapsf  0.000001 0.000001 \
 --cntsf  0.000001 \
 --cbn    RdBu_r  \
 --cblvl  -2.1 2.1 0.3 \
 --cntlvl -2.1 2.1 0.3 \
 --cbu    Sv       \
 --cbext  both     \
 --ft     'Barotropic stream function' \
 --spfid  'REF (2009-2018)' 'PERT (y90-100)' \
 --sp     2x1 \
 -o       fig12ab \
 -p       fris \
 --joffset -2

set +x
