#########################################################################################################
# Make data discrete

### discretize all numeric columns differently
read_counts_table_tpm_disc <- discretizeDF(read_counts_table_tpm[rownames(res_tumor_normal),], default = list(
  method = "interval", breaks = 3,
  labels = c("low","medium", "high")
))

# Add tisue type to data.frame
read_counts_table_tpm_disc<-cbind(t(read_counts_table_tpm_disc),Tissue_Type=sample_sheet_data[colnames(read_counts_table_tpm_disc),"Tissue.Type"])

#########################################################################################################
# Make the read_counts_table_tpm_disc a data.frame
read_counts_table_tpm_disc<-data.frame(read_counts_table_tpm_disc)

# Convert to factors
read_counts_table_tpm_disc[sapply(read_counts_table_tpm_disc, is.character)] <- lapply(read_counts_table_tpm_disc[sapply(read_counts_table_tpm_disc, is.character)], as.factor)

# Keep only factors with more than one level
read_counts_table_tpm_disc <- read_counts_table_tpm_disc[, sapply(df, nlevels) > 1]

# Create bayesian networks
bn_cancer_data <- tabu(data.frame(read_counts_table_tpm_disc))

# bwplot               
png(filename=paste(output_dir,"Bayesian_Network_structure_Tissue_Type.png",sep=""), width = 17, height = 17, res=600, units = "cm")  
  # Plot the bayesian network graph
  plot(as.igraph(bn_cancer_data), vertex.color="black",vertex.size=25,vertex.label.color="orange",layout=layout_with_kk,  vertex.label=)
dev.off()
#########################################################################################################
set.seed(123) # Define a semente para reprodutibilidade
sample_ids_trainning<-sample(rownames(read_counts_table_tpm_disc), dim(read_counts_table_tpm_disc)[1]*0.75)
sample_ids_testing  <-rownames(read_counts_table_tpm_disc)[!rownames(read_counts_table_tpm_disc) %in% sample_ids_trainning]

#Predicted data
predicted_training_set         <- as.vector(predict(Tissue_Type_rpart, newdata = data.frame(read_counts_table_tpm_disc), type = "class"))

# Predicted data - Separate trainning versus testing
predicted_training_testing_set <- as.vector(predict(bn_cancer_data, newdata = data.frame(read_counts_table_tpm_disc[sample_ids_testing,]), type = "class"))

results_trainning <- confusionMatrix(data = factor(predicted_training_set), reference =  factor(data.frame(read_counts_table_tpm_disc)$Tissue_Type))
results_trainning_testing <- confusionMatrix(data = factor(predicted_training_testing_set), reference =  factor(data.frame(read_counts_table_tpm_disc[sample_ids_testing,])$Tissue_Type))


#########################################################################################################
