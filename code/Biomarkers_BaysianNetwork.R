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
read_counts_table_tpm_disc <- read_counts_table_tpm_disc[, sapply(read_counts_table_tpm_disc, nlevels) > 1]

# Create bayesian networks
bn_cancer_data <- tabu(data.frame(read_counts_table_tpm_disc))

# Make a copy of correspondece table 
correspondence_table_bck<-correspondence_table

# Add Tissue_type to correspondence_table
correspondence_table_bck<-rbind(correspondence_table_bck,data.frame(gene_id="Tissue_Type",gene_name="Tissue_Type"))

# Set rownames
rownames(correspondence_table_bck)<-correspondence_table_bck$gene_id


# bwplot               
png(filename=paste(output_dir,"Bayesian_Network_structure_Tissue_Type.png",sep=""), width = 25, height = 25, res=600, units = "cm")  
  # Plot the bayesian network graph
  plot(as.igraph(bn_cancer_data), layout=layout_with_fr, vertex.label =correspondence_table_bck[V(as.igraph(bn_cancer_data))$name,"gene_name"], vertex.size = 20)
dev.off()
#########################################################################################################
set.seed(123) # Define a semente para reprodutibilidade
sample_ids_trainning<-sample(rownames(read_counts_table_tpm_disc), dim(read_counts_table_tpm_disc)[1]*0.75)
sample_ids_testing  <-rownames(read_counts_table_tpm_disc)[!rownames(read_counts_table_tpm_disc) %in% sample_ids_trainning]

# Create bayesian networks
bn_cancer_data                      <- tabu(data.frame(read_counts_table_tpm_disc))
bn_cancer_data_training_testing_set <- tabu(data.frame(read_counts_table_tpm_disc[sample_ids_trainning,]))


# Create bayesian networks
bn_cancer_data                      = bn.fit(bn_cancer_data, data.frame(read_counts_table_tpm_disc),method = "mle")
bn_cancer_data_training_testing_set = bn.fit(bn_cancer_data_training_testing_set, data.frame(read_counts_table_tpm_disc[sample_ids_trainning,]),method = "mle")


# Predicted data - Separate trainning versus testing
predicted_training             <- predict(bn_cancer_data, node = "Tissue_Type", data = data.frame(read_counts_table_tpm_disc), method = "parents")
predicted_training_testing_set <- predict(bn_cancer_data_training_testing_set, node = "Tissue_Type", data = data.frame(read_counts_table_tpm_disc[sample_ids_testing,]), method = "parents")
                                  

results_trainning <- confusionMatrix(data = factor(predicted_training), reference =  factor(data.frame(read_counts_table_tpm_disc)$Tissue_Type))
results_trainning_testing <- confusionMatrix(data = factor(predicted_training_testing_set), reference =  factor(data.frame(read_counts_table_tpm_disc[sample_ids_testing,])$Tissue_Type))

write.table(data.frame(results_trainning$overall), file = paste(output_dir,"confusionMatrix_bn_all.txt",sep=""),, sep = "\t", row.names = TRUE, append=FALSE)
write.table(data.frame(results_trainning$table), file = paste(output_dir,"confusionMatrix_bn_all.txt",sep=""),, sep = "\t", row.names = TRUE, append=TRUE)

write.table(data.frame(results_trainning_testing$overall), file = paste(output_dir,"confusionMatrix_bn_testing.txt",sep=""),, sep = "\t", row.names = TRUE, append=FALSE)
write.table(data.frame(results_trainning_testing$table), file = paste(output_dir,"confusionMatrix_bn_testing.txt",sep=""),, sep = "\t", row.names = TRUE, append=TRUE)


#########################################################################################################
