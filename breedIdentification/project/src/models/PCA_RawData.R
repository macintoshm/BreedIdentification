rm(list =ls())
library(data.table)
library(ggplot2)
library(caret)
library(ClusterR)
library(Metrics)


data <- fread("./project/volume/data/raw/data.csv")


#ALWAYS ADD A SEED
set.seed(9001)

#- store and remove the wine types
id <- data$id
data$id <- NULL

# lets consider Gaussian mixture models GMM
max_clus <- 6
# will do GMM for k 1 to max_clus
#helps estimate what k should be 
#Hirotugu Akaike  made AIC 
# AIC estimates the test set error w/o having a test set 
# 2*(numParameters) - 2*loglikelihood
k_aic <- Optimal_Clusters_GMM(data, 
                              max_clusters = max_clus,
                              criterion = "AIC")


#we have to find biggest drop 
# how to determine the number of clusters
delta_k <- c(NA,k_aic[-1] - k_aic[-length(k_aic)])
del_k_tab <- data.table(delta_k=delta_k, k=1:length(delta_k))
# lets look at the change in slope
ggplot(del_k_tab,aes(x=k,y=-delta_k))+geom_point()+geom_line()+
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10))+
  geom_text(aes(label=k),hjust=0, vjust=-1)

#2 is the highest, so we will use 2 as k 

# For our assignment we "know" the correct number of clusters
opt_num_clus <- 4
gmm_data <- GMM(data,opt_num_clus)

clusterInfo <- predict_GMM(data,
                           gmm_data$centroids,
                           gmm_data$covariance_matrices,
                           gmm_data$weights)
# clusterInfo contains a lot of information which we can extract
clusterInfo$log_likelihood
clusterInfo$cluster_proba 
clusterInfo$cluster_labels

temp <- data.table(clusterInfo$cluster_proba)

setnames(temp, c("V1", "V2", "V3", "V4"), c("Breed4", "Breed3", "Breed2", "Breed1"))

temp <- cbind(temp, id)


fwrite(temp,'./project/volume/data/processed/PCA_RawData.csv')

