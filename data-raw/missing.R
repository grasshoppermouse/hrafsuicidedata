
library(readr)
library(readxl)

#### Suicide extracts that were inadvertently omitted #####

d <- read_excel('data-raw/Missing suicide data.xlsx')
d$id <- as.character(2000:(1999 + nrow(d)))

d$punishment_threat[is.na(d$punishment_threat)] <- 0
d$Document <- NULL
d$Notes <- NULL
