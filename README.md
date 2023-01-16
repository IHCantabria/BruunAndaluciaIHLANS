# Aplicación del modelo IH-LANS a la costa Andaluza para el proyecto Bruun Andalucia 

![Versión del código](https://img.shields.io/badge/Version-0.0.1-brightgreen)
https://img.shields.io/github/repo-size/IHCantabria/BruunAndaluciaIHLANS
![Grupo IH](https://img.shields.io/badge/Grupo-Costas-blue)
![](https://img.shields.io/badge/%C2%BFDudas%3F-M%C3%A1ndame%20un%20correo-orange) <lucas.defreitas@unican.es>

El objetivo de este repositorio es compartir los códigos utilizados para la aplicación del modelo IH-LANS (Álvarez-Cuesta et Al. 2021) a la playa de Fuengirola en Málaga, como parte del proyecto del efecto de Bruun en la costa Andaluza.

## Organización del repositorio y metodología

El primer paso, para trabajar en tu repositorio local es cambiar las rutas en el script "init.m": 
  - **WrkDir** = ubicación del **repositório local**.
  
Luego, el usuario debe seguir el orden de los scripts (a, b, c d):
  - **a_preparaMedicionesLC.m**: Separa las mediciones disponibles de los datos de COSTSAT para la zona deseada;
  - **b_preparaTransectas.m**: Prepara el dominio numerico a utilizar en el IH-LANS, interpolando linealmente las mediciones para los transectos sin mediciones disponibles;
  - **c_calculaPendientesDean.m**: Ajuste perfiles de Dean para los transectos definidos;
  - **d_runLANS.m**: Genera el INPUT del IH-LANS y llama el modelo.
  
### Notas de los autores

1. El usuario debe tener el modelo IH-LANS, del grupo de Clima, para poder utilizar este repositorio.

### Referencias

Alvarez-Cuesta, M., Toimil, A., Losada, I.J., 2021. Modelling long-term shoreline evolution in highly anthropized coastal areas. Part 1: Model description and validation. Coastal Engineering 169. https://doi.org/10.1016/J.COASTALENG.2021.103960
