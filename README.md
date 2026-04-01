# BiomarkerIdentification_ProstateCancer

## Pre-processment in bash 
### 1- Set up the Project_Configuration.txt file
config/Project_Configuration.txt

### 2- Filter Sample Sheet and Manifest files
chmod a+x $project_folder$FilterSampleSheet_Manifest_files.sh
$project_folder$FilterSampleSheet_Manifest_files.sh

### 3- gdc-client command line to download the samples from the PortalGdcCancer cancer database
gdc-client download -m $star_gene_counts_manifest_file --dir $project_folder

## Differential expression framework in R
### 4- Load R packages
source(paste(project_folder,"/code/Load_All_R_Packages.R",sep=""))

### 5- Generate read counts table 
source(paste(project_folder,"/code/Generate_read_counts_table.R",sep=""))




