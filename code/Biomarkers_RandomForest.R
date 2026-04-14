#########################################################################################################
# https://graysonwhite.com/gglm/reference/gglm.html
# Provides four standard visual model diagnostic plots with `ggplot2`.
# Train bayesian network from discrete data 
#########################################################################################################
# Add tisue type to data.frame
read_counts_table_tpm_complete<-data.frame(cbind(t(read_counts_table_tpm),Tissue_Type=sample_sheet_data[colnames(read_counts_table_tpm),"Tissue.Type"]))

# Convert to factor
read_counts_table_tpm_complete$Tissue_Type<-factor(read_counts_table_tpm_complete[,"Tissue_Type"])

Tissue_type_randomForest<-rfsrc(formula=Tissue_Type ~ ., data=data.frame(read_counts_table_tpm_complete))

#########################################################################################################
# Save Efficiency, BHP and HEAD
Tissue_type_results=vimp.rfsrc(Tissue_type_randomForest)$importance

# Caculate varImp for all the three models
df_varImp_results<-data.frame(Efficiency=data.frame(Tissue_type_results))

# Set the rownames
df_varImp_results$Var<-rownames(df_varImp_results)

# Melt the data
melt_varImp_results<-melt(df_varImp_results)

# Change the colors manually
p <- ggplot(data=melt_varImp_results, aes(x=Var, y=value)) + geom_bar(stat="identity", color="black", position=position_dodge()) + theme_minimal() + facet_grid(rows = vars(variable),scale="free")

# bwplot               
png(filename=paste(output_dir,"rf_varIMP_Tissue_Type.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # Plot the OOB errors
  p + ggtitle("Variable importance")
dev.off()

########################################################################################################

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
