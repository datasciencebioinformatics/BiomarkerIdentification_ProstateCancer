#########################################################################################################
Tissue_type_lm          <-lm(formula=Tissue_type  ~ ., data=read_counts_table_tpm)
Tissue_type_randomForest<-rfsrc(formula=Tissue_type  ~ ., data=read_counts_table_tpm)
#########################################################################################################
# Save random forest results in a table
Tissue_type_results<- vimp.rfsrc(Tissue_type_randomForest)$importance
Tissue_type_varsel <- var.select(Tissue_type_randomForest)

# Save the gg_minimal_depth object for later use.
Tissue_type_md     <- gg_minimal_depth(Tissue_type_varsel)

# Store in a table
minimal_depth<-Tissue_type_md$varselect[,c("depth","names")]

# Store in data framne
minimal_depth[names(Tissue_type_results),"varImp"]<-as.vector(Tissue_type_results)

# Add intercept rown
intercetp_row<-t(data.frame("Intercept"=c(depth=NA,names=NA,varImp=NA)))

# Bind collumns
minimal_depth<-rbind(minimal_depth,intercetp_row)
#########################################################################################################
# Save linear regression results in a table
df_lm<-data.frame(summary(Tissue_type_lm)$coefficients)

# Rename Intercept 
rownames(df_lm)[1]<-"Intercept"
#########################################################################################################
# Take the order of the variables
order_variables<-rownames(df_lm)

# Merge tables
merge_tables<-cbind(df_lm[order_variables,],minimal_depth[order_variables,c("varImp","depth")])

# Set colnames
colnames(merge_tables)<-c("Estimate","Std.Error","t.value","Pr.t","varImp","depth")

# Set variable names
merge_tables$variables<-rownames(merge_tables)

# Merge tables
write_tsv(merge_tables, path = paste(output_dir,"lm_rf_associations.txt",sep=""))
