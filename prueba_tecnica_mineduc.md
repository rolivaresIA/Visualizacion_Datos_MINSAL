## Visualización de Datos MINEDUC

Como se mencionó en la descripción del proyecto:

La presente evaluación técnica tiene como objetivo medir el manejo y
tratamiento de bases de datos, el conocimiento en materias de educación
y la capacidad de análisis que poseen los postulantes al cargo
Profesional Analista en la Unidad de Ciencia de Datos del Centro de
Estudios del Ministerio de Educación.

Esta prueba técnica debe desarrollarla utilizando el lenguaje de
programación R y Powerbi. Se recomienda leer detenidamente las
siguientes instrucciones y los productos solicitados:

### Carga y exploración de datos

    rendimiento <- read_csv("databases/rendimiento_2023.csv")

    ## Rows: 1935785 Columns: 37
    ## ── Column specification ──────────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr  (8): NOM_RBD, NOM_REG_RBD_A, NOM_COM_RBD, NOM_DEPROV_RBD, LET_CUR, NOM_COM_ALU, SIT_FIN, SIT_FIN_R
    ## dbl (28): AGNO, RBD, DGV_RBD, COD_REG_RBD, COD_PRO_RBD, COD_COM_RBD, COD_DEPROV_RBD, COD_DEPE, COD_DEP...
    ## num  (1): PROM_GRAL
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    matricula <- read_csv2("databases/20240913_Matrícula_unica_2024_20240430_WEB.CSV")

    ## ℹ Using "','" as decimal and "'.'" as grouping mark. Use `read_delim()` for more control.

    ## Rows: 3582943 Columns: 37
    ## ── Column specification ──────────────────────────────────────────────────────────────────────────────────
    ## Delimiter: ";"
    ## chr  (7): NOM_RBD, NOM_REG_RBD_A, NOM_COM_RBD, NOM_DEPROV_RBD, NOMBRE_SLEP, LET_CUR, NOM_COM_ALU
    ## dbl (30): AGNO, RBD, DGV_RBD, COD_REG_RBD, COD_PRO_RBD, COD_COM_RBD, COD_DEPROV_RBD, COD_DEPE, COD_DEP...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

### Procesamiento de datos y Cálculos principales:

**a) Numero de estudiantes desvinculados periodo 23-24**

Filtramos establecimientos particulares subvencionados para el
respectivo año:

    rendimiento_filtrado <- filter(rendimiento, COD_DEPE == 3 & AGNO == 2023)

    matricula_filtrada <- filter(matricula, COD_DEPE == 3 & AGNO == 2024)

Los estudiantes Desvinculados, son aquellos que estaban presentes en la
base de rendimiento de 2023 pero no aparecen en la matrícula de 2024.
Para eso debemos hacer un **ANTIJOIN** entre ambas bases:

    desvinculados <- anti_join(rendimiento_filtrado, matricula_filtrada, by = "MRUN")

    numero_desvinculados <- nrow(desvinculados)

Entonces, el total de registros que están presentes en la base de
rendimiento del año t-1 (2023), pero no aparecen en la base de matrícula
del año t (2024), serían los estudiantes desvinculados en el periodo.

    print(numero_desvinculados)

    ## [1] 348749

Hasta acá todo bien, pero luego de haber revisado con mayor detalle me
doy cuenta que existen **MRUN** duplicados por lo que debemos
eliminarlos, ya que existen estudiantes que están siendo contados más de
una vez.

    RUN_duplicados <- desvinculados %>%
      group_by(MRUN) %>%
      filter(n() > 1) %>%
      count()

    print(RUN_duplicados)

    ## # A tibble: 14,885 × 2
    ## # Groups:   MRUN [14,885]
    ##     MRUN     n
    ##    <dbl> <int>
    ##  1  2134     2
    ##  2  2308     2
    ##  3  2538     2
    ##  4  3118     2
    ##  5  4550     2
    ##  6  7508     2
    ##  7  9398     2
    ##  8 10624     2
    ##  9 13859     2
    ## 10 14606     2
    ## # ℹ 14,875 more rows

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

    print(matricula_por_region)

    ## # A tibble: 16 × 2
    ##    NOM_REG_RBD_A matricula_actual
    ##    <chr>                    <int>
    ##  1 ANTOF                    48357
    ##  2 ARAUC                   119729
    ##  3 ATCMA                    21193
    ##  4 AYP                      32412
    ##  5 AYSEN                    12936
    ##  6 BBIO                    166104
    ##  7 COQ                      98284
    ##  8 LAGOS                    90339
    ##  9 LGBO                     87196
    ## 10 MAG                      11831
    ## 11 MAULE                   104851
    ## 12 NUBLE                    51859
    ## 13 RIOS                     39991
    ## 14 RM                      794054
    ## 15 TPCA                     55661
    ## 16 VALPO                   204644

A su vez, debemos sumar los estudiantes desvinculados el 2024 por
Región:

    desvinculados_por_region <- desvinculados %>%
      group_by(NOM_REG_RBD_A) %>%
      summarise(desvinculados = n())

    print(desvinculados_por_region)

    ## # A tibble: 16 × 2
    ##    NOM_REG_RBD_A desvinculados
    ##    <chr>                 <int>
    ##  1 ANTOF                  7389
    ##  2 ARAUC                 20552
    ##  3 ATCMA                  3679
    ##  4 AYP                    5827
    ##  5 AYSEN                  2326
    ##  6 BBIO                  25230
    ##  7 COQ                   17309
    ##  8 LAGOS                 17006
    ##  9 LGBO                  14593
    ## 10 MAG                    2221
    ## 11 MAULE                 17921
    ## 12 NUBLE                  7552
    ## 13 RIOS                   7898
    ## 14 RM                   134997
    ## 15 TPCA                   9604
    ## 16 VALPO                 38662

