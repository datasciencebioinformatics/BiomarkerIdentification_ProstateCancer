#########################################################################################################
# Start data.frame
df_read_counts_table_tpm_disc          <- data.frame(matrix("", nrow = length(rownames(res_tumor_normal)), ncol = length(colnames(read_counts_table_tpm))))
df_read_counts_table_tpm_disc_no_label <- data.frame(matrix("", nrow = length(rownames(res_tumor_normal)), ncol = length(colnames(read_counts_table_tpm))))

# Set rownames()
rownames(df_read_counts_table_tpm_disc)<-rownames(res_tumor_normal)
rownames(df_read_counts_table_tpm_disc_no_label)<-rownames(res_tumor_normal)

# Remove first collumn
colnames(df_read_counts_table_tpm_disc)<-colnames(read_counts_table_tpm)
colnames(df_read_counts_table_tpm_disc_no_label)<-colnames(read_counts_table_tpm)

# Make data discrete
# For each gene 
for (gene in rownames(res_tumor_normal))
{
	# Take the discrete value
 	a=cut(as.vector(unlist(as.vector(read_counts_table_tpm[gene,]))), breaks = 3,labels = c("low","medium", "high") , include.lowest = TRUE)
 	b=cut(as.vector(unlist(as.vector(read_counts_table_tpm[gene,]))), breaks = 3, include.lowest = TRUE)

	# add to vector
	df_read_counts_table_tpm_disc[gene,colnames(read_counts_table_tpm)]<-a

 	# add to vector
 	df_read_counts_table_tpm_disc_no_label[gene,colnames(read_counts_table_tpm)]<-b 
}

# Add tisue type to data.frame
read_counts_table_tpm_disc<-data.frame(cbind(t(df_read_counts_table_tpm_disc[rownames(res_tumor_normal),]),Tissue_Type=sample_sheet_data[colnames(df_read_counts_table_tpm_disc),"Tissue.Type"]))

# Set the Tissue_Type collumn as factor
read_counts_table_tpm_disc$Tissue_Type<-as.factor(read_counts_table_tpm_disc$Tissue_Type)

#########################################################################################################
# Train the model using the 'rpart' method
model_comb <-  caret::train(
  Tissue_Type ~ ., 
  data = read_counts_table_tpm_disc, 
  method = "rpart", 
  tuneLength = 10                                       # Evaluate 10 different 'cp' values
)

model_comb <- rpart( Tissue_Type ~ ., data = read_counts_table_tpm_disc, method = "class", cp= 0.0498)


# bwplot               
png(filename=paste(output_dir,"rpart_Tissue_Type.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # Plot the bayesian network graph
  fancyRpartPlot(model_comb$finalModel, caption = NULL, sub=NULL)  
dev.off()
#########################################################################################################
# Save rpart model
##### saveRDS(model_comb, file = file.path(project_folder, "/rsd","/model_rpart_comb.rsd" ))
##### model_comb  <-loadRDS(file = file.path(project_folder, "/rsd","/model_rpart_comb.rsd" ))
#########################################################################################################



write.table(df_mean[c("ENSG00000277287.1","ENSG00000287325.1","ENSG00000140254.12"),], file.path(output_dir, "/model_rpart_comb.txt" ), sep = "\t", row.names = TRUE)


levels(factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000277287.1"),]))))
factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000287325.1"),])))
factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000140254.12"),])))
factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000187094.12"),])))


