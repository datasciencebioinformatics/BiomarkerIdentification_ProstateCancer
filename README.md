# BiomarkerIdentification_ProstateCancer
project_folder="/home/felipe/Documents/BiomarkerIdentification_ProstateCancer/"

## Differential expression framework in R
### 1- Load R packages
source(paste(project_folder,"/code/Load_All_R_Packages.R",sep=""))

### 2- Generate read counts table 
source(paste(project_folder,"/code/Generate_read_counts_table.R",sep=""))

### 3- Differential expression analyss
source(paste(project_folder,"/code/Differential_Expression_Analysis.R",sep=""))






