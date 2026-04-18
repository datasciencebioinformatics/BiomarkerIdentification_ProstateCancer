# Compute rpart model 
mreSummary <- function(data, lev = NULL, model = NULL) {
rmse=rmse(data$obs, data$pred) 
mae=mae(data$obs, data$pred)
mre=mre(data$obs, data$pred) 
cor=cor(data$obs, data$pred)
c(MRE = mre, RMSE=rmse, MAE = mae, Cor=cor)
}

#########################################################################################################
# Add tisue type to data.frame
read_counts_table_tpm_disc<-data.frame(cbind(t(read_counts_table_tpm[rownames(res_tumor_normal),]),Tissue_Type=sample_sheet_data[colnames(read_counts_table_tpm),"Tissue.Type"]))

# Set the Tissue_Type collumn as factor
read_counts_table_tpm_disc$Tissue_Type<-as.factor(read_counts_table_tpm_disc$Tissue_Type)
#########################################################################################################
# Train the model using the 'rpart' method
model_comb <-  caret::train(
  Tissue_Type ~ ., 
  data = read_counts_table_tpm_disc, 
  method = "rpart", 
  trControl = trainControl(method = "cv", number = 10, summaryFunction = mreSummary), # 10-fold cross-validation
  tuneLength = 10                                       # Evaluate 10 different 'cp' values
)
saveRDS(model_comb, file = file.path(project_folder, "/rsd","/model_comb.rsd" ))

# bwplot               
png(filename=paste(output_dir,"rpart_Tissue_Type.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # Plot the bayesian network graph
  fancyRpartPlot(model_comb, caption = NULL, sub=NULL)  
dev.off()
#########################################################################################################
df_mean[c("ENSG00000277287.1","ENSG00000287325.1","ENSG00000140254.12","ENSG00000187094.12"),]

levels(factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000277287.1"),]))))
factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000287325.1"),])))
factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000140254.12"),])))
factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000187094.12"),])))


