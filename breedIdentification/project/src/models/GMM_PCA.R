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

pca <- prcomp(data, scale. = TRUE)

# look at the variance and cummulative variance
summary(pca)
#- looks like 1 or 2 components is enough

# extract the components so i can use them in PCA
pca_dt <- data.table(unclass(pca)$x)


# For our assignment we "know" the correct number of clusters
opt_num_clus <- 4
gmm_data <- GMM(pca_dt[,1:3],opt_num_clus)

clusterInfo <- predict_GMM(pca_dt[,1:3],
                           gmm_data$centroids,
                           gmm_data$covariance_matrices,
                           gmm_data$weights)
# clusterInfo contains a lot of information which we can extract
clusterInfo$log_likelihood
clusterInfo$cluster_proba
clusterInfo$cluster_labels


temp <- data.table(clusterInfo$cluster_proba)

temp <- cbind(temp, id)

setnames(temp, c("V1", "V2", "V3", "V4"), c("Breed1", "Breed2", "Breed4", "Breed3"))

fwrite(temp,'./project/volume/data/processed/PCA.csv')

