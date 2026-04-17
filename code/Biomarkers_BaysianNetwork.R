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

# Create bayesian networks
bn_cancer_data_trainning             <- tabu(data.frame(read_counts_table_tpm_disc[sample_ids_testing,]))
bn_cancer_data_testing_set           <- tabu(data.frame(read_counts_table_tpm_disc[sample_ids_trainning,]))


# Create bayesian networks
bn_cancer_data                      = bn.fit(bn_cancer_data_trainning,   data.frame(read_counts_table_tpm_disc[sample_ids_testing,]),method = "mle")
bn_cancer_data_training_testing_set = bn.fit(bn_cancer_data_testing_set, data.frame(read_counts_table_tpm_disc[sample_ids_trainning,]),method = "mle")


# Predicted data - Separate trainning versus testing
predictions             <- predict(bn_cancer_data, node = "Tissue_Type", data =  data.frame(read_counts_table_tpm_disc[sample_ids_trainning,]), method = "parents")


# Confusion Matrix
conf_matrix <- table(Actual = as.vector((read_counts_table_tpm_disc[sample_ids_testing,"Tissue_Type"])), Predicted = as.vector(predictions))
# Accuracy calculation
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(accuracy)
                                  

