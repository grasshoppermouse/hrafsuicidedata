library(hrafsuicidedata)

##Entry errors
apology$transgression[apology$id == 446] = '0'
apology$transgression[apology$id == 766] = '0'

##Remove duplicates
apology <- apology[apology$id != 634,]
apology = apology[apology$id != 1788,]
apology = apology[apology$id != 1894,]
apology = apology[apology$id != 1903,]
apology = apology[apology$id != g,]

