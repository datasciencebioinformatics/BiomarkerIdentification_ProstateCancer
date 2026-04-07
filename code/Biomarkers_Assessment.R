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


