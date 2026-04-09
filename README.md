# BiomarkerIdentification_ProstateCancer
project_folder="/home/felipe/Documents/BiomarkerIdentification_ProstateCancer/"
project_folder="C:/Users/felip/OneDrive/Documentos/GitHub/BiomarkerIdentification_ProstateCancer/"

# Add the version control
source(paste(project_folder,"/code/Version_Control.R",sep=""))

## Differential expression framework in R
### 1- Load R packages
source(paste(project_folder,"/code/Load_All_R_Packages.R",sep=""))

### 2- Generate read counts table 
source(paste(project_folder,"/code/Generate_read_counts_table.R",sep=""))

### 3- Differential expression analyss
source(paste(project_folder,"/code/Differential_Expression_Analysis.R",sep=""))

### 4- Biomarkers identification
source(paste(project_folder,"/code/Biomarkers_Identification.R",sep=""))

### 5- Biomarkers assessment
source(paste(project_folder,"/code/Biomarkers_Assessment.R",sep=""))

# lm method was used to fit the trainning set on the surrogate models
multiple_linear_regression_lm <- lm(surrogate_model, data = training_set)

# Perform stepwise selection (direction "both", "backward", "forward")
surrogate_model_final_lm <- stepAIC(multiple_linear_regression_lm, direction = "backward", trace = 0)

# lm method was used to fit the trainning set on the selected model
multiple_linear_regression_lm_selected<-lm(surrogate_model_final_lm, data = training_set)

### 8- Decision tree analyses
#### StepAIC variable selection from tumor_genes
#### Decision tree tumor_genes
source(paste(project_folder,"/code/DecisionTree_Analyses.R",sep=""))
  

### 6- Select biomartkers with stepAIC
source(paste(project_folder,"/code/SelectBiomartkers_with_stepAIC.R",sep=""))










