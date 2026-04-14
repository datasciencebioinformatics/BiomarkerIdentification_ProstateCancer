#########################################################################################################
# https://graysonwhite.com/gglm/reference/gglm.html
# Provides four standard visual model diagnostic plots with `ggplot2`.
# Train bayesian network from discrete data 
#########################################################################################################
Tissue_type_randomForest<-rfsrc(formula=Tissue_type ~ ., data=read_counts_table_tpm)

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
png(filename=paste(output_dir,"VarImp_Efficency_BHP_H.png",sep=""), width = 15, height = 15, res=600, units = "cm")  
  # Plot the OOB errors
  p + ggtitle("Variable importance")
dev.off()

########################################################################################################
