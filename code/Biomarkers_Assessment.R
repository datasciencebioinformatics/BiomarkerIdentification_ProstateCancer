# 2. Basic plot
# 1. Transform data (vst is recommended for large datasets)
vsd_tumor_normal <- vst(res_tumor_normal, blind = FALSE)

# 1. Extract PCA data
pcaData <- plotPCA(vsd_tumor_normal, intgroup = c("Tissue.Type"), returnData = TRUE)

# 2. Calculate percentage of variance for axis labels
percentVar <- round(100 * attr(pcaData, "percentVar"))

# Melt tabele
# Plot_raw_vibration_data.png                                                                                                            
png(filename=paste(project_folder,"PCA_Plot_of_RNASeq_Samples_TissueType.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # 3. Create custom ggplot
  ggplot(pcaData, aes(x = PC1, y = PC2, color = group)) +
    geom_point(size = 3) +
    xlab(paste0("PC1: ", percentVar[1], "% variance")) +
    ylab(paste0("PC2: ", percentVar[2], "% variance")) +
    coord_fixed() +
    theme_minimal()
dev.off()

#######################################################################################################################################
# Take the normal samples, tumor samples, primary samples, metastic samples
normal_sample_ids     <- rownames(sample_sheet_data[which(sample_sheet_data$Tissue.Type     == "Normal"),])
tumor_sample_ids      <- rownames(sample_sheet_data[which(sample_sheet_data$Tissue.Type     == "Tumor"),])
primary_sample_ids    <- rownames(sample_sheet_data[which(sample_sheet_data$Tumor.Descriptor=="Primary"),])
metastatic_sample_ids <- rownames(sample_sheet_data[which(sample_sheet_data$Tumor.Descriptor=="Metastatic"),])

# Add gene id and gene symbol to table
cbind(gene_id=rownames(read_counts_table_tpm,read_counts_table_tpm)

# Biomarkers whose fold change (FC) was ≥50 and average TPM of control samples ≤ 10.
# First, compile data.frame with 
# Take p-value
df_mean<-data.frame(
    foldChange_Tumor_Normal=rowMeans(read_counts_table_tpm[res_tumor_normal$gene,tumor_sample_ids])/rowMeans(read_counts_table_tpm[res_tumor_normal$gene,normal_sample_ids]),
    avg.normal=rowMeans(read_counts_table_tpm[res_tumor_normal$gene,normal_sample_ids]),
    std.normal=0,
    avg.tumor=rowMeans(read_counts_table_tpm[res_tumor_normal$gene,tumor_sample_ids]),
    std.tumor=0, 
    avg.primary=rowMeans(read_counts_table_tpm[res_tumor_normal$gene,primary_sample_ids]), 
    std.primary=0, 
    avg.metastatic=rowMeans(read_counts_table_tpm[res_tumor_normal$gene,metastatic_sample_ids]), 
    std.metastatic=0)

# For each gene, calculate the std too the 
for (gene in rownames(df_mean))
{
  df_mean[gene,"std.normal"]<-sd(unstranded_data[gene,normal_sample_ids])
  df_mean[gene,"std.tumor"]<-sd(unstranded_data[gene,tumor_sample_ids])
  df_mean[gene,"std.primary"]<-sd(unstranded_data[gene,primary_sample_ids])
  df_mean[gene,"std.metastatic"]<-sd(unstranded_data[gene,metastatic_sample_ids])  
}      

# Add the Gene smbol to the table
df_biomaker_genes

#
Biomarkers whose fold change (FC) was ≥50 and average TPM of control samples ≤ 10.


# Save list
sheets_list <- list("tumor_genes"= res_tumor_normal, "primary_tumor_genes" = res_Primary_normal, "metastatic_tumor_genes"=res_Metastatic_normal)
write_xlsx(sheets_list,paste(project_folder,"Supplemental_Table_S1.xlsx",sep="" ))



