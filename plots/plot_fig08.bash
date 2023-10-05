#!/bin/bash
set -x
CASE1=OPM026
CASE2=OPM031
python /ccc/workflash/cont003/gen6035/mathiotp/TOOLS/PyChart/pychart.py \
 --mapf  eORCA025.L121-${CASE1}/eORCA025.L121-${CASE1}_10y_y2009_psi.nc \
         eORCA025.L121-${CASE2}/eORCA025.L121-${CASE2}_10y_y2089_psi.nc  \
 --cntf  eORCA025.L121-${CASE1}/eORCA025.L121-${CASE1}_10y_y2009_psi.nc \
         eORCA025.L121-${CASE2}/eORCA025.L121-${CASE2}_10y_y2089_psi.nc    \
 --mapv   sobarstf sobarstf \
 --cntv   sobarstf  \
 --mapjk  0         \
 --mapjt  1 1       \
 --mapsf  0.000001 0.000001 \
 --cntsf  0.000001          \
 --cbn    gist_heat_r  \
 --cblvl  0  100 10 \
 --cntlvl 0  100 10 \
 --cbu    Sv       \
 --cbext  both     \
 --llonce 0 \
 --ft     'Barotropic stream function' \
 --spfid  "a) REF (2009-2018)" "b) PERT (y90-100)" \
 --sp     2x1 \
 -o       fig08 \
 -p       south_ocean \
 --joffset -2

set +x
