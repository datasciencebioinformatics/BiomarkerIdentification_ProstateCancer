###################################################################################
# Set the project configuration
# Set the path to manifest file
Manifest_file=paste(project_folder,"metadata/gdc_manifest.2026-04-01.072557.txt",sep="")

# Set the path to metadata cohort file
Metadata_file=paste(project_folder,"metadata/metadata.cohort.2026-04-01.json",sep="")

# Set the path to Sample sheet file
Sample_sheet_file=paste(project_folder,"metadata/gdc_sample_sheet.2026-04-01.tsv",sep="")

# Set the path to Sample sheet filtered file
Sample_sheet_filtered_file=paste(project_folder,"metadata/gdc_sample_sheet_star_gene_counts.tsv",sep="")

# Set the path to biospecimen cohort file
Biospecimen_file=paste(project_folder,"metadata/biospecimen.cohort.2026-04-01.tar.gz",sep="")

# Set the path to clinical cohort file
Clinical_file=paste(project_folder,"metadata/clinical.cohort.2026-04-01.tar.gz",sep="")

# Set the path to clinical file
clinical_file=paste(project_folder,"metadata/clinical.tsv",sep="")

# Set the path to sample file
sample_file=paste(project_folder,"metadata/sample.tsv",sep="")
###################################################################################
# Load clinical data
clinical_data<-read.delim(file = clinical_file, sep = '\t', header = TRUE,fill=TRUE)

# Load sample data
sample_data<-read.delim(file = sample_file, sep = '\t', header = TRUE,fill=TRUE)

# Load sample data
sample_sheet_data<-read.delim(file = Sample_sheet_filtered_file, sep = '\t', header = TRUE,fill=TRUE)

# Merge clinical and sample
merge_clinical_sample<-merge(clinical_data,sample_data,by="cases.case_id")

# Compile metadata
metadata_table<-merge(merge_clinical_sample,sample_sheet_data,by.x="cases.submitter_id.x",by.y="Case.ID")

# Take only the collumns of interest
metadata_table<-unique(metadata_table[,c("cases.submitter_id.x","cases.case_id","samples.tissue_type","diagnoses.ajcc_clinical_t","File.ID","File.Name")])

# Write tsv file
write_tsv(metadata_table, paste(project_folder,"tables/metadata_table.tsv",sep=""))
###################################################################################
# For each file in the sample_sheet_data, read the gene counts data
for (sample in rownames(sample_sheet_data))
{

}

