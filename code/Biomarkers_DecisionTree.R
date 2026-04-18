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
read_counts_table_tpm_disc<-data.frame(cbind(t(read_counts_table_tpm[rownames(res_tumor_normal),]),Tissue_Type=sample_sheet_data[rownames(read_counts_table_tpm_disc),"Tissue.Type"]))

read_counts_table_tpm_disc$Tissue_Type<-as.factor(read_counts_table_tpm_disc$Tissue_Type)


# Save raw, tpm and discrete values11
# write_xlsx(list(raw = read_counts_table, tpm = read_counts_table_tpm, discrete =discretizeDF(read_counts_table_tpm, default = list(method = "interval", breaks = 3, labels = c("low","medium", "high")))), path = paste(output_dir,"rpart_Tissue_Type.xlsx",sep=""))
#########################################################################################################
# Compute rpart model 
mreSummary <- function(data, lev = NULL, model = NULL) {
rmse=rmse(data$obs, data$pred) 
mae=mae(data$obs, data$pred)
mre=mre(data$obs, data$pred) 
cor=cor(data$obs, data$pred)
c(MRE = mre, RMSE=rmse, MAE = mae, Cor=cor)
}

# Train the model using the 'rpart' method
model_comb <-  caret::train(
  Tissue_Type ~ ., 
  data = read_counts_table_tpm_disc, 
  method = "rpart", 
  trControl = trainControl(method = "cv", number = 10, summaryFunction = mreSummary), # 10-fold cross-validation
  tuneLength = 10                                       # Evaluate 10 different 'cp' values
)



# bwplot               
png(filename=paste(output_dir,"rpart_Tissue_Type.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # Plot the bayesian network graph
  fancyRpartPlot(Tissue_Type_rpart, caption = NULL, sub=NULL)  
dev.off()

#########################################################################################################
set.seed(123) # Define a semente para reprodutibilidade
sample_ids_trainning<-sample(rownames(read_counts_table_tpm_disc), dim(read_counts_table_tpm_disc)[1]*0.50)
sample_ids_testing  <-rownames(read_counts_table_tpm_disc)[!rownames(read_counts_table_tpm_disc) %in% sample_ids_trainning]

Tissue_Type_rpart_trainning<-rpart(formula=Tissue_Type ~ ., data=data.frame(read_counts_table_tpm_disc[sample_ids_trainning,]),method = "class")
Tissue_Type_rpart_testing  <-rpart(formula=Tissue_Type ~ ., data=data.frame(read_counts_table_tpm_disc[sample_ids_testing,]),method = "class")


# 6. Model for combination of parameter
predictions <- predict(Tissue_Type_rpart_testing, data.frame(read_counts_table_tpm_disc[sample_ids_testing,]), type = "class")

# Confusion Matrix
conf_matrix <- table(Actual = as.vector((read_counts_table_tpm_disc[sample_ids_testing,"Tissue_Type"])), Predicted = as.vector(predictions))
# Accuracy calculation
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(accuracy)

#########################################################################################################
df_mean[c("ENSG00000277287.1","ENSG00000287325.1","ENSG00000140254.12","ENSG00000187094.12"),]

levels(factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000277287.1"),]))))
factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000287325.1"),])))
factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000140254.12"),])))
factor(as.vector(unlist(df_read_counts_table_tpm_disc_no_label[c("ENSG00000187094.12"),])))


