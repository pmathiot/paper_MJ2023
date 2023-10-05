#!/bin/bash
set -x
CASE1=OPM026                         ; YEAR1=y2009.10y
CASE2=WOA2018_c3.0_d1.0_v19812010.5.2; YEAR2=y0001.1y
DIR=$CCCWORKDIR/VALSO/
python /ccc/workflash/cont003/gen6035/mathiotp/TOOLS/PyChart/pychart.py \
 --dir  ${DIR}  \
 --mapf eORCA025.L121-${CASE1}/eORCA025.L121-${CASE1}_${YEAR1}_gridT.nc \
        eORCA025.L121-${CASE2}/eORCA025.L121-${CASE2}_${YEAR2}_gridT.nc \
 --mapv    sosbs   \
 --mapjk  0        \
 --mapjt  1 1      \
 --mapsf  1 1      \
 --cbn    cmocean.cm.haline   \
 --cblvl  34.4 35.0 0.05 \
 --cbu    'g/kg'     \
 --cbext  both       \
 --llonce 0 \
 --ft     'Bottom Salinity' \
 --spfid  "(a) REF (2009-2018)" "(b) WOA2018" \
 --sp     2x1 \
 --mask   ${DIR}/eORCA025.L121-OPM026/eORCA025.L121-OPM026_mesh_mask.nc ${DIR}/eORCA025.L121-OPM026/eORCA025.L121-OPM026_mesh_mask.nc \
 --bathyf ${DIR}/eORCA025.L121-OPM026/eORCA025.L121-OPM026_mesh_mask.nc \
 --bathyv bathy_metry \
 --bathylvl 1000 2000 3000 4000  \
 -o       BOTS_${CASE1}_${CASE2} \
 -p       ant \
 --cbcmo \
 --joffset -2

python /ccc/workflash/cont003/gen6035/mathiotp/TOOLS/PyChart/pychart.py \
 --dir  ${DIR}  \
 --mapf    eORCA025.L121-${CASE1}/eORCA025.L121-${CASE1}_${YEAR1}_gridT.nc \
 --mapreff eORCA025.L121-${CASE2}/eORCA025.L121-${CASE2}_${YEAR2}_gridT.nc \
 --mapv    sosbs   \
 --maprefv sosbs   \
 --mapjk  0        \
 --mapsf  1        \
 --cbn    RdBu_r   \
 --cblvl  -0.3 0.3 0.05 \
 --cbu    'g/kg'     \
 --cbext  both       \
 --llonce 0 \
 --ft     'Bottom salinity differences' \
 --spfid  "(c) REF (2009-2018) - WOA2018" \
 --sp     2x1 \
 --mask   ${DIR}/eORCA025.L121-OPM026/eORCA025.L121-OPM026_mesh_mask.nc \
 --bathyf ${DIR}/eORCA025.L121-OPM026/eORCA025.L121-OPM026_mesh_mask.nc \
 --bathyv bathy_metry \
 --bathylvl 1000 2000 3000 4000  \
 -o       BOTS_${CASE1}-${CASE2} \
 -p       ant \
 --joffset -2

python /ccc/workflash/cont003/gen6035/mathiotp/TOOLS/PyChart/pychart.py \
 --dir  $DIR   \
 --mapf eORCA025.L121-${CASE1}/eORCA025.L121-${CASE1}_${YEAR1}_gridT.nc \
        eORCA025.L121-${CASE2}/eORCA025.L121-${CASE2}_${YEAR2}_gridT.nc \
 --mapv    sosbt     \
 --mapjk  0          \
 --mapjt  1 1      \
 --mapsf  1 1      \
 --cbn    cmocean.cm.thermal    \
 --cblvl  -2 1.6 0.4 \
 --cbu    'C'        \
 --cbext  both       \
 --llonce 0          \
 --mask   ${DIR}/eORCA025.L121-OPM026/eORCA025.L121-OPM026_mesh_mask.nc ${DIR}/eORCA025.L121-OPM026/eORCA025.L121-OPM026_mesh_mask.nc \
 --ft     'Bottom Temperature' \
 --spfid  "(d) REF (2009-2018)" "(e) WOA2018" \
 --sp     2x1 \
 -o       BOTT_${CASE1}_${CASE2} \
 -p       ant \
 --bathyf ${DIR}/eORCA025.L121-OPM026/eORCA025.L121-OPM026_mesh_mask.nc \
 --bathyv bathy_metry \
 --bathylvl 1000 2000 3000 4000  \
  --cbcmo \
 --joffset -2


python /ccc/workflash/cont003/gen6035/mathiotp/TOOLS/PyChart/pychart.py \
 --dir  $DIR   \
 --mapf    eORCA025.L121-${CASE1}/eORCA025.L121-${CASE1}_${YEAR1}_gridT.nc \
 --mapreff eORCA025.L121-${CASE2}/eORCA025.L121-${CASE2}_${YEAR2}_gridT.nc \
 --mapv    sosbt     \
 --maprefv    sosbt     \
 --mapjk  0          \
 --mapsf  1          \
 --cbn    RdBu_r     \
 --cblvl  -1 1 0.2   \
 --cbu    'C'        \
 --cbext  both       \
 --llonce 0          \
 --mask   ${DIR}/eORCA025.L121-OPM026/eORCA025.L121-OPM026_mesh_mask.nc ${DIR}/eORCA025.L121-OPM026/eORCA025.L121-OPM026_mesh_mask.nc \
 --ft     'Bottom Temperature difference' \
 --spfid  "(f) REF (2009-2018) - WOA2018" \
 --sp     2x1 \
 -o       BOTT_${CASE1}-${CASE2} \
 -p       ant \
 --bathyf ${DIR}/eORCA025.L121-OPM026/eORCA025.L121-OPM026_mesh_mask.nc \
 --bathyv bathy_metry \
 --bathylvl 1000 2000 3000 4000  \
 --joffset -2

convert \( BOTS_${CASE1}_${CASE2}.png BOTS_${CASE1}-${CASE2}.png +append \)  \
        \( BOTT_${CASE1}_${CASE2}.png BOTT_${CASE1}-${CASE2}.png +append \) -append -trim -bordercolor White -border 40 fig04.png
