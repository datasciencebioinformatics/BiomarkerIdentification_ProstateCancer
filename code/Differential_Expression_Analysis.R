########################################################################
# First phase, Tissue.Type
# Create DESeqDataSet from your prepared matrix
dds_tumor_normal <- DESeqDataSetFromMatrix(countData = read_counts_table,
                              colData = sample_sheet_data,
                              design = ~ Tissue.Type)
# Run DeSeq2
dds_tumor_normal <- DESeq(dds_tumor_normal)

# Obtain the results
res_tumor_normal <- results(dds_tumor_normal, contrast=c("Tissue.Type","Tumor","Normal"))

# Take 
res_tumor_normal<-data.frame(res_tumor_normal[which(res_tumor_normal$padj<0.05 & abs(res_tumor_normal$log2FoldChange)>2),])


########################################################################
# Second phase, Tissue.Type
# First phase, Tissue.Type
# Create DESeqDataSet from your prepared matrix
dds_primary_metastic <- DESeqDataSetFromMatrix(countData = read_counts_table,
                              colData = sample_sheet_data,
                              design = ~ Tumor.Descriptor)

# Run DeSeq2
dds_primary_metastic <- DESeq(dds_primary_metastic)

# Obtain the results
res_Primary_normal <- results(dds_primary_metastic, contrast=c("Tumor.Descriptor","Primary","Not Applicable"))
res_Metastatic_normal <- results(dds_primary_metastic, contrast=c("Tumor.Descriptor","Metastatic","Not Applicable"))

# Take 
res_Primary_normal<-data.frame(res_Primary_normal[which(res_Primary_normal$padj<0.05 & abs(res_Primary_normal$log2FoldChange)>2),])
res_Metastatic_normal<-data.frame(res_Metastatic_normal[which(res_Metastatic_normal$padj<0.05 & abs(res_Metastatic_normal$log2FoldChange)>2),])


sheets_list <- list("tumor_genes"= res_tumor_normal, "primary_tumor_genes" = res_Primary_normal, "metastatic_tumor_genes"=res_Metastatic_normal)
write_xlsx(sheets_list,paste(project_folder,"Supplemental_Table_S1.xlsx",sep="" ))

                              
