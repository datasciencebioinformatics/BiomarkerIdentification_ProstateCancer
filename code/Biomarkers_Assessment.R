# 2. Basic plot
# 1. Transform data (vst is recommended for large datasets)
vsd_tumor_normal <- vst(dds_tumor_normal, blind = FALSE)

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

# Biomarkers whose fold change (FC) was ≥50 and average TPM of control samples ≤ 10.
# First, compile data.frame with 
# Take p-value
df_mean<-data.frame(
    foldChange_Tumor_Normal=rowMeans(read_counts_table_tpm[rownames(res_tumor_normal),tumor_sample_ids])/rowMeans(read_counts_table_tpm[rownames(res_tumor_normal),normal_sample_ids]),
    avg.normal=rowMeans(read_counts_table_tpm[rownames(res_tumor_normal),normal_sample_ids]),
    std.normal=0,
    avg.tumor=rowMeans(read_counts_table_tpm[rownames(res_tumor_normal),tumor_sample_ids]),
    std.tumor=0 )

# For each gene, calculate the std too the 
for (gene in rownames(df_mean))
{
  df_mean[gene,"std.normal"]<-sd(read_counts_table_tpm[gene,normal_sample_ids])
  df_mean[gene,"std.tumor"]<-sd(read_counts_table_tpm[gene,tumor_sample_ids])
}      
# Add gene symbol

# Biomarkers whose fold change (FC) was ≥50 and average TPM of control samples ≤ 10.
selected_biomarkers<-df_mean[which(df_mean$foldChange_Tumor_Normal>=50 & df_mean$avg.normal <=10),]

# Add gene_name
selected_biomarkers<-cbind(correspondence_table[rownames(selected_biomarkers),],selected_biomarkers)
      
# Save list
sheets_list <- list("tumor_genes"= res_tumor_normal, "selected_biomarkers" = selected_biomarkers)
write_xlsx(sheets_list,paste(project_folder,"Supplemental_Table_S1.xlsx",sep="" ))

#######################################################################################################################################
# Selected biomarkers plot t.test for the selected biomarkers - Use only the first tumor genes
tumor_biomarkers<-res_tumor_normal[which(res_tumor_normal$gene_name %in% known_biomarker),][1,]

# Use the ggplot2 to plot the fpkm values for tumor and normal genes
df_tumor_gene<-data.frame(sample_id=colnames(read_counts_table_tpm),tpm=as.vector(t(read_counts_table_tpm[rownames(tumor_biomarkers),])[,1]))

# Set rownames
rownames(df_tumor_gene)<-df_tumor_gene$sample_id

# Add to collumn
df_tumor_gene<-cbind(gene=rownames(tumor_biomarkers),sample_sheet_data[rownames(df_tumor_gene),],df_tumor_gene)
#######################################################################################################################################
# Visualize: Specify the comparisons you want
my_comparisons <- list( c("Tumor", "Normal"))

# Save plot
png(filename=paste(output_dir,paste("pca_boxplots_","3500_viscosity_128_p47",".png",sep=""),sep=""), width = 25, height = 30, res=600, units = "cm")  
  # Plot the OOB errors
  ggplot(data = df_tumor_gene[,c("Tissue.Type","tpm")], aes(x = Tissue.Type, y =tpm)) +  geom_boxplot() + theme_bw() + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +theme(text=element_text(size=12)) +theme(legend.position="none")  + stat_compare_means(label = "p.signif", method = "t.test",comparisons = my_comparisons) + ggtitle(tumor_biomarkers$gene_name)
dev.off()

