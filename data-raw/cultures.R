
library(dplyr)
library(tidyr)

# Read raw data
Culture.codes <- read.delim("data-raw/Culture codes.txt")
cultures = read.delim('data-raw/cultures.txt', na.string='NA', as.is=T)
all_hraf_cultures <- read.delim("data-raw/eHRAFWC-All-Cultures-to-E59-2.txt")
load('data-raw/sccs.RData')
sccs = as.data.frame(sccs)

# ID's of SCCS cultures that correspond to HRAF probability sample cultures
sccs.nums=c(19,37,79,172,28,7,140,76,121,109,124,24,87,12,69,181,26,51,149,85,112,125,16,94,138,116,158,57,102,4,34,182,13,127,52,62,165,48,42,36,113,152,100,16,132,98,167,154,21,120)

# Descent  V70
# Women involvement in public politics    V793
# Women involvement in private politics    V794
# Polygamy (polygyny and polyandry)	V79 # This one might be important
## Complexity variables
#    Urbanization V152
#    Population density V156
#    Stratification V158
#    Sum of complexity	V158.1
# Ease of initiating divorce	V610
# Marriage arrangements	V739
# Composite of Male Dominance	V670
# Marital Residence	V69

sccs.vars=c('SOCNAME', 'V70', 'V793', 'V794', 'V79', 'V152', 'V156', 'V158', 'V158.1', 'V610', 'V739', 'V670', 'V69')
sccs.2=sccs[sccs.nums, sccs.vars]

Culture.codes$SCCS = as.character(Culture.codes$SCCS)
sccs.2 = merge(sccs.2, Culture.codes, by.x='row.names', by.y='SCCS')

cultures = merge(cultures, all_hraf_cultures[,c('OWC', 'SUBSISTENCE.TYPE')], by.x='Culture.code', by.y='OWC', all.x=T)

# Consolidate and relabel subsistence types
cultures$SUBSISTENCE.TYPE[cultures$SUBSISTENCE.TYPE=='primarily hunter-gatherers'] = 'hunter-gatherers' # 2 of these
cultures$SUBSISTENCE.TYPE[cultures$SUBSISTENCE.TYPE=='agro-pastoralists'] = 'intensive agriculturalists' # 1 of these
cultures$subsistence = factor(cultures$SUBSISTENCE.TYPE, 
                              levels = c("hunter-gatherers", "horticulturalists", "pastoralists", "intensive agriculturalists", "other subsistence combinations"),
                              labels = c("hunter-gatherers", "horticulturalists", "pastoralists", "intensive agriculturalists", "other")
)
cultures$SUBSISTENCE.TYPE = NULL

# Add continental regions to cultures
cultures$Region2 = cultures$Region #rep('x', length(57))

cultures$Region2[grepl('Africa', cultures$Region)] = 'Africa'
cultures$Region2[grepl('Asia', cultures$Region)] = 'Asia'
cultures$Region2[grepl('North America', cultures$Region)] = 'North America'
cultures$Region2[grepl('South America', cultures$Region)] = 'South America'
cultures$Region2[grepl('Europe', cultures$Region)] = 'Europe'
cultures$Region2[grepl('Oceania', cultures$Region)] = 'Oceania'

# A bit more consolidation of regions to simplify charts

cultures$Region3 = cultures$Region2
cultures$Region3[cultures$Region3=='Eurasia'] = 'Asia'
cultures$Region3[cultures$Region3=='Middle American, Carribbean'] = 'North America'

# Add sccs data to cultures data frame
cultures = merge(cultures, sccs.2, by='Culture.code', all=T)

# polygyny variables
cultures$V79.3 = as.character(cultures$V79)

cultures$V79.3[cultures$V79=='Polygyny >20% plural wives'] = 'Frequent polygyny'
cultures$V79.3[cultures$V79=='Polygyny < 20% plural wives'] = 'Rare polygyny'

cultures$V79.3[cultures$Name=='Bengali'] = 'Rare polygyny'
cultures$V79.3[cultures$Name=='Bena'] = 'Frequent polygyny'
cultures$V79.3[cultures$Name=='Banyoro'] = 'Frequent polygyny'
cultures$V79.3[cultures$Name=='Bagisu'] = 'Frequent polygyny'
cultures$V79.3[cultures$Name=='Bahia Brazilians'] = 'Rare polygyny'
cultures$V79.3[cultures$Name=='Ona'] = 'Rare polygyny'
cultures$V79.3[cultures$Name=='Sinhalese'] = 'Rare polygyny'
cultures$V79.3[cultures$Name=='Libyan Bedouin'] = 'Frequent polygyny'
cultures$V79.3[cultures$Name=='Pawnee'] = 'Rare polygyny'
cultures$V79.3[cultures$Name=='Kogi'] = 'Rare polygyny'

cultures$V79.3 = factor(cultures$V79.3, levels=c('Frequent polygyny', 'Rare polygyny', 'Monogamy'))

# Rename V158.1
cultures$complexity = cultures$V158.1

# Relabel post marital residence pattern
cultures$postmarital.residence = factor(cultures$V69, labels=c("Neolocal", "Ambilocal", "Patrilocal/virilocal", "Avunculocal", "Matrilocal/uxorilocal"))

# Relabel descent systems
cultures$descent = factor(cultures$V70, labels=c("Bilateral", "Ambilineal", "Patrilineal", "Double descent", "Matrilineal"))

### Convert 'position' to long and lat ###

cultures$longitude = NA
cultures$latitude = NA

for (i in 1:nrow(cultures)){
    
    tmp = as.numeric(strsplit(cultures$Position[i], ',')[[1]])
    cultures$latitude[i] = tmp[1]
    cultures$longitude[i] = tmp[2]
    
}

# Select only cultures in the PS, and relevant variables

cultures_original <- cultures

cultures <- cultures_original %>%
    filter(Probability.sample == 'True') %>%
    select(
        Culture.code,
        Name,
        Region,
        Continental_region = Region3,
        subsistence,
        complexity,
        postmarital.residence,
        descent,
        longitude,
        latitude
    )

save(cultures, cultures_original, file = "data/cultures.RData", compress = "xz")
