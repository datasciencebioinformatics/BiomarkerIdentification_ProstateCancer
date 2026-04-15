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
# 2. Save the object to an .rds file
saveRDS(dds_tumor_normal, file = file.path(project_folder, "rsd","rsd","/dds_tumor_normal.rsd" ))
saveRDS(res_tumor_normal, file = file.path(project_folder, "rsd",rsd,"/res_tumor_normal.rsd" ))


