#########################################################################################################
# Make data discrete

### discretize all numeric columns differently
read_counts_table_tpm_disc <- discretizeDF(read_counts_table_tpm[rownames(res_tumor_normal),], default = list(
  method = "interval", breaks = 3,
  labels = c("low","medium", "high")
))

# Add tisue type to data.frame
read_counts_table_tpm_disc<-cbind(t(read_counts_table_tpm_disc),Tissue_Type=sample_sheet_data[colnames(read_counts_table_tpm_disc),"Tissue.Type"])

# Save raw, tpm and discrete values11
# write_xlsx(list(raw = read_counts_table, tpm = read_counts_table_tpm, discrete =discretizeDF(read_counts_table_tpm, default = list(method = "interval", breaks = 3, labels = c("low","medium", "high")))), path = paste(output_dir,"rpart_Tissue_Type.xlsx",sep=""))
#########################################################################################################
# Compute rpart model 
Tissue_Type_rpart<-rpart(formula=Tissue_Type ~ ., data=data.frame(read_counts_table_tpm_disc),method = "class")

# bwplot               
png(filename=paste(output_dir,"rpart_Tissue_Type.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # Plot the bayesian network graph
  fancyRpartPlot(Tissue_Type_rpart, caption = NULL, sub=NULL)  
dev.off()

#########################################################################################################
set.seed(123) # Define a semente para reprodutibilidade
sample_ids_trainning<-sample(rownames(read_counts_table_tpm_disc), dim(read_counts_table_tpm_disc)[1]*0.75)
sample_ids_testing  <-rownames(read_counts_table_tpm_disc)[!rownames(read_counts_table_tpm_disc) %in% sample_ids_trainning]

# Compute rpart model trainning only
Tissue_Type_rpart<-rpart(formula=Tissue_Type ~ ., data=data.frame(read_counts_table_tpm_disc),method = "class")

#Predicted data
predicted_training_set         <- as.vector(predict(Tissue_Type_rpart, newdata = data.frame(read_counts_table_tpm_disc), type = "class"))

# Confusion matrix
results_trainning <- confusionMatrix(data = factor(predicted_training_set), reference =  factor(data.frame(read_counts_table_tpm_disc)$Tissue_Type))

write.table(data.frame(results_trainning$overall), file = paste(output_dir,"confusionMatrix_rpart.txt",sep=""),, sep = "\t", row.names = TRUE, append=FALSE)
write.table(data.frame(results_trainning$table), file = paste(output_dir,"confusionMatrix_rpart.txt",sep=""),, sep = "\t", row.names = TRUE, append=TRUE)


#########################################################################################################


