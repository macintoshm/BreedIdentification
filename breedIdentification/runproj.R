# this is the file where you will source all your other files/scripts.
# this is the only file that will be exucuted while graded. 

#install.packages("Rtsne")

rm(list =ls())
library(data.table)
library(caret)
library(ClusterR)
library(Rtsne) 
library(ggplot2)

source("project/src/models/GMM_PCA.R")
