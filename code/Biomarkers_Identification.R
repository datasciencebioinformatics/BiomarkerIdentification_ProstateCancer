# 1 - The corrspondence table between "gene_id" and	"gene_name"
# Load one single reads file to obtain the correspondence betrween enesemble id and gene name
sample=rownames(sample_sheet_data)[1]

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

# Filter the correspondence table
correspondence_table<-counts_table[,c("gene_id",	"gene_name")]
#######################################################################################
# 2 - Biomarkers table
# Set the path to manifest file
known_biomarkers_file=paste(project_folder,"tables/Postate_Cancer_Known_Biomarkers.xlsx",sep="")

# Load data
# Load clinical data
known_biomarkers_data<-data.frame(read_excel(known_biomarkers_file) )

# Start data.frame to store the biomarkers genes
df_biomaker_genes<-data.frame(biomarkers=c(),genes=c())

# For each Biomarker
for (Biomarker in known_biomarkers_data$Biomarker)
{
  # Take the biomarker info
  known_biomarkers_info<-known_biomarkers_data[which(known_biomarkers_data$Biomarker == Biomarker),]  
  
  # Second, take the list of Genes for each experiment
  genes<-unlist(strsplit(known_biomarkers_info$Genes, "\n"))

  # Add to results table
  df_biomaker_genes<-rbind(df_biomaker_genes,expand.grid(biomarkers = Biomarker, genes = genes))
}
#######################################################################################
# 3 - Combile a data.frame with the known biomarker that are also differentially expressed genes.
known_biomarker<-unique(as.vector(df_biomaker_genes$genes))

# Take the name of the differentially expressed genes in the correspondence_table
res_tumor_normal<-cbind( gene_name=c(correspondence_table[rownames(res_tumor_normal),"gene_name"]),res_tumor_normal)

# Selected biomarkers
Selected_biomarkers<-res_tumor_normal[which(res_tumor_normal$gene_name %in% known_biomarker),]




