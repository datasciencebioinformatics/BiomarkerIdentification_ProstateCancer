#########################################################################################################
# https://graysonwhite.com/gglm/reference/gglm.html
# Provides four standard visual model diagnostic plots with `ggplot2`.
# Train bayesian network from discrete data 
#########################################################################################################
# Take the dat.frame transposed
df_t_read_counts_table_tpm<-data.frame(t(read_counts_table_tpm[rownames(res_tumor_normal),]))

# Tsake the table
df_t_read_counts_table_tpm<-cbind(df_t_read_counts_table_tpm,Tissue_Type=sample_sheet_data[colnames(read_counts_table_tpm),"Tissue.Type"])

# Tiddue data
Tissue_type_randomForest <- randomForest(x=data.frame(t(read_counts_table_tpm[rownames(res_tumor_normal),])),  y = as.numeric(as.factor(sample_sheet_data[colnames(read_counts_table_tpm),"Tissue.Type"])), method = "rf")

# Save data.frame
df_varImportance<-data.frame(varImp(Tissue_type_randomForest))

# Ascending
df_varImportance <- data.frame(rownames(df_varImportance),Overall=df_varImportance,gene_names=correspondence_table[rownames(df_varImportance), "gene_name"])

# Ascending
df_varImportance <- df_varImportance[order(-df_varImportance$Overall), ]

# bwplot               
png(filename=paste(output_dir,"rf_varImp_Tissue_Type.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # Plot the bayesian network graph
  ggplot(df_varImportance[1:20,], aes(x = gene_names, y = Overall)) +
  geom_bar(stat = "identity") +
  coord_flip()+ theme_bw()
dev.off()
########################################################################################################
