set.seed(09042026)

###################################################################################################
# BiomarkerIdentification_ProstateCancer
## Pre-configuration
project_folder="/home/felipe/Documents/BiomarkerIdentification_ProstateCancer/"
project_folder="C:/Users/felip/OneDrive/Documentos/GitHub/BiomarkerIdentification_ProstateCancer/"

### 1- Load R packages
source(paste(project_folder,"/code/Load_All_R_Packages.R",sep=""))

###################################################################################################
## Differential expression framework in R
### 2- Add the version control
source(paste(project_folder,"/code/Version_Control.R",sep=""))

### 3- Generate read counts table 
source(paste(project_folder,"/code/Generate_read_counts_table.R",sep=""))

### 4- Differential expression analyss
source(paste(project_folder,"/code/Differential_Expression_Analysis.R",sep=""))
###################################################################################################
## Read differential expression results
##### dds_tumor_normal<-loadRDS(file = paste(output_dir,"dds_tumor_normal.rds",sep=""))
##### res_tumor_normal<-loadRDS(file = paste(output_dir,"res_tumor_normal",sep=""))

## Biomarker assessment
### 5- Biomarkers identification
source(paste(project_folder,"/code/Biomarkers_Identification.R",sep=""))

### 6- Biomarkers assessment
source(paste(project_folder,"/code/Biomarkers_Assessment.R",sep=""))
###################################################################################################
## Machine learning methods
### 7- Decision trees
source(paste(project_folder,"/code/Biomarkers_DecisionTree.R",sep=""))

### 8- Bayesiean Networks
source(paste(project_folder,"/code/Biomarkers_BayesienaNetworks.R",sep=""))

### 9- Random Forest
source(paste(project_folder,"/code/Biomarkers_RandomFortest.R",sep=""))

### 10- Linear regression
source(paste(project_folder,"/code/Biomarkers_LinearRegression.R",sep=""))
###################################################################################################
### 11- Linear regression versus Random Forest (Association, varImp, minimal depth)
source(paste(project_folder,"/code/Biomarkers_LinearRegression_versus_RandomForest.R",sep=""))












