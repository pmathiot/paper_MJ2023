#!/bin/bash

KEY=MJ2023
FREQ=1y
RUNIDS='eORCA025.L121-OPM026 eORCA025.L121-OPM031 eORCA025.L121-OPM000'

. ~/.bashrc
. PARAM/param_arch.bash
load_python

# ACC
# Drake
echo 'plot ACC time series'
python SCRIPT/plot_time_series.py -noshow -runid $RUNIDS -f *ACC*${FREQ}*.nc -var vtrp -sf -1 -title "c) ACC transport (Sv)" -dir ${WRKPATH} -o "${KEY}_fig03"
if [[ $? -ne 0 ]]; then exit 42; fi

# ROSS GYRE
echo 'plot Ross Gyre time series'
python SCRIPT/plot_time_series.py -noshow -runid $RUNIDS -f *RG*${FREQ}*psi.nc -var max_sobarstf -title "b) Ross Gyre (Sv)" -dir ${WRKPATH} -o ${KEY}_fig02 -sf 0.000001
if [[ $? -ne 0 ]]; then exit 42; fi

# WED GYRE
echo 'plot Weddell Gyre time series'
python SCRIPT/plot_time_series.py -noshow -runid $RUNIDS -f *WG*${FREQ}*psi.nc -var max_sobarstf -title "a) Weddell Gyre (Sv)" -dir ${WRKPATH} -o ${KEY}_fig01 -sf 0.000001
if [[ $? -ne 0 ]]; then exit 42; fi

# crop figure (rm legend)
for figid in {01..03}; do
   convert ${KEY}_fig${figid}.png -crop 1240x1040+0+0 tmp${figid}.png
done

# trim figure (remove white area)
convert legend.png      -trim -bordercolor White -border 20 tmp04.png

# compose the image
convert \( tmp01.png tmp02.png tmp03.png +append \) \
           tmp04.png -append -trim -bordercolor White -border 40 fig07.png

# save figure
mv ${KEY}_*.png FIGURES/.
mv ${KEY}_*.txt FIGURES/.
mv tmp04.png FIGURES/${KEY}_legend.png

# clean
rm tmp??.png
