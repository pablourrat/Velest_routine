#! /bin/bash

new_velest_cmn(){
        ito=$1
        echo "Para la siguiente iteración quiere realizar algun cambio en los archivos de entradas? (y/n)"
        read respuesta
        if [ "$respuesta" != "y" ]; then
                return
        fi
        valor=true
        while $valor; do
cat << EOF
Selecion un de los archivos a cambiar para la siguiente iteracion de Velest:
Recuerde que solo debe escribir un numero

1) ¿Utilizar modelo de velocidad de salida?
2) ¿Utilizar estaciones de salida?
3) ¿Utilizar hipocentros de salida?
4) ¿Modificar Vp/Vs?

EOF
read respuesta
                
                case $respuesta in
                     1)
                        cambio="modelo"
                        echo "Cambios"
                        modelo_input_previo=$(awk 'NR==41 {print $0}' velest.cmn)
                        modelo_input=$(printf "m_%02d.mod" "$ito")
                        modelo_input_previo_change=$(echo $2 | sed 's/out/mod/')
                        echo "$2 -> $modelo_input"
                        cp $2 $modelo_input
                        vpvs=$(grep -A1 "vpvs" velest.cmn | awk 'NR==2 {print $3}')
                        station_input=$(printf "s_%02d.sta" "$ito")
                        station_input_previo=$(awk 'NR==44 {print $0}' velest.cmn)
                        echo "$station_input_previo -> $station_input"
                        cp $station_input_previo $station_input
                        hypo_input=$(printf "h_%02d.cnv" "$ito")
                        hypo_input_previo=$(awk 'NR==64 {print $0}' velest.cmn)
                        echo "$hypo_input_previo -> $hypo_input"
                        cp $hypo_input_previo $hypo_input                        
                        valor=false
                        ;;
                     2)
                        cambio="sta"
                        echo "Cambios"
                        station_input=$(printf "s_%02d.sta" "$ito")
                        station_input_previo_change=$(awk 'NR==81 {print $0}' velest.cmn)
                        station_input_previo=$(echo $station_input_previo_change | sed 's/out/sta/g')
                        echo "$station_input_previo_change -> $station_input"
                        cp $station_input_previo_change $station_input
                        vpvs=$(grep -A1 "vpvs" velest.cmn | awk 'NR==2 {print $3}')
                        modelo_input_previo=$(awk 'NR==41 {print $0}' velest.cmn)
                        modelo_input=$(printf "m_%02d.mod" "$ito")
                        cp $modelo_input_previo $modelo_input
                        echo "$modelo_input_previo -> $modelo_input"
                        hypo_input=$(printf "h_%02d.cnv" "$ito")
                        hypo_input_previo=$(awk 'NR==64 {print $0}' velest.cmn)
                        cp $hypo_input_previo $hypo_input                        
                        echo "$hypo_input_previo -> $hypo_input"
                        valor=false
                        ;;
                     3)
                        cambio="hypo"                 
                        vpvs=$(grep -A1 "vpvs" velest.cmn | awk 'NR==2 {print $3}')
                        echo "Cambios"
                        hypo_input=$(printf "h_%02d.cnv" "$ito")
                        hypo_input_previo_change=$(awk 'NR==78 {print $0}' velest.cmn)
                        hypo_input_previo=$(echo $hypo_input_previo_change | sed 's/out/cnv/g')
                        echo "$hypo_input_previo_change -> $hypo_input"
                        cp $hypo_input_previo_change $hypo_input                      

                        station_input=$(printf "s_%02d.sta" "$ito")
                        station_input_previo=$(awk 'NR==44 {print $0}' velest.cmn)
                        cp $station_input_previo $station_input
                        echo "$station_input_previo -> $station_input"
                        
                        modelo_input_previo=$(awk 'NR==41 {print $0}' velest.cmn)
                        modelo_input=$(printf "m_%02d.mod" "$ito")
                        cp $modelo_input_previo $modelo_input
                        echo "$modelo_input_previo -> $modelo_input"
                        valor=false
                        ;;
                        
                     4)
                        echo "Ingrese el valor del nuevo vpvs a utilizar"
                        read vpvs
                        cambio="vpvs" 
                        echo "Cambios"
                        modelo_input_previo=$(awk 'NR==41 {print $0}' velest.cmn)
                        modelo_input=$(printf "m_%02d.mod" "$ito")
                        cp $modelo_input_previo $modelo_input                        
                        echo "$modelo_input_previo -> $modelo_input"
                        station_input=$(printf "s_%02d.sta" "$ito")
                        station_input_previo=$(awk 'NR==44 {print $0}' velest.cmn)
                        cp $station_input_previo $station_input
                        echo "cp $station_input_previo -> $station_input"
                        hypo_input=$(printf "h_%02d.cnv" "$ito")
                        hypo_input_previo=$(awk 'NR==64 {print $0}' velest.cmn)
                        cp $hypo_input_previo $hypo_input
                        echo "$hypo_input_previo -> $hypo_input"
                        valor=false
                        ;;
                        
                     *)
                        echo "Número no válido. Debes ingresar un número del 1 al 4."
                        ;;
                esac
        done
        echo "$modelo_input_previo $station_input_previo $hypo_input_previo $3"
        mv $modelo_input_previo $station_input_previo $hypo_input_previo $3
        awk -i inplace -v vel="$modelo_input" 'NR==41 {$0=vel} 1' velest.cmn 
        awk -i inplace -v hypopre="$hypo_input" 'NR==64 {$0=hypopre} 1' velest.cmn 
        awk -i inplace -v stapre="$station_input" 'NR==44 {$0=stapre} 1' velest.cmn
        awk -i inplace -v vpvs="$vpvs" 'NR==23 {$0="     2      0.50    " vpvs "        1"} 1' velest.cmn
        ((ite = ito-1))
        main_output=$(printf "main_%02d.out" "$ite")
        station_output=$(printf "s_%02d.out" "$ite")
        hypo_output=$(printf "h_%02d.out" "$ite")
        modelo_output=$(printf "m_%02d.out" "$ite")
        sumary_output=$(printf "summary_plot_%02d.out" "$ite")
        echo "$main_output $station_output $hypo_output $modelo_output $sumary_output $3"
        mv $main_output $station_output $hypo_output $modelo_output $sumary_output $3
        main_output=$(printf "main_%02d.out" "$ito")
        station_output=$(printf "s_%02d.out" "$ito")
        hypo_output=$(printf "h_%02d.out" "$ito")
        modelo_output=$(printf "m_%02d.out" "$ito")
        sumary_output=$(printf "summary_plot_%02d.out" "$ito")
        #modificar velest.cmn con outputs nuevos
        awk -i inplace -v vel="$main_output" 'NR==72 {$0=vel} 1' velest.cmn 
        awk -i inplace -v hypopre="$hypo_output" 'NR==78 {$0=hypopre} 1' velest.cmn
        awk -i inplace -v stapre="$station_output" 'NR==81 {$0=stapre} 1' velest.cmn
        awk -i inplace -v stapre="$sumary_output" 'NR==84 {$0=stapre} 1' velest.cmn  
        echo $it $modelo_input $station_input $hypo_input $vpvs $modelo_output $station_output $hypo_output $main_output $cambio >> $log          
}


