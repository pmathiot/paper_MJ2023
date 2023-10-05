#!/bin/bash

KEY=MJ2023
FREQ=1y
RUNIDS=${@:3}

. ~/.bashrc
. PARAM/param_arch.bash
load_python

# FRIS
echo 'plot total FRIS time series'
python SCRIPT/plot_time_series.py -noshow -runid $RUNIDS -f ISF_ALL*${FREQ}*.nc -var '(isfmelt_FRIS)' -title "a) FRIS total melt (Gt/y)" -sf -1.0 -dir ${WRKPATH} -o ${KEY}_fig06
if [[ $? -ne 0 ]]; then exit 42; fi

# ROSS
echo 'plot total ROSS melt time series'
python SCRIPT/plot_time_series.py -noshow -runid $RUNIDS -f ISF_ALL*${FREQ}*.nc -var '(isfmelt_ROSS)' -title "b) ROSS total melt (Gt/y)"  -sf -1.0 -dir ${WRKPATH} -o ${KEY}_fig07
if [[ $? -ne 0 ]]; then exit 42; fi

# PINE
echo 'plot total PINE G melt time series'
python SCRIPT/plot_time_series.py -noshow -runid $RUNIDS -f ISF_ALL*${FREQ}*.nc.PIGandTwaites -var '(isfmelt_PIGandTwaites)' -title "c) PIG and Twaites total melt (Gt/y)"   -sf -1.0 -dir ${WRKPATH} -o ${KEY}_fig08
if [[ $? -ne 0 ]]; then exit 42; fi


# crop figure (rm legend)
for figid in {06..08}; do
   convert ${KEY}_fig${figid}.png -crop 1240x1040+0+0 tmp${figid}.png
done

# trim figure (remove white area)
convert legend.png      -trim -bordercolor White -border 20 tmp13.png

# compose the image
convert  \( tmp06.png tmp07.png tmp08.png +append \) \
           tmp13.png -append -trim -bordercolor White -border 40 fig13.png

# save figure
mv ${KEY}_*.png FIGURES/.
mv ${KEY}_*.txt FIGURES/.
mv tmp13.png FIGURES/${KEY}_legend.png

# clean
rm tmp??.png
