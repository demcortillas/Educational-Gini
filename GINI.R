# Title     : TODO
# Objective : TODO
# Created by: pancitoo
# Created on: 03/10/2020

library(DBI)
library(dplyr)
library(DescTools)
con <- dbConnect(RSQLite::SQLite(), "MVE.db")
DB <- tbl(con, "PERSONAS")

NJ <- DB %>% select(REGION,PROVINCIA,COMUNA,ESCOLARIDAD) %>% collect()

REGIONES<-unique(NJ[1])
PROVINCIAS<-unique(NJ[2])
COMUNAS<-unique(NJ[3])

GINI_COMUNAL<-NULL
GINI_PROV<-NULL
GINI_REG<-NULL

for(reg in REGIONES$REGION){
  A<-filter(NJ,REGION==reg & ESCOLARIDAD != 99 & ESCOLARIDAD != 98 & ESCOLARIDAD != 999)$ESCOLARIDAD
  GINI_REG<-c(GINI_REG,Gini(A))
}

for(prov in PROVINCIAS$PROVINCIA){
  A<-filter(NJ,PROVINCIA==prov & ESCOLARIDAD != 99 & ESCOLARIDAD != 98 & ESCOLARIDAD != 999)$ESCOLARIDAD
  GINI_PROV<-c(GINI_PROV,Gini(A))
}

for(comuna in COMUNAS$COMUNA){
  A<-filter(NJ,COMUNA==comuna & ESCOLARIDAD != 99 & ESCOLARIDAD != 98 & ESCOLARIDAD != 999)$ESCOLARIDAD
  GINI_COMUNAL<-c(GINI_COMUNAL,Gini(A))
}

DB_REGIONES<-data.frame(REGIONES$REGION,GINI_REG)
DB_PROVINCIAS<-data.frame(PROVINCIAS$PROVINCIA,GINI_PROV)
DB_COMUNAS<-data.frame(COMUNAS$COMUNA,GINI_COMUNAL)

write.csv(DB_REGIONES,'D:/PROJECTS/gini-escolaridad/GINI_REGIONES.csv')
write.csv(DB_PROVINCIAS,'D:/PROJECTS/gini-escolaridad/GINI_PROVINCIAS.csv')
write.csv(DB_COMUNAS,'D:/PROJECTS/gini-escolaridad/GINI_COMUNAS.csv')





