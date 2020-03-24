library(RSQLite)
library(tidyverse)
library(devtools)

hraf <- dbConnect(SQLite(), flags = SQLITE_RO, dbname = 'data-raw/hraf')
dbListTables(hraf)

author <- dbReadTable(hraf, 'data2_author')
culture <- dbReadTable(hraf, 'data2_culture')
document <- dbReadTable(hraf, 'data2_document')
document_authors <- dbReadTable(hraf, 'data2_document_authors')
extract <- dbReadTable(hraf, 'data2_extract')
paragraphs <- dbReadTable(hraf, 'data2_paragraphs')
project <- dbReadTable(hraf, 'data2_project')