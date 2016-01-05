
library(dplyr)
# Suicide attempt and mortality data from CDC
cdc = read.delim('data-raw/CDC-2001-2011.txt')
cdc$age2 = cdc$age2 + 2.5 # Put in middle of original age range, instead of beginning

cdc = rename(cdc, `Suicide rate` = suiciderate, `Attempt rate` = selfharmrate)

save(cdc, file = "data/cdc.RData", compress = "xz")