Luego unimos las tablas y creamos variables que nos enseñen la matrícula
teórica y la tasa de desvinculación:

    resultados_por_region <- matricula_por_region %>%
      left_join(desvinculados_por_region, by = "NOM_REG_RBD_A") %>% 
      mutate(matricula_teorica = matricula_actual + desvinculados,
             tasa_desvinculacion = (desvinculados / matricula_teorica) * 100)

    print(resultados_por_region)

    ## # A tibble: 16 × 5
    ##    NOM_REG_RBD_A matricula_actual desvinculados matricula_teorica tasa_desvinculacion
    ##    <chr>                    <int>         <int>             <int>               <dbl>
    ##  1 ANTOF                    48357          7389             55746                13.3
    ##  2 ARAUC                   119729         20552            140281                14.7
    ##  3 ATCMA                    21193          3679             24872                14.8
    ##  4 AYP                      32412          5827             38239                15.2
    ##  5 AYSEN                    12936          2326             15262                15.2
    ##  6 BBIO                    166104         25230            191334                13.2
    ##  7 COQ                      98284         17309            115593                15.0
    ##  8 LAGOS                    90339         17006            107345                15.8
    ##  9 LGBO                     87196         14593            101789                14.3
    ## 10 MAG                      11831          2221             14052                15.8
    ## 11 MAULE                   104851         17921            122772                14.6
    ## 12 NUBLE                    51859          7552             59411                12.7
    ## 13 RIOS                     39991          7898             47889                16.5
    ## 14 RM                      794054        134997            929051                14.5
    ## 15 TPCA                     55661          9604             65265                14.7
    ## 16 VALPO                   204644         38662            243306                15.9

**d) Presente en una tabla una desagregación distinta a por región (a su
elección), indicando el número de estudiantes desvinculados, la
matrícula teórica y la tasa de desvinculación.**

Aplicando la misma lógica anterior, debemos hacerlo pero esta vez con el
nombre del colegio (NOM\_RBD):

    matricula_por_colegio <- matricula_filtrada %>% 
      group_by(NOM_RBD) %>% 
      summarise(alumnos_matriculados = n())

    print(matricula_por_colegio)

    ## # A tibble: 5,132 × 2
    ##    NOM_RBD                          alumnos_matriculados
    ##    <chr>                                           <int>
    ##  1 ABRAHAM LINCOLN MEMORIAL COLLEGE                  229
    ##  2 ABRAHAM LINCOLN SCHOOL                            762
    ##  3 ACADEMIA HOSPICIO                                1429
    ##  4 ACADEMIA NERUDIANA                                166
    ##  5 ACADEMIA POZO ALMONTE                             270
    ##  6 ACONCAGUA EDUCA                                   110
    ##  7 ALBERTO HURTADO CRUCHAGA                          696
    ##  8 ALIANZA ALEMANA EL BELLOTO                        213
    ##  9 ALTOS DEL HUERTO                                  549
    ## 10 AMERICAN COLLEGE                                  587
    ## # ℹ 5,122 more rows

    desvinculados_por_colegio <- desvinculados %>%
      group_by(NOM_RBD) %>%
      summarise(alumnos_desvinculados = n())

    print(desvinculados_por_colegio)

    ## # A tibble: 4,843 × 2
    ##    NOM_RBD                          alumnos_desvinculados
    ##    <chr>                                            <int>
    ##  1 ABRAHAM LINCOLN MEMORIAL COLLEGE                    32
    ##  2 ABRAHAM LINCOLN SCHOOL                              74
    ##  3 ACADEMIA HOSPICIO                                  189
    ##  4 ACADEMIA NERUDIANA                                  35
    ##  5 ACADEMIA POZO ALMONTE                               44
    ##  6 ACONCAGUA EDUCA                                     49
    ##  7 ALBERTO HURTADO CRUCHAGA                            90
    ##  8 ALIANZA ALEMANA EL BELLOTO                          17
    ##  9 ALTOS DEL HUERTO                                    87
    ## 10 AMERICAN COLLEGE                                    64
    ## # ℹ 4,833 more rows

    resultados_por_colegio <- matricula_por_colegio %>%
      left_join(desvinculados_por_colegio, by = "NOM_RBD") %>% 
      mutate(matricula_teorica = alumnos_matriculados + alumnos_desvinculados,
             tasa_desvinculacion = (alumnos_desvinculados / matricula_teorica) * 100)

    print(resultados_por_colegio)

    ## # A tibble: 5,132 × 5
    ##    NOM_RBD                alumnos_matriculados alumnos_desvinculados matricula_teorica tasa_desvinculacion
    ##    <chr>                                 <int>                 <int>             <int>               <dbl>
    ##  1 ABRAHAM LINCOLN MEMOR…                  229                    32               261               12.3 
    ##  2 ABRAHAM LINCOLN SCHOOL                  762                    74               836                8.85
    ##  3 ACADEMIA HOSPICIO                      1429                   189              1618               11.7 
    ##  4 ACADEMIA NERUDIANA                      166                    35               201               17.4 
    ##  5 ACADEMIA POZO ALMONTE                   270                    44               314               14.0 
    ##  6 ACONCAGUA EDUCA                         110                    49               159               30.8 
    ##  7 ALBERTO HURTADO CRUCH…                  696                    90               786               11.5 
    ##  8 ALIANZA ALEMANA EL BE…                  213                    17               230                7.39
    ##  9 ALTOS DEL HUERTO                        549                    87               636               13.7 
    ## 10 AMERICAN COLLEGE                        587                    64               651                9.83
    ## # ℹ 5,122 more rows
