#########################################################################################################
# Create bayesian networks
bn_cancer_data <- hc(data.frame(read_counts_table_tpm_disc))

# bwplot               
png(filename=paste(output_dir,"Bayesian_Network_structure_Tissue_Type.png",sep=""), width = 17, height = 17, res=600, units = "cm")  
  # Plot the bayesian network graph
  plot(as.igraph(tb_viscour), vertex.color="black",vertex.size=25,vertex.label.color="orange",layout=layout_with_kk)
dev.off()
#########################################################################################################
