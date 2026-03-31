# BiomarkerIdentification_IntestineCancer

## Pre-processment in bash 
### 1- Path to project folder
project_folder="/home/felipe/Documentos/BiomarkerIdentification_IntestineCancer/"

### 2- gdc-client command line to download the samples from the PortalGdcCancer cancer database
gdc-client download -m /home/felipe/Documentos/BiomarkerIdentification_IntestineCancer/gdc_manifest.2026-03-31.143944.txt --dir home/felipe/Documentos/BiomarkerIdentification_IntestineCancer/

### 3- bash script to process the downladed files into reads count tables
/home/felipe/Documentos/BiomarkerIdentification_IntestineCancer/BiomarkerIdentification_IntestineCancer_Download_Tabel_From_PortalGdcCancer.sh

## Differential expression framework in R
### 4- Pacotes R utilizados
source(paste(project_folder,"/code/Load_All_R_Packages.R",sep=""))


