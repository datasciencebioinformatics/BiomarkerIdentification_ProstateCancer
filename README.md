# BiomarkerIdentification_IntestineCancer

## Pre-processment in bash 
### 1- Set up the Project_Configuration.txt file
Project_Configuration.txt

### 2- gdc-client command line to download the samples from the PortalGdcCancer cancer database
gdc-client download -m $star_gene_counts_manifest_file --dir $project_folder

### 3- bash script to process the downladed files into reads count tables
$project_folder"bash/Download_Tabel_From_PortalGdcCancer.sh"


## Differential expression framework in R
### 4- Pacotes R utilizados
source(paste(project_folder,"/code/Load_All_R_Packages.R",sep=""))


