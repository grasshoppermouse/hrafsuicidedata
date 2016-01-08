library(hrafsuicidedata)

##Entry errors
apology$transgression[apology$id == 446] = '0'
apology$transgression[apology$id == 766] = '0'

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

