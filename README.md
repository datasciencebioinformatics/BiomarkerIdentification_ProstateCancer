set.seed(09042026)

# BiomarkerIdentification_ProstateCancer
project_folder="/home/felipe/Documents/BiomarkerIdentification_ProstateCancer/"
project_folder="C:/Users/felip/OneDrive/Documentos/GitHub/BiomarkerIdentification_ProstateCancer/"


## Differential expression framework in R
### 1- Load R packages
source(paste(project_folder,"/code/Load_All_R_Packages.R",sep=""))

# Add the version control
source(paste(project_folder,"/code/Version_Control.R",sep=""))

### 2- Generate read counts table 
source(paste(project_folder,"/code/Generate_read_counts_table.R",sep=""))

### 3- Differential expression analyss
source(paste(project_folder,"/code/Differential_Expression_Analysis.R",sep=""))

### 4- Biomarkers identification
source(paste(project_folder,"/code/Biomarkers_Identification.R",sep=""))

### 5- Biomarkers assessment
source(paste(project_folder,"/code/Biomarkers_Assessment.R",sep=""))

### 6- Decision trees
source(paste(project_folder,"/code/Biomarkers_DecisionTree.R",sep=""))

### 7- Bayesiean Networks
source(paste(project_folder,"/code/Biomarkers_BayesienaNetworks.R",sep=""))

### 8- Random Forest
source(paste(project_folder,"/code/Biomarkers_RandomFortest.R",sep=""))

### 9- Linear regression
source(paste(project_folder,"/code/Biomarkers_LinearRegression.R",sep=""))












