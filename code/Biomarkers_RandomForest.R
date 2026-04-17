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
set.seed(123) # Define a semente para reprodutibilidade
sample_ids_trainning<-sample(rownames(read_counts_table_tpm), dim(read_counts_table_tpm)[1]*0.75)
sample_ids_testing  <-rownames(read_counts_table_tpm)[!rownames(read_counts_table_tpm) %in% sample_ids_trainning]

# Compute rpart model trainning only
Tissue_type_randomForest<-rfsrc(formula=Tissue_type ~ ., data=read_counts_table_tpm)

# Separate trainning versus testing
Tissue_type_randomForest_trainning_testing<-rfsrc(formula=Tissue_type ~ ., data=data.frame(read_counts_table_tpm[sample_ids_trainning,]))

#Predicted data
predicted_training_set         <- as.vector(predict(Tissue_type_randomForest, newdata = data.frame(read_counts_table_tpm), type = "class"))

# Predicted data - Separate trainning versus testing
predicted_training_testing_set <- as.vector(predict(Tissue_type_randomForest_trainning_testing, newdata = data.frame(read_counts_table_tpm[sample_ids_testing,]), type = "class"))


results_trainning <- confusionMatrix(data = factor(predicted_training_set), reference =  factor(data.frame(read_counts_table_tpm)$Tissue_Type))
results_trainning_testing <- confusionMatrix(data = factor(predicted_training_testing_set), reference =  factor(data.frame(read_counts_table_tpm[sample_ids_testing,])$Tissue_Type))