# Variable para el cilo while
next_iteration=true
cp velest_ori.cmn velest.cmn
it=1 # iterador
log='log_progress'
cambio="nada"
echo "Escriba nombre de los archivos de entrada"
echo "Modelo de velocidad:"
read vel_ori
echo "Estaciones"
read esta_ori
echo "Hipocentros"
read hypo_ori
echo "Vp/Vs"
read vpvs_ori
echo "Escriba nombre de directorio de trabajo (agregar / al final)"
read dir_name
if [ -d "$dir_name" ]; then
  rm -r "$dir_name"
fi
mkdir $dir_name

#variables de entrada
vpvs=$(echo $vpvs_ori) #$(grep -A1 "vpvs" velest.cmn | awk 'NR==2 {print $3}')
neqs=$(grep -c "^[0-9]" $hypo_ori)
#modelo de velocidad
echo "Respaldo inicial"
modelo_input_previo=$(echo $vel_ori) #$(awk 'NR==41 {print $0}' velest.cmn | tr -d '\r')
modelo_input=$(printf "m_%02d.mod" "$it")
echo "$modelo_input_previo -> $modelo_input"
cp $modelo_input_previo $modelo_input

#estaciones
station_input=$(printf "s_%02d.sta" "$it")
station_input_previo=$(echo $esta_ori) #$(awk 'NR==44 {print $0}' velest.cmn | tr -d '\r')
echo "$station_input_previo -> $station_input"
cp $station_input_previo $station_input
#hipocentros
hypo_input=$(printf "h_%02d.cnv" "$it")
hypo_input_previo=$(echo $hypo_ori) #$(awk 'NR==64 {print $0}' velest.cmn | tr -d '\r')
echo "$hypo_input_previo -> $hypo_input"
cp $hypo_input_previo $hypo_input

