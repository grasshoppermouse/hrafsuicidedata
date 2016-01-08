library(hrafsuicidedata)

##Entry errors
apology$transgression[apology$id == 446] = '0'
apology$transgression[apology$id == 766] = '0'

#Clean up new data
d$unjustly_accused_punished[d$unjustly_accused_punished=='not_applicable'] = '0'
d$unjustly_accused_punished <- as.numeric(d$unjustly_accused_punished)

##Remove duplicates and blank data
apology <- apology[apology$id != 634,]
apology = apology[apology$id != 1788,]
apology = apology[apology$id != 1894,]
apology = apology[apology$id != 1903,]
apology = apology[apology$id != 'g',]

#Remove 1909 from apology
apology <- apology[apology$id != 1909,]

#Merge apology and transgression_data in d
d$content_type.y <- NULL
d$coder.y <- NULL
d$culture.y <- NULL
d$extract.y <- NULL
d$transgression.y <- NULL

#Heatmap
aheatmap(d[,c(7:13, 15)], hclustfun = 'ward')
library(pvclust)
m<-pvclust(d[,c(7:13, 15)])
plot(m)
