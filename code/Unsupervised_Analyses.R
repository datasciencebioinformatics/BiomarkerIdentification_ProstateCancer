#########################################################################################################
# Store nome of analyzed genes
# Flow rate	Inlet Temperature T1 	Inlet Temperature T2 			Inlet Pressure P1	Outlet Pressure P2	Shaft Torque
# TO DO : 
genes<-  rownames(res_tumor_normal) # selected genes

# Convert RPM to numeric
read_counts_table_tpm<-read_counts_table_tpm[genes,]

#########################################################################################################

# Specifying clustering from distance matrix
normalized_dist_tumor = dist(read_counts_table_tpm)

# dcols_normalized_dist_tumor
normalized_dcols_tumor = dist(t(read_counts_table_tpm))

# kmeans
kmeans_clusters<-c(kmeans(read_counts_table_tpm, centers=6, iter.max = 10, nstart = 1, trace = FALSE)$cluster)
#########################################################################################################
# Subset the 
df_normalized_merge<-read_counts_table_tpm

# Remove row lines
# Add k-means
annotation_row=sample_sheet_data[colnames(read_counts_table_tpm),"Tissue.Type"]

# Set the k-means clusters
annotation_row$Kmeans<-as.factor(kmeans_clusters)
###########################################################################################################
# Specify colors
ann_colors = list(Tissue.Type = c(Normal="lightgrey", Tumor="black"))

# Set the name for the k-means
names(ann_colors$Kmeans)<-c("1","2","3","4","5","6")

order_rows<-rownames(read_counts_table_tpm[,c("Q","Tm.i","Tm.o","P1","P2","T","pi","mi","mo")])[order(kmeans_clusters)]

df_normalized_merge<-df_normalized_merge[as.integer(order_rows),]

pheatmap(read_counts_table_tpm ,cluster_rows = TRUE,cluster_cols = TRUE, scale = "row")
#########################################################################################################
# Melt tabele
# Plot_raw_vibration_data.png                                                                                                            
png(filename=paste(project_folder,"ESPsViscousFluidFlow_Pheatmap.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # Add annotation : bhp, head, efficiency
  pheatmap(df_normalized_merge[,c("Q","Tm.i","Tm.o","P1","P2","T","pi","mi","mo")] , clustering_distance_cols = normalized_dcols_tumor,show_rownames = F,annotation_row = annotation_row,annotation_colors=ann_colors,cluster_rows = FALSE,cluster_cols = FALSE)
dev.off()
