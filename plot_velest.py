import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import glob

# plot de RMS del proceso
residuales = sorted(glob.glob('residual_plot*.out'))
residual = np.loadtxt(residuales[-1])
modelos = sorted(glob.glob('Velocity_models*.out'))
models = pd.read_csv(modelos[-1],sep=' ')
modelo = str(modelos[-1])

iteracion=modelo.split('.out')[0].split('_')[-1]

ite,rms = residual[:,0],residual[:,1]
plt.plot(ite,rms,'s-')
plt.xlabel('# iteraciones')
plt.ylabel('RMS')
plt.title('RMS Velest Generacion: '+iteracion)
plt.savefig('RMS_plot_'+iteracion+'.png',dpi=100)

# plot RMS general 
# Crear una figura para el gráfico
plt.figure()

# Desplazamiento inicial para ajustar las iteraciones
desplazamiento = 0

# Recorrer cada archivo en la lista
for i, archivo in enumerate(residuales):
     # Cargar los datos del archivo
    residual = np.loadtxt(archivo)
    ite, rms = residual[:, 0], residual[:, 1]

    # Ajustar las iteraciones para cada archivo
    ite += desplazamiento

    # Encontrar el índice del mínimo valor RMS
    min_rms_idx = np.argmin(rms)
    min_rms_val = rms[min_rms_idx]

    # Agregar los datos al gráfico
    plt.plot(ite, rms, 'ks-', label=f'Generación {i + 1}')

    # Agregar círculo azul en el mínimo valor RMS
    plt.plot(ite[min_rms_idx], min_rms_val, 'bo')

    # Agregar texto sobre el círculo azul con el valor RMS
    plt.annotate(f'RMS: {min_rms_val:.2f}', xy=(ite[min_rms_idx], min_rms_val), xytext=(ite[min_rms_idx]-1 , min_rms_val+5),
                 arrowprops=dict(facecolor='black', arrowstyle='->'), fontsize=10, ha='center')

    # Actualizar el desplazamiento para el siguiente archivo
    desplazamiento = ite[-1]

# Agregar leyendas y etiquetas
plt.xlabel('Iteraciones')
plt.ylabel('RMS')
plt.legend()
plt.savefig('RMS_total.png',dpi=150)
# Configurar subplots 
fig, axes = plt.subplots(ncols=3, figsize=(12,5))
for ax in axes:
    ax.invert_yaxis()
    ax.xaxis.tick_top()
    ax.xaxis.set_label_position('top')

# Gráfico 1: Vp
axes[0].step(models['Vp_ori'], models['depth_P_ori'], label='Vp input')  
axes[0].step(models['Vp_new'], models['depth_P_new'], label='Vp velest')
axes[0].set_ylabel('Profundidad')
axes[0].set_xlabel('Vp')
axes[0].legend()

# Gráfico 2: Vs
axes[1].step(models['Vs_ori'], models['depth_S_ori'], label='Vs input')
axes[1].step(models['Vs_new'], models['depth_S_new'], label='Vs velest')
axes[1].set_ylabel('Profundidad')
axes[1].set_xlabel('Vs')
axes[1].legend()  

# Gráfico 3: VpVs
vpvs_ori = models['Vp_ori'] / models['Vs_ori'] 
vpvs_new = models['Vp_new'] / models['Vs_new']
axes[2].step(vpvs_ori, models['depth_P_ori'], label='VpVs input')  
axes[2].step(vpvs_new, models['depth_P_new'], label='VpVs velest')
axes[2].set_ylabel('Profundidad')
axes[2].set_xlabel('Vp/Vs')
axes[2].legend()

plt.tight_layout() 
plt.savefig('Modelo_velocidad_'+iteracion+'.png',dpi=100)
