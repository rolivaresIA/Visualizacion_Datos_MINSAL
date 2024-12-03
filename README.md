# Visualizacion de Datos con Power BI

## 📝 Contexto
En el ámbito profesional, enfrentarse a pruebas técnicas es una experiencia común para los candidatos en roles relacionados con análisis de datos y programación. Estas pruebas, diseñadas para evaluar habilidades prácticas, suelen incluir tareas como desarrollar gráficos interactivos y analizar bases de datos. 

Este proyecto surge de una prueba técnica realizada para el Ministerio de Educación de Chile (MINEDUC), en la que se evaluaron mis habilidades en programación con R y visualización de datos mediante Power BI enfocándose en la desvinculación de estudiantes en establecimientos particulares subvencionados. La intención de compartir este proyecto en GitHub es mostrar cómo abordar este tipo de desafíos, aplicando buenas prácticas en análisis y visualización de datos.

![](images/Logo_del_Ministerio_de_Educación_Chile1.jpg)

## 📋 Descripción del Proyecto
El proyecto consiste en una serie de análisis enfocados en responder preguntas específicas sobre desvinculación escolar, utilizando datos reales del sistema educativo chileno. La metodología incluye:

- Procesamiento y análisis de bases de datos en R.
- Cálculos de métricas clave como matrícula teórica, número de estudiantes desvinculados y tasas de desvinculación por región.
- Creación de visualizaciones interactivas en Power BI para una mejor interpretación de los resultados.
- Propuesta de acciones basadas en los hallazgos, utilizando principios de análisis descriptivo y predictivo.

Es por esto, que la ruta correcta para ver este proyecto es:

1. En la carpeta **pdf** se presenta la [Evaluación Técnica](pdf/Evaluación_Técnica-Analista_UCD.pdf) con sus respectivas actividades.
2. Obtención de bases de datos: Una vez entendida la actividad, descargamos las bases del siguiente [link](https://drive.google.com/drive/folders/1DT-R1INN3gBh_n6K-IE5SXYyp9DMSnBl?usp=drive_link).
3. Procesamiento, análisis y cálculo de métricas solicitadas se pueden ver con detalle en el archivo [README](prueba_tecnica_mineduc.md) y de manera complementaria se puede descargar el [script](script/script_respaldo.R).
4. Análisis del panel o gráficos interactivos a través del archivo [.pbix](https://drive.google.com/file/d/1X59fU3MQ7g4r2e_skXa94bGQQTQVifbx/view?usp=drive_link) de Power BI.
5. Análisis descriptivo y propuestas de acciones en el archivo de [Análisis_Descriptivo_Datos.pdf](pdf/Análisis_Descriptivo_Datos.pdf).

## 🎯 Ojetivo del Proyecto
El objetivo de este proyecto es analizar y visualizar datos relacionados con la desvinculación escolar en establecimientos particulares subvencionados de Chile, utilizando herramientas como R y Power BI para extraer métricas clave, generar visualizaciones interactivas y proponer acciones basadas en los hallazgos.

![](images/visualizador.png)
![](images/visualizador2.png)

## 💡 Desarrollo del Proyecto
El proyecto se desarrolló en las siguientes fases:

**Fase 1: Carga y exploración de datos**
- Importación de dos bases de datos en formato CSV: Matrícula Oficial 2023 (completa) y Rendimiento 2023 (establecimientos particulares subvencionados).
- Revisión del libro de códigos en formato PDF para comprender las variables disponibles.
- Exploración inicial de los datos para identificar inconsistencias y valores nulos.
  
**Fase 2: Procesamiento de datos**

Cálculos principales:
- Número de estudiantes desvinculados (2023-2024).
- Matrícula teórica y tasa de desvinculación por región.
- Desagregación adicional según criterio seleccionado.
- Procesamiento de los datos en R para obtener tablas resumen y métricas clave.

**Fase 3: Visualización en Power BI**

Creación de un dashboard interactivo que incluye:
- Gráfico de barras con estudiantes desvinculados por región.
- Gráfico con porcentajes de desvinculación por región.
- Segmentador de datos y tarjetas con métricas clave para explorar información de forma dinámica.

**Fase 4: Análisis descriptivo**
- Análisis de las regiones más afectadas por la desvinculación, explorando posibles razones detrás de los resultados.
- Discusión sobre variables relevantes y técnicas predictivas aplicables al problema, incluyendo posibles limitaciones de los datos disponibles.
  
**Fase 5: Propuesta de políticas públicas**
- Priorización de tres medidas para reducir la desvinculación escolar, basadas en los hallazgos del análisis.
