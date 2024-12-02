install.packages(c("tidyverse", "dplyr", "readcsv", "ggplot2"))

library(tidyverse)
library(dplyr)
library(readcsv)
library(readr)
library(writexl)
library(naniar)

rendimiento <- read_csv("prueba_analista_ds/rendimiento_2023.csv")


matricula <- read_csv2("prueba_analista_ds/20240913_Matrícula_unica_2024_20240430_WEB.CSV")


####a) Numero de estudiantes desvinculados periodo 23-24
#Filtramos establecimientos particulares subvencionados y para respectivo año:

rendimiento_filtrado <- filter(rendimiento, COD_DEPE == 3 & AGNO == 2023)

matricula_filtrada <- filter(matricula, COD_DEPE == 3 & AGNO == 2024)


#identificar a los estudiantes que estaban presentes en la base de rendimiento de 2023 
#pero no aparecen en la matrícula de 2024. Desvinculados:
desvinculados <- anti_join(rendimiento_filtrado, matricula_filtrada, by = "MRUN")

numero_desvinculados <- nrow(desvinculados)

#Total de registros que están presentes en la base de rendimiento del año t-1 (2023), 
#pero no aparecen en la base de matrícula del año t (2024)
print(numero_desvinculados)
#El número es 348.749

#Luego de haber revisado el ejercicio me doy cuenta que existen MRUN duplicados, los eliminamos
RUN_duplicados <- desvinculados %>%
  group_by(MRUN) %>%
  filter(n() > 1) %>%
  count()

desvinculados <- desvinculados %>%
  distinct(MRUN, .keep_all = TRUE)

numero_desvinculados_sin_duplicados <- nrow(desvinculados_sin_duplicados)

print(numero_desvinculados_sin_duplicados)
#El numero real sería 332.766


#Acá nos damos cuenta que hay alumnos que se repiten ya que probablemente solicitaron cambio de curso 
#y horario

detalle_duplicados <- desvinculados %>%
  group_by(MRUN) %>%
  filter(n() > 1) %>%
  select(MRUN, everything()) %>%
  arrange(MRUN)

####b) La matrícula teórica y la tasa de desvinculación por región.
####c) Presente los resultados por región en una tabla, indicando el número de estudiantes desvinculados, 
#la matrícula teórica y la tasa de desvinculación

# Matrícula teórica del año t = Matrícula del año t + Desvinculados del año t.

# Sumar matrícula 2024 por región
matricula_por_region <- matricula_filtrada %>%
  group_by(NOM_REG_RBD_A) %>%
  summarise(matricula_actual = n())

# Sumar desvinculados 2024 por región
desvinculados_por_region <- desvinculados %>%
  group_by(NOM_REG_RBD_A) %>%
  summarise(desvinculados = n())

# Unimos tablas y creamos variables

resultados_por_region <- matricula_por_region %>%
  left_join(desvinculados_por_region, by = "NOM_REG_RBD_A") %>% 
  mutate(matricula_teorica = matricula_actual + desvinculados,
         tasa_desvinculacion = (desvinculados / matricula_teorica) * 100)
  

####c) Presente los resultados por región en una tabla, indicando el número de estudiantes desvinculados, 
#la matrícula teórica y la tasa de desvinculación

resultados_por_region

####d) Presente en una tabla una desagregación distinta a por región (a su elección), indicando el 
#número de estudiantes desvinculados, la matrícula teórica y la tasa de desvinculación.

#Utilizamos la misma lógica anterior pero con el nombre del colegio (NOM_RBD)

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


#Exportamos bases a archivos .xlsx

