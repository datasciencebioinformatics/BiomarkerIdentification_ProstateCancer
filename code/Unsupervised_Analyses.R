#########################################################################################################
# Store nome of analyzed genes
# Flow rate	Inlet Temperature T1 	Inlet Temperature T2 			Inlet Pressure P1	Outlet Pressure P2	Shaft Torque
# TO DO : 
genes<-  res_tumor_normal # selected genes

# Convert RPM to numeric
read_counts_table_tpm<-read_counts_table_tpm[,genes]

#########################################################################################################
# https://graysonwhite.com/gglm/reference/gglm.html
# Provides four standard visual model diagnostic plots with `ggplot2`.
# Train bayesian network from discrete data 
colnames(read_counts_table_tpm)<- # Use correspondence_table to set gene symbols as colnames
#########################################################################################################
# Add stages collumns
read_counts_table_tpm$n<-cut(read_counts_table_tpm$n, quantile(read_counts_table_tpm$n, c(0:3/3)), include.lowest = T, labels = c("Low", "Medium", "High"))
read_counts_table_tpm$BHP<-cut(read_counts_table_tpm$BHP, quantile(read_counts_table_tpm$BHP, c(0:3/3)), include.lowest = T, labels = c("Low", "Medium", "High"))
read_counts_table_tpm$H<-cut(read_counts_table_tpm$H, quantile(read_counts_table_tpm$H, c(0:3/3)), include.lowest = T, labels = c("Low", "Medium", "High"))
###########################################################################################################
# Specifying clustering from distance matrix
normalized_dist_viscous = dist(read_counts_table_tpm[,c("Q","Tm.i","Tm.o","P1","P2","T","pi","mi","mo")])

# dcols_normalized_dist_viscous
normalized_dcols_viscous = dist(t(read_counts_table_tpm[,c("Q","Tm.i","Tm.o","P1","P2","T","pi","mi","mo")]))

# kmeans
kmeans_clusters<-c(kmeans(read_counts_table_tpm[,c("Q","Tm.i","Tm.o","P1","P2","T","pi","mi","mo")], centers=6, iter.max = 10, nstart = 1, trace = FALSE)$cluster)
#########################################################################################################
# Subset the 
df_normalized_merge<-read_counts_table_tpm[,c("Q","Tm.i","Tm.o","P1","P2","T","pi","mi","mo","n","BHP","H")]

# Force rownames
rownames(df_normalized_merge)<-paste0("Signal_", seq(nrow(df_normalized_merge)))

# Remove row lines
# Add k-means
annotation_row=df_normalized_merge[,c("n","BHP","H")]

# Set the k-means clusters
annotation_row$Kmeans<-as.factor(kmeans_clusters)
###########################################################################################################
# Specify colors
ann_colors = list(n = c(Low="lightgrey", Medium="darkgrey",High="black"), BHP = c(Low="lightgrey", Medium="darkgrey",High="black"), H = c(Low="lightgrey", Medium="darkgrey",High="black"),Kmeans = c("#DF536B","#61D04F","#2297E6", "#28E2E5","#CD0BBC", "#F5C710" ) )

# Set the name for the k-means
names(ann_colors$Kmeans)<-c("1","2","3","4","5","6")

order_rows<-rownames(read_counts_table_tpm[,c("Q","Tm.i","Tm.o","P1","P2","T","pi","mi","mo")])[order(kmeans_clusters)]

df_normalized_merge<-df_normalized_merge[as.integer(order_rows),]
#########################################################################################################
# Melt tabele
# Plot_raw_vibration_data.png                                                                                                            
png(filename=paste(project_folder,"ESPsViscousFluidFlow_Pheatmap.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # Add annotation : bhp, head, efficiency
  pheatmap(df_normalized_merge[,c("Q","Tm.i","Tm.o","P1","P2","T","pi","mi","mo")] , clustering_distance_cols = normalized_dcols_viscous,show_rownames = F,annotation_row = annotation_row,annotation_colors=ann_colors,cluster_rows = FALSE,cluster_cols = FALSE)
dev.off()
