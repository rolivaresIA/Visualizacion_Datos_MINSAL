## Visualización de Datos MINEDUC

Como se mencionó en la descripción del proyecto:

La presente evaluación técnica tiene como objetivo medir el manejo y tratamiento de bases de datos, el conocimiento en materias de educación y la capacidad de análisis que poseen los postulantes al cargo Profesional Analista en la Unidad de Ciencia de Datos del Centro de Estudios del Ministerio de Educación.

Esta prueba técnica debe desarrollarla utilizando el lenguaje de programación R y Powerbi. Se recomienda leer detenidamente las siguientes instrucciones y los productos solicitados:

### Carga y exploración de datos
```r
    rendimiento <- read_csv("databases/rendimiento_2023.csv")
```
```r
    matricula <- read_csv2("databases/20240913_Matrícula_unica_2024_20240430_WEB.CSV")
```
    
### Procesamiento de datos y Cálculos principales:

**a) Numero de estudiantes desvinculados periodo 23-24**

Filtramos establecimientos particulares subvencionados para el respectivo año:

```r
    rendimiento_filtrado <- filter(rendimiento, COD_DEPE == 3 & AGNO == 2023)
```
```r
    matricula_filtrada <- filter(matricula, COD_DEPE == 3 & AGNO == 2024)
```
Los estudiantes Desvinculados, son aquellos que estaban presentes en la base de rendimiento de 2023 pero no aparecen en la matrícula de 2024. Para eso debemos hacer un **ANTIJOIN** entre ambas bases:

```r
    desvinculados <- anti_join(rendimiento_filtrado, matricula_filtrada, by = "MRUN")
```
```r
    numero_desvinculados <- nrow(desvinculados)
```
Entonces, el total de registros que están presentes en la base de rendimiento del año t-1 (2023), pero no aparecen en la base de matrícula del año t (2024), serían los estudiantes desvinculados en el periodo.

```r
    print(numero_desvinculados)
```
    ## [1] 348749

Hasta acá todo bien, pero luego de haber revisado con mayor detalle me doy cuenta que existen **MRUN** duplicados por lo que debemos eliminarlos, ya que existen estudiantes que están siendo contados más de una vez.

```r
    RUN_duplicados <- desvinculados %>%
      group_by(MRUN) %>%
      filter(n() > 1) %>%
      count()
```
    desvinculados <- desvinculados %>%
      distinct(MRUN, .keep_all = TRUE)

Por lo que el número real de estudiantes desvinculados es:

    numero_desvinculados_sin_duplicados <- nrow(desvinculados)

    print(numero_desvinculados_sin_duplicados)

    ## [1] 332766

**b) La matrícula teórica y la tasa de desvinculación por región**

**c) Presente los resultados por región en una tabla, indicando el
número de estudiantes desvinculados, la matrícula teórica y la tasa de
desvinculación**

Para hacer esto, primero debemos sumar la matrícula 2024 por Región:

    matricula_por_region <- matricula_filtrada %>%
      group_by(NOM_REG_RBD_A) %>%
      summarise(matricula_actual = n())

A su vez, debemos sumar los estudiantes desvinculados el 2024 por
Región:

    desvinculados_por_region <- desvinculados %>%
      group_by(NOM_REG_RBD_A) %>%
      summarise(desvinculados = n())

Luego unimos las tablas y creamos variables que nos enseñen la matrícula
teórica y la tasa de desvinculación:

    resultados_por_region <- matricula_por_region %>%
      left_join(desvinculados_por_region, by = "NOM_REG_RBD_A") %>% 
      mutate(matricula_teorica = matricula_actual + desvinculados,
             tasa_desvinculacion = (desvinculados / matricula_teorica) * 100)

**d) Presente en una tabla una desagregación distinta a por región (a su
elección), indicando el número de estudiantes desvinculados, la
matrícula teórica y la tasa de desvinculación.**

Aplicando la misma lógica anterior, debemos hacerlo pero esta vez con el
nombre del colegio (NOM\_RBD):

    matricula_por_colegio <- matricula_filtrada %>% 
      group_by(NOM_RBD) %>% 
      summarise(alumnos_matriculados = n())

    desvinculados_por_colegio <- desvinculados %>%
      group_by(NOM_RBD) %>%
      summarise(alumnos_desvinculados = n())

    resultados_por_colegio <- matricula_por_colegio %>%
      left_join(desvinculados_por_colegio, by = "NOM_RBD") %>% 
      mutate(matricula_teorica = alumnos_matriculados + alumnos_desvinculados,
             tasa_desvinculacion = (alumnos_desvinculados / matricula_teorica) * 100)

prueba\_tecnica\_mineduc
