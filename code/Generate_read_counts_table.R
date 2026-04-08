###################################################################################
# Set the project configuration
# Set the path to Sample sheet filtered file
Sample_sheet_filtered_file=paste(project_folder,"metadata/gdc_sample_sheet_star_gene_counts.tsv",sep="")

# Set the path to clinical data file
clinical_data_file=paste(project_folder,"metadata/clinical.tsv",sep="")


# Take the list of gene ids
gene_ids_file<-paste(project_folder,"metadata/gene_ids.txt",sep="")
###################################################################################
# Load sample sheet data
sample_sheet_data<-read.delim(file = Sample_sheet_filtered_file, sep = '\t', header = TRUE,fill=TRUE)

# Load sample sheet data
clinical_data<-read.delim(file = clinical_data_file, sep = '\t', header = TRUE,fill=TRUE)


clinical_data$ID     <-clinical_data$cases.submitter_id
sample_sheet_data$ID <-sample_sheet_data$Case.ID

# Merge clinical and sample sheet
clinical_data<-merge(clinical_data,sample_sheet_data, by="ID")

# Load gene ids data
gene_ids_data<-read.delim(file = gene_ids_file, sep = '\t', header = TRUE,fill=TRUE)
###################################################################################
# Add stages
# Add state collumn
clinical_data$stage<-NA

# Set normal samples
clinical_data[which(clinical_data$Tissue.Type.y %in% c("Normal")),"stage"]              <-"Normal"

# Set stages
clinical_data[which(clinical_data$diagnoses.ajcc_clinical_t %in% c("T1b", "T1c")),"stage"]              <-"stage_1"
clinical_data[which(clinical_data$diagnoses.ajcc_clinical_t %in% c("T2", "T2a", "T2b", "T2c")),"stage"] <-"stage_2"
clinical_data[which(clinical_data$diagnoses.ajcc_clinical_t %in% c("T3a", "T3b")),"stage"]              <-"stage_3"




###################################################################################
# Star dataframe with all gene ids unstranded
read_counts_table<-data.frame(gene_id=as.vector(gene_ids_data[,1]))

# Star dataframe with all gene ids tpm_unstranded
read_counts_table_tpm<-data.frame(gene_id=as.vector(gene_ids_data[,1]))

# Set rownames unstranded
rownames(read_counts_table)<-read_counts_table$gene_id

# Set rownames tpm_unstranded
rownames(read_counts_table_tpm)<-read_counts_table_tpm$gene_id

# Set rownames of 
rownames(sample_sheet_data)<-sample_sheet_data$File.ID

# For each file in the sample_sheet_data, read the gene counts data
for (sample in rownames(sample_sheet_data))
{
  # Take the file id
  file_id<-sample_sheet_data[sample,"File.ID"]

  # Take the name of the file
  file_name<-sample_sheet_data[sample,"File.Name"]

  # Read the counts table
  counts_table<-read.delim(paste(project_folder,"data/",file_name,sep=""), skip = 5)

  # Set the colnames
  colnames(counts_table)<-c("gene_id",	"gene_name",	"gene_type",	"unstranded",	"stranded_first",	"stranded_second",	"tpm_unstranded",	"fpkm_unstranded",	"fpkm_uq_unstranded")

  # Set rownames
  rownames(counts_table)<-counts_table$gene_id

  # Start data.frame for the table unstranded
  df_counts_table_unstranded<-data.frame(file_id=counts_table[rownames(counts_table),"unstranded"])

  # Start data.frame for the table unstranded
  df_counts_table_tpm<-data.frame(file_id=counts_table[rownames(counts_table),"tpm_unstranded"])  

  # Set file_id in the colname
  colnames(df_counts_table_unstranded)<-file_id
  colnames(df_counts_table_tpm)<-file_id

  # Add to table unstranded
  read_counts_table<-cbind(read_counts_table,df_counts_table_unstranded)

  # Add to table tpm_unstranded
  read_counts_table_tpm<-cbind(read_counts_table_tpm,df_counts_table_tpm)  
}
# Remove first collumn unstranded
read_counts_table<-read_counts_table[,-1]

# Remove first collumn tpm_unstranded
read_counts_table_tpm<-read_counts_table_tpm[,-1]
