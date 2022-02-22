rm(list =ls())
library(data.table)
library(caret)
library(ClusterR)
library(Rtsne) 
library(ggplot2)

data <- fread("./project/volume/data/raw/data.csv")

#ALWAYS ADD A SEED
set.seed(9001)

#- store and remove the ids
id <- data$id
data$id <- NULL

#24 and 47 are the best perplexities I have found
p1 <- 24
p2 <- 44

tsne_dat <- Rtsne(data, 
                  pca=T, 
                  perplexity = p1,
                  check_duplicates = F, max_iter = 5000)

tsne_data_table <- data.table(tsne_dat$Y)

tsne_dat2 <- Rtsne(data,
                   pca=T,
                   perplexity = p2,
                   check_duplicates = F, max_iter = 5000)

tsne_data_table2 <- data.table(tsne_dat2$Y)
setnames(tsne_data_table2, c("V1", "V2"), c("V3", "V4"))

newTSNEtable <- cbind(tsne_data_table, tsne_data_table2)

opt_num_clus <- 4
gmm_data <- GMM(newTSNEtable[,.(V1,V2, V3, V4)],opt_num_clus)

clusterInfo <- predict_GMM(newTSNEtable[,.(V1,V2, V3, V4)],
                           gmm_data$centroids,
                           gmm_data$covariance_matrices,
                           gmm_data$weights)
# clusterInfo contains a lot of information which we can extract
clusterInfo$log_likelihood
clusterInfo$cluster_proba
clusterInfo$cluster_labels
temp <- data.table(clusterInfo$cluster_proba)

tsne_data_table <- cbind(tsne_data_table, cluster=clusterInfo$cluster_labels)

    
ggplot(tsne_data_table,aes(V1, V2)) + geom_point(aes(color=cluster)) +
      annotate("text", x=30, y=45, label= p1) + 
      annotate("text", x = 30, y=35, label = p2)

temp <- cbind(temp, id)

setnames(temp, c("V1", "V2", "V3", "V4"), c("Breed4", "Breed3", "Breed2", "Breed1"))

fwrite(temp,'./project/volume/data/processed/PCA_TSNE.csv')




