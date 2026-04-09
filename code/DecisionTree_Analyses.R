#########################################################################################################
# Make data discrete

### discretize all numeric columns differently
read_counts_table_tpm_disc <- discretizeDF(read_counts_table_tpm, default = list(
  method = "interval", breaks = 3,
  labels = c("low","medium", "high")
))

# Add tisue type to data.frame
read_counts_table_tpm_disc<-cbind(t(read_counts_table_tpm_disc),Tissue_Type=sample_sheet_data[colnames(read_counts_table_tpm_disc),"Tissue.Type"])

# Save raw, tpm and discrete values
write_xlsx(list(raw = read_counts_table, tpm = read_counts_table_tpm, discrete =discretizeDF(read_counts_table_tpm, default = list(method = "interval", breaks = 3, labels = c("low","medium", "high")))), path = paste(output_dir,"rpart_Tissue_Type.xlsx",sep=""))
#########################################################################################################
# Select 80% as trainning set/20% the reamaining data
trainning_set_ids<-sample(colnames(read_counts_table_tpm), size=round(length(colnames(read_counts_table_tpm))*0.75), replace = FALSE)
testing_set_ids  <-colnames(read_counts_table_tpm)[!colnames(read_counts_table_tpm) %in% trainning_set_ids]

# Compute rpart model 
Tissue_Type_rpart<-rpart(formula=Tissue_Type ~ ., data=data.frame(read_counts_table_tpm_disc[trainning_set_ids,]),method = "class")

# bwplot               
png(filename=paste(output_dir,"rpart_Tissue_Type.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # Plot the bayesian network graph
  fancyRpartPlot(Efficiency_rpart, caption = NULL, sub=NULL)  
dev.off()

#########################################################################################################
# Once the surrogate model is fitted with the trainning set, the RMSE, MAE and mean relative error are calculated from the testing.
predicted_testing_set <- as.vector(predict(Tissue_Type_rpart, newdata = data.frame(read_counts_table_tpm_disc[testing_set_ids,])))

rmse=rmse(actual_testing_set, predicted_testing_set), 
mae=mae(actual_testing_set, predicted_testing_set),
mre=mre(actual_testing_set, predicted_testing_set), 
cor=cor(actual_testing_set, predicted_testing_set),

