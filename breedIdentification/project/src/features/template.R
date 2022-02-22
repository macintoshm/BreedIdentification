rm(list = ls())

library(data.table)

download.file(url="")

dat <- fread("./FILEPATHHERE.csv")


missingvalues <- stations[stations$names %in% trips$sstation | stations$names %in% trips$estation]

missingvalues <- stations[!stations$names %in% trips$sstation & !stations$names %in% trips$estation]

#stations$name returns it as a vector
#stations.(name) keeps it in data table 