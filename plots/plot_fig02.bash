#!/bin/bash
set -x
CASE1=OPM026
CASE2=OPM031

python /ccc/workflash/cont003/gen6035/mathiotp/TOOLS/PyChart/pychart.py \
 --mapf  eORCA025.L121-${CASE1}/eORCA025.L121-${CASE1}_10y_y2009_psi.nc \
 --cntf  eORCA025.L121-${CASE1}/eORCA025.L121-${CASE1}_10y_y2009_psi.nc \
 --mapv   sobarstf \
 --cntv   sobarstf \
 --mapjk  0        \
 --mapsf  0.000001 \
 --cntsf  0.000001 \
 --cbn    gist_heat_r  \
 --cblvl  0  60 5 \
 --cntlvl 0  60 5 \
 --cbu    Sv       \
 --cbext  both     \
 --llonce 0 \
 --ft     'Barotropic stream function' \
 --spfid  "REF (2009-2018)" \
 --sp     2x1 \
 -o       fig02 \
 -p       south_ocean \
 --joffset -2


set +x

