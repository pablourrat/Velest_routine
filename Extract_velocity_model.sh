#! /bin/bash

# este script necesita de entrada el modelo de velocidad de entrada al velest y el archivo principal de salida
# $1: nombre archivo modelo de velocidad input del velest
# $2: nombre para archivo de salida de modelo de velocidad
# $3: archivo principal de salidad de velest
# $4: iteracion usado
export LC_NUMERIC="C"

input_model=$1
echo $1 $2 $3
velfile=$2 # $(echo ${input_model} | sed 's/\.mod/\.out/g')
nlayers=$(cat ${input_model} | grep "vel" | awk '{print $1}' | head -1)
Pmodel="P-VELOCITY MODEL"
Smodel="S-VELOCITY MODEL"
if [ -f "$velfile" ]; then
        rm -f ${velfile}
fi

echo "Fill with the first line of velocity model file" > ${velfile}
echo " ${nlayers}        vel,depth,vdamp,phase (f5.2,5x,f7.2,2x,f7.3,3x,a1)" >> ${velfile}

primera_linea=true
cat $3 | grep -A12 "Velocity model   1" | tail -12 | awk '{print $1, $3, 01.000}' | while read -r valor1 valor2 valor3; do
    if $primera_linea; then
        printf "%5.2f%5s%7.2f%2s%07.3f%11s%s\n" "$valor1" "" "$valor2" "" "$valor3" "" "$Pmodel" >> ${velfile}
        primera_linea=false
    else
        printf "%5.2f%5s%7.2f%2s%07.3f\n" "$valor1" "" "$valor2" "" "$valor3" >> ${velfile}
    fi
done
# para crear Velocidad
primera_linea=true
echo " ${nlayers}        vel,depth,vdamp,phase (f5.2,5x,f7.2,2x,f7.3,3x,a1)" >> ${velfile}
cat $3 | grep -A12 "Velocity model   2" | tail -12 | awk '{print $1, $3, 01.000}' | while read -r valor1 valor2 valor3; do
    if $primera_linea; then
        printf "%5.2f%5s%7.2f%2s%07.3f%11s%s\n" "$valor1" "" "$valor2" "" "$valor3" "" "$Smodel" >> ${velfile}
        primera_linea=false
    else
        printf "%5.2f%5s%7.2f%2s%07.3f\n" "$valor1" "" "$valor2" "" "$valor3" >> ${velfile}
    fi
done
velmodels=$(printf "Velocity_models_%02d.out" "$4")
echo 'Vp_ori depth_P_ori Vs_ori depth_S_ori Vp_new depth_P_new Vs_new depth_S_new' > $velmodels
cat copahue.mod | grep -A11 'P-VELOCITY MODEL' | awk '{print $1,$2}' > ori_p
cat copahue.mod | grep -A11 'S-VELOCITY MODEL' | awk '{print $1,$2}' > ori_s
cat ${velfile} | grep -A11 'P-VELOCITY MODEL' | awk '{print $1,$2}' > new_p
cat ${velfile} | grep -A11 'S-VELOCITY MODEL' | awk '{print $1,$2}' > new_s

paste -d ' ' ori_p ori_s new_p new_s >> $velmodels
rm -r ori_p ori_s new_p new_s