#Imprimir nombre de archivos originales a usar
cat << EOF
Los archivos que se usan esta vez son:

Modelo de velocidad: $vel_ori --> $modelo_input
Archivo de estaciones: $esta_ori --> $station_input
Archivo de hipocentros: $hypo_ori --> $hypo_input
EOF

#modificar velest.cmn con inputs nuevos
awk -i inplace -v vel="$modelo_input" 'NR==41 {$0=vel} 1' velest.cmn 
awk -i inplace -v hypopre="$hypo_input" 'NR==64 {$0=hypopre} 1' velest.cmn 
awk -i inplace -v stapre="$station_input" 'NR==44 {$0=stapre} 1' velest.cmn 
awk -i inplace -v vpvs="$vpvs" 'NR==23 {$0="     2      0.50    " vpvs "        1"} 1' velest.cmn
awk -i inplace -v neqs="$neqs" 'NR==14 {$0="     "neqs"      0      0.0"} 1' velest.cmn
#variables de salida
main_output=$(printf "main_%02d.out" "$it")
station_output=$(printf "s_%02d.out" "$it")
hypo_output=$(printf "h_%02d.out" "$it")
modelo_output=$(printf "m_%02d.out" "$it")
sumary_output=$(printf "summary_plot_%02d.out" "$it")
#modificar velest.cmn con outputs nuevos
awk -i inplace -v vel="$main_output" 'NR==72 {$0=vel} 1' velest.cmn 
awk -i inplace -v hypopre="$hypo_output" 'NR==78 {$0=hypopre} 1' velest.cmn #g201214A.cnv
awk -i inplace -v stapre="$station_output" 'NR==81 {$0=stapre} 1' velest.cmn # copahue.sta
awk -i inplace -v stapre="$sumary_output" 'NR==84 {$0=stapre} 1' velest.cmn # copahue.sta

if [ -f "$log" ]; then
  rm -f "$log"
fi

echo "It vel_input sta_input hypo_input vpvs vel_output sta_out hypo_output main_output cambio" > $log
echo $it $modelo_input $station_input $hypo_input $vpvs $modelo_output $station_output $hypo_output $main_output $cambio >> $log

while $next_iteration; do
  echo "¿comenzar la iteración $it? (y/n)"
  read respuesta
  if [ "$respuesta" != "y" ]; then
        break
  else
        # Primer paso del script es correr Velest
        ./velest
        echo "Velest ha finalizado"
        echo "Los archivos de salida son:"        # Segundo paso, extraer valores de RMS del archivo principal
        echo $main_output
        echo $modelo_output
        echo $station_output
        echo $hypo_output
        residual_file=$(printf "residual_plot_%02d.out" "$it")
        gawk -f extr_res < $main_output > $residual_file
        echo "Residuales extraidos"
        # Tercer paso, extrare los modelos de velocidad crear archivo copahue_out.mod y Velocity_models.txt
        ./Extract_velocity_model.sh $modelo_input $modelo_output $main_output $it
        echo "Modelos de velocidad extraidos"
        # Cuarto paso, generar figuras de modelos de velocidad de entrada y salidad, RMS y VpVs ratio
        python plot_velest.py
        velo_models=$(printf "Velocity_models_%02d.out" "$it")
        echo "Figuras creadas"
        
        

  fi

  # consulta para repetir el modelo 
  echo "¿Desea continuar la siguiente iteración? (y/n)"
  read respuesta
  
  # Cambiar el valor de next_iteration
  if [ "$respuesta" != "y" ]; then
    next_iteration=false
  else
    next_iteration=true
    ((it = it + 1))
    new_velest_cmn $it $modelo_output $dir_name
    
  fi
done
mv residual_plot*.out Velocity_models*.out $dir_name
mv *.png $dir_name
mv m_* main_* h_* s_* summary_plot* $dir_name

