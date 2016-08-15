
library(dplyr)
library(tidyr)
library(readr)
library(readxl)

# Input suicide coding data

# suicide coding.4.txt removed all quote marks, whereas .3. has them.
d1 = read.delim('data-raw/suicide coding.4.txt', stringsAsFactors=FALSE, na.string=c('na', 'NA'), fill=F, quote="")

# Read Syme Garfield reconciled version, which overrides the 17 theoretical variables, and adds two more

rec = read.delim("data-raw/Final Reconciliation.txt", stringsAsFactors=FALSE, na.string=c('', 'na', 'NA'), fill=F)

# All coding is now identical, so only need data from 1 coder
rec = rec[rec$coder=='syme',]

# ex_doc has the document id's and years for each extract id
ex_doc = read.csv('data-raw/extract document id codes.txt')
ex_doc$document.year[ex_doc$document.year==0] = NA
documents = read.delim('data-raw/documents.tsv', as.is=c('field_years', 'location', 'title', 'authors', 'publisher'))

ex_doc$document.authors = NA
for (i in 1:nrow(ex_doc)){
    ex_doc$document.authors[i] = documents$authors[documents$id==ex_doc$document.id[i]]
}

d1 = merge(d1, ex_doc, by.x='id', by.y='extract.id')


# Remove cultures that are not in the probability sample
remove = c('Nuer', 'Igbo', 'Bakairi', 'Bagisu', 'Banyoro', 'Bena', 'Bengali')
d1 = d1[!(d1$culture %in% remove),]
rec = rec[!(rec$culture %in% remove),]

# Remove death of a loved one, already coded
d1$Traumatic_events[d1$Traumatic_events == 'death of a loved one'] = NA

# Fix entry error
d1$group_size[d1$id == 1902] = '2'

# Fix entry error
d1$group_size[d1$id == 1902] = '2'

# Fix entry error
d1$Evidence_Mental_Illness[d1$id == 515] = 'Evidence for'

# Fix entry error
d1$content_type[d1$id == 39] = 'Cultural model'

# Fix entry error
d1$content_type[d1$id == 144] = 'Cultural model'

# Fix entry error
d1$content_type[d1$id == 1908] = 'Cultural model'

# Fix entry error
d1$SA_sex[d1$id == 117] = 'both'

# Fix entry error
d1$SA_sex[d1$id == 134] = 'both'

# Fix entry error
d1$SA_sex[d1$id == 135] = 'male'

# Fix entry error
d1$SA_age[d1$id == 135] = 'adult'

# Create group size variable that excludes population rates
d1$group_size2 = rep(NA, length(d1$group_size))
d1$group_size2[d1$group_size == '1'] = '1'
d1$group_size2[d1$group_size == '2'] = '2'
d1$group_size2[d1$group_size == '1,2'] = '2'
d1$group_size2[d1$group_size == '1 or 2'] = '2'
d1$group_size2[d1$group_size == '1s 1a'] = '2'
d1$group_size2[d1$group_size == '3'] = '>2'
d1$group_size2[d1$group_size == '4'] = '>2'
d1$group_size2[d1$group_size == '26s 1a'] = '>2'
d1$group_size2[d1$group_size == '100+'] = '>2'
d1$group_size2[d1$group_size == 'group'] = '>2'
d1$group_size2[d1$group_size == 'many'] = '>2'
d1$group_size2[d1$group_size == 'unknown'] = '>2'

# Fix method typos

d1$Method = as.character(d1$Method)
d1$Method[d1$Method == 'ask_someone_else,not stated'] = 'ask_someone_else,not_stated'
d1$Method[d1$Method == 'ask_someone_else'] = 'ask_someone_else,not_stated'
d1$Method[d1$Method == 'not stated,will to die'] = 'will to die'

# Number of methods
d1$num_methods = rep(NA, length(d1$Method))

for (i in 1:length(d1$Method)){
  d1$num_methods[i] = length(strsplit(as.character(d1$Method[i]), ',')[[1]])
}

d1$SA_rel2 = as.character(d1$SA_relationship) # Make a copy of SA_relationship
d1$SA_rel2[d1$SA_relationship == 'Wives'] = 'spouse' # Set 'Wives' to 'spouse'
d1$SA_rel2[d1$SA_relationship == 'wife'] = 'spouse'
d1$SA_rel2[d1$SA_relationship == 'husband'] = 'spouse'
d1$SA_rel2[d1$SA_relationship == 'spouse,partner'] = 'spouse'
d1$SA_rel2[d1$SA_relationship == 'accusers']='social partners'
d1$SA_rel2[d1$SA_relationship == 'adversary']='social partners'
d1$SA_rel2[d1$SA_relationship == 'affine']='affines'
d1$SA_rel2[d1$SA_relationship == 'avenger']='social partners'
d1$SA_rel2[d1$SA_relationship == 'brother in law/husband']='affines'
d1$SA_rel2[d1$SA_relationship == 'chief']='social superior'
d1$SA_rel2[d1$SA_relationship == 'competitor']='sexual competitor'
d1$SA_rel2[d1$SA_relationship == 'adversary']='social partners'
d1$SA_rel2[d1$SA_relationship == 'enemies']='social partners'
d1$SA_rel2[d1$SA_relationship == 'father']='parents'
d1$SA_rel2[d1$SA_relationship == 'father in law']='affines'
d1$SA_rel2[d1$SA_relationship == 'brother']='siblings'
d1$SA_rel2[d1$SA_relationship == 'competitor ']='sexual competitor'
d1$SA_rel2[d1$SA_relationship == 'competitor']='sexual competitor'
d1$SA_rel2[d1$SA_relationship == 'exwife']='exspouse'
d1$SA_rel2[d1$SA_relationship == 'family']='parents'
d1$SA_rel2[d1$SA_relationship == 'mother in law']='affines'
d1$SA_rel2[d1$SA_relationship == 'kin group']='kin'
d1$SA_rel2[d1$SA_relationship == 'mother in law']='affines'
d1$SA_rel2[d1$SA_relationship == 'Outgroup']='outgroup'
d1$SA_rel2[d1$SA_relationship == 'paramour']='sexual competitor'
d1$SA_rel2[d1$SA_relationship == 'uncle']='kin'
d1$SA_rel2[d1$SA_relationship == 'mother']='parents'
d1$SA_rel2[d1$SA_relationship == 'social partner']='social partners'
d1$SA_rel2[d1$SA_relationship == 'son']='offspring'
d1$SA_rel2[d1$SA_relationship == 'authorities,parents,spouse']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'brothers,social group']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'cowife,affines']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'father,chief']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'father,others']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'parents,peers']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'mate/potential mate']='potential spouse'
d1$SA_rel2[d1$SA_relationship == 'kin,potential mates']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'kin,social group']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'husband,others,unknown']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'ingroup and outgroup']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'kin,husband']='multiple kin'
d1$SA_rel2[d1$SA_relationship == 'uncle,spouse']='multiple kin'
d1$SA_rel2[d1$SA_relationship == 'wife,sons']='multiple kin'
d1$SA_rel2[d1$SA_relationship == 'wife,kin']='multiple kin'
d1$SA_rel2[d1$SA_relationship == 'wife,social group']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'father,brother']='multiple kin'
d1$SA_rel2[d1$SA_relationship == 'government']='political power'
d1$SA_rel2[d1$SA_relationship == 'political group']='political power'
d1$SA_rel2[d1$SA_relationship == 'slaver owners']='captors'
d1$SA_rel2[d1$SA_relationship == 'slave owners']='captors'
d1$SA_rel2[d1$SA_relationship == 'superior']='social superior'
d1$SA_rel2[d1$SA_relationship == 'employer']='employers'
d1$SA_rel2[d1$SA_relationship == 'police']='social superior'
d1$SA_rel2[d1$SA_relationship == 'social group']='social partners'
d1$SA_rel2[d1$SA_relationship == 'wife,kin group']='multiple social domains'
d1$SA_rel2[d1$SA_relationship == 'husband,others unknown']='multiple social domains'

# Make a copy of Traumatic_events
d1$Traum_event2 = as.character(d1$Traumatic_events)
d1$Traum_event2[d1$Traumatic_events == 'perpetrate violence,no evidence']='perpetrate violence'
d1$Traum_event2[d1$Traumatic_events == 'physical abuse,sexual abuse']='sexual abuse'
d1$Traum_event2[d1$Traumatic_events == 'war,no evidence']='trauma related to war'
d1$Traum_event2[d1$Traumatic_events == 'war']='trauma related to war'
d1$Traum_event2[d1$Traumatic_events == 'war,refugee']='trauma related to war'
d1$Traum_event2[d1$Traumatic_events == 'war,combat,witness violence,perpetrate violence']='trauma related to combat'
d1$Traum_event2[d1$Traumatic_events == 'war,perpetrate violence']='trauma related to combat'
d1$Traum_event2[d1$Traumatic_events == 'natural disaster,traum to a loved one']='natural disaster'
d1$Traum_event2[d1$Traumatic_events == 'physical abuse,witness violence']='physical abuse'
d1$Traum_event2[d1$Traumatic_events == 'witness violence']='physical abuse'
d1$Traum_event2[d1$Traumatic_events == 'no evidence']='unknown'
d1$Traum_event2[d1$Traumatic_events == 'other']='unknown'
d1$Traum_event2[d1$Traumatic_events == 'other']='unknown'

# Fix some coding errors in Type_of_SB
d1$Type_ofSB[d1$id==25]  <- 'completion'
d1$Type_ofSB[d1$id==257] <- 'completion,unknown'
d1$Type_ofSB[d1$id==261] <- 'threat,ideation,attempt'
d1$Type_ofSB[d1$id==357] <- 'threat,attempt'
d1$Type_ofSB[d1$id==393] <- 'attempt,unknown'
d1$Type_ofSB[d1$id==571] <- 'unknown'

# Make a copy of Type_of_SB
d1$TypeSB2 = as.character(d1$Type_of_SB)
d1$TypeSB2[d1$Type_of_SB == 'attempt,completion,unknown']='unknown'
d1$TypeSB2[d1$Type_of_SB == 'completion,unknown']='unknown'
d1$TypeSB2[d1$Type_of_SB == 'threat,completion,unknown']='unknown'
d1$TypeSB2[d1$Type_of_SB == 'threat,attempt,unknown']='unknown'
d1$TypeSB2[d1$Type_of_SB == 'threat,ideation,attempt,unknown']='unknown'
d1$TypeSB2[d1$Type_of_SB == 'attempt,unknown']='unknown'

# These two records are "mixed" nonlethal and lethal
d1$TypeSB2[d1$id==267] <- 'threat,completion'
d1$TypeSB2[d1$id==1862] <- 'threat,attempt,completion'

# Make a copy of ailments
d1$ailments2 = as.character(d1$ailments)
d1$ailments2[d1$ailments == 'other,unknown']='unknown'
d1$ailments2[d1$ailments == 'other']='unknown'
d1$ailments2[d1$ailments == 'other chronic pain,unknown']='other chronic pain'
d1$ailments2[d1$ailments == 'gastrointestinal*']='gastrointestinal'
d1$ailments2[d1$ailments == 'gastrointestinal ']='gastrointestinal'

# Make a copy of social_status
d1$status2 = as.character(d1$social_status)
d1$status2[d1$social_status == 'average,unknown']='unknown'
d1$status2[d1$social_status == 'high,unknown']='probably high'
d1$status2[d1$social_status == 'high,average,unknown']='unknown'
d1$status2[d1$social_status == 'average,low,unknown']='unknown'
d1$status2[d1$social_status == 'low,unknown']='probably low'
d1$status2[d1$social_status == 'average,low']='probably low'
d1$status2[d1$social_status == 'average,low']='probably low'

# Make a copy of Target
d1$Target2 = as.character(d1$Target)
d1$Target2[d1$Target == 'adversary']= 'social partners'
d1$Target2[d1$Target == 'brother in law/husband']= 'affines'
d1$Target2[d1$Target == 'chief']= 'social superior'
d1$Target2[d1$Target == "paramour and paramour's kin"]= 'sexual competitor'
d1$Target2[d1$Target == 'child']= 'offspring'
d1$Target2[d1$Target == 'children']= 'offspring'
d1$Target2[d1$Target == 'exwife']= 'ex wife'
d1$Target2[d1$Target == 'husband ']= 'husband'
d1$Target2[d1$Target == 'immediate kin']= 'kin'
d1$Target2[d1$Target == 'immediate kin,spouse']= 'kin,spouse'
d1$Target2[d1$Target == 'kin and social group']= 'kin,social group'
d1$Target2[d1$Target == 'kin group']= 'kin'
d1$Target2[d1$Target == 'SA']= 'unknown'
d1$Target2[d1$Target == 'social partner']= 'social partners'
d1$Target2[d1$Target == 'social group']= 'social partners'
d1$Target2[d1$Target == 'paramour ']= 'sexual competitor'
d1$Target2[d1$Target == 'enemies']= 'social partners'

# Make a copy of Cause_type
d1$Cause_type2 = as.character(d1$Cause_type)
d1$Cause_type2[d1$Cause_type == 'death loved one,accus_commit wrongdo,spirit attack']= 'death loved one'
d1$Cause_type2[d1$Cause_type == 'death loved one,disease outbreak']= 'death loved one'
d1$Cause_type2[d1$Cause_type == 'death_loved_one,disease outbreak ']= 'death loved one'
d1$Cause_type2[d1$Cause_type == 'death loved one,other']= 'death loved one'
d1$Cause_type2[d1$Cause_type == 'death_loved_one,spirit attack']= 'death loved one'

d1$Age = as.character(d1$Age)
d1$age_min = rep(0, length(d1$Age))
d1$age_max = d1$age_min

d1$age_min[d1$Age == 'child'] = 5
d1$age_max[d1$Age == 'child'] = 14

d1$age_min[d1$Age == 'child,young adult'] = 5
d1$age_max[d1$Age == 'child,young adult'] = 19

d1$age_min[d1$Age == 'child,young adult,unknown'] = 5
d1$age_max[d1$Age == 'child,young adult,unknown'] = 19

d1$age_min[d1$Age == 'child,young adult,adult'] = 5
d1$age_max[d1$Age == 'child,young adult,adult'] = 60

d1$age_min[d1$Age == 'child,young adult,adult,unknown'] = 5
d1$age_max[d1$Age == 'child,young adult,adult,unknown'] = 90

d1$age_min[d1$Age == 'child,young adult,adult,elderly'] = 5
d1$age_max[d1$Age == 'child,young adult,adult,elderly'] = 90

d1$age_min[d1$Age == 'young adult'] = 15
d1$age_max[d1$Age == 'young adult'] = 19

d1$age_min[d1$Age == 'young adult,unknown'] = 15
d1$age_max[d1$Age == 'young adult,unknown'] = 30

d1$age_min[d1$Age == 'young adult,adult'] = 15
d1$age_max[d1$Age == 'young adult,adult'] = 90

d1$age_min[d1$Age == 'young adult, adult'] = 15
d1$age_max[d1$Age == 'young adult, adult'] = 90

d1$age_min[d1$Age == 'young adult,adult,unknown'] = 15
d1$age_max[d1$Age == 'young adult,adult,unknown'] = 90

d1$age_min[d1$Age == 'young adult,adult,elderly'] = 15
d1$age_max[d1$Age == 'young adult,adult,elderly'] = 90

d1$age_min[d1$Age == 'young adult,adult,elderly,unknown'] = 15
d1$age_max[d1$Age == 'young adult,adult,elderly,unknown'] = 90

d1$age_min[d1$Age == 'adult,unknown'] = 15
d1$age_max[d1$Age == 'adult,unknown'] = 90

d1$age_min[d1$Age == 'adult'] = 20
d1$age_max[d1$Age == 'adult'] = 60

d1$age_min[d1$Age == 'adult,elderly'] = 20
d1$age_max[d1$Age == 'adult,elderly'] = 90

d1$age_min[d1$Age == 'adult,elderly,unknown'] = 20
d1$age_max[d1$Age == 'adult,elderly,unknown'] = 90

d1$age_min[d1$Age == 'elderly'] = 61
d1$age_max[d1$Age == 'elderly'] = 90

d1$age_min[d1$Age == 'elderly,unknown'] = 20
d1$age_max[d1$Age == 'elderly,unknown'] = 90

# The following min and max ages were the modes
# for the mins and maxes where the age range <= 40

d1$age_min[d1$Age == 'unknown'] = 15
d1$age_max[d1$Age == 'unknown'] = 90

d1$age_min[is.na(d1$Age)] = NA
d1$age_max[is.na(d1$Age)] = NA

d1$age_range = d1$age_max - d1$age_min

### Recode Sex ###

d1$Sex2 = as.character(d1$Sex)
d1$Sex2[d1$Sex=='both' & d1$content_type=='Cultural model'] = 'unknown'
d1$Sex2[d1$Sex=='more often men'] = 'male'
d1$Sex2[d1$Sex=='more often women'] = 'female'
d1$Sex2 = factor(d1$Sex2)

# Convert case_score to numeric
d1$case_score[d1$case_score=='x'] = NA
d1$case_score = as.numeric(d1$case_score)

## Now replace theoretical variables in d1 with reconciled versions from rec

# remove id 468 from rec (Bakairi, which are not in probability sample)

rec = rec[rec$id!=468,]

# First save d1 row id 1909
d1_1909 = d1[d1$id==1909,]

# Only include ids in d1 that are in rec (the others were duplicates)

d1 = d1[d1$id %in% intersect(rec$id, d1$id),]

# The variables that were reconciled

vars = names(rec)[6:24]

# Now substitute the reconciled values for the original values

for (i in 1:nrow(d1)){
    
    d1[d1$id==rec$id[i],vars] = rec[i,vars]
    
}

# Some extracts in original dataset were split into new, additional
# extracts in the reconciled file

# rec ids a-k were split from 1909

new_extracts = rec[rec$id %in% c('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'),]

vars = c('id', vars)

for (i in 1:nrow(new_extracts)){
    
    newrow = d1_1909
    newrow[,vars] = new_extracts[i,vars]
    d1 = rbind(d1,newrow)
    
}

# Make a copy of public_private
d1$PublicSB = rep(0, nrow(d1))
d1$PublicSB[is.na(d1$public_private)]=0
d1$PublicSB[d1$public_private == 'public']=1
d1$PublicSB[d1$public_private == 'private']=-1
d1$PublicSB[d1$public_private == 'Private']=-1
d1$PublicSB[d1$public_private == 'Public']=1

# Decided to code Fitness threat "Evidence for" regardless of presence or absence of "Conflict"
# This resulted in many extracts being recoded as "Evidence for" Fitness threat
corrections = read.csv('data-raw/Corrected data.csv', colClasses='character')

for (i in 1:nrow(corrections)){
    
    d1$Fitness_threat[d1$id == corrections$id[i]] = 1
    
}

# A few corrections to Burdensomeness and LowRP
# id     Burdensomeness   Low_RP
# 190    Evidence for     Evidence for
# 214		              Evidence for
# 581    Evidence for     Evidence for

d1$Evidence_of_burdensomeness[d1$id==190] = 1
d1$Evidence_of_burdensomeness[d1$id==581] = 1

d1$Low_RP[d1$id==190] = 1
d1$Low_RP[d1$id==214] = 1
d1$Low_RP[d1$id==581] = 1

# There was a discrepency between Low RP and - High RP in these 5 rows, which we reviewed and rectified
d1$Low_RP[d1$id==27] = 0
d1$Low_RP[d1$id==106] = -1
d1$High_RP[d1$id==190] = -1
d1$Low_RP[d1$id==571] = -1
d1$High_RP[d1$id==581] = -1

# There were 4 discrepancies between "Outcome: others harmed" and minus "Outcome: others better off", which we
# reviewed and rectified. Only 1 value needed to be changed.

d1$Outcome_others_harmed[d1$id==4] = 1 # Eight children left motherless

# Aggregate types of SB

d1$TypeSB3 = d1$TypeSB2
d1$TypeSB3[d1$TypeSB3=='attempt,completion'] = 'completion'
d1$TypeSB3[d1$TypeSB3=='ideation,completion'] = 'completion'
d1$TypeSB3[d1$TypeSB3=='threat,attempt,completion'] = 'completion'
d1$TypeSB3[d1$TypeSB3=='threat,completion'] = 'completion'
d1$TypeSB3[d1$TypeSB3=='threat,ideation,completion'] = 'completion'
d1$TypeSB3[d1$TypeSB3=='plan,ideation'] = 'ideation'
d1$TypeSB3[d1$TypeSB3=='threat,attempt'] = 'attempt'
d1$TypeSB3[d1$TypeSB3=='threat,ideation'] = 'threat'
d1$TypeSB3[d1$TypeSB3=='threat,plan'] = 'threat'
d1$TypeSB3[d1$TypeSB3=='threat,plan,ideation'] = 'threat'
d1$TypeSB3 = factor(d1$TypeSB3, levels = c('completion', 'attempt', 'threat', 'ideation', 'unknown'))

d1$TypeSB4 = d1$TypeSB2
d1$TypeSB4[d1$TypeSB4=='attempt,completion'] = 'mixed'
d1$TypeSB4[d1$TypeSB4=='ideation,completion'] = 'mixed'
d1$TypeSB4[d1$TypeSB4=='threat,attempt,completion'] = 'mixed'
d1$TypeSB4[d1$TypeSB4=='threat,completion'] = 'mixed'
d1$TypeSB4[d1$TypeSB4=='threat,ideation,completion'] = 'mixed'
d1$TypeSB4[d1$TypeSB4=='plan,ideation'] = 'ideation'
d1$TypeSB4[d1$TypeSB4=='threat,attempt'] = 'attempt'
d1$TypeSB4[d1$TypeSB4=='threat,ideation'] = 'threat'
d1$TypeSB4[d1$TypeSB4=='threat,plan'] = 'threat'
d1$TypeSB4[d1$TypeSB4=='threat,plan,ideation'] = 'threat'
d1$TypeSB4 = factor(d1$TypeSB4, levels = c('completion', 'mixed', 'attempt', 'threat', 'ideation', 'unknown'))

### Rename theoretical variables for readability ###

# Groups of theoretical variables
# These will be used througout the ms

base_vars = c('culture', 'region')

bar_vars = c('Conflict', 'Fitness_threat', 'High_RP', 'Lethality_n_attempt', 'Motive_leverage', 'Outcome_change', 'Target_fitness', 'powerlessness', 'Motive_harm_others', 'Outcome_others_harmed', 'aggression', 'PublicSB')

fit_vars = c('Low_RP', 'Motive_better_off_kin', 'Motive_make_others_better_off', 'Evidence_of_burdensomeness', 'Outcome_better_off')

theory_vars = c(bar_vars, fit_vars)

bar_vars.new = c('Conflict', 'Fitness threat', 'High RP', 'Low lethality of attempt', 'Motive: Leverage', 'Outcome: victim better off', 'Social partner fitness', 'Powerlessness', 'Motive: harm others', 'Outcome: others harmed', 'Aggression', 'Public SB')

fit_vars.new = c('Low RP', 'Motive: kin better off', 'Motive: make others better off', 'Evidence of burdensomeness', 'Outcome: others better off')

theory_vars.new = c(bar_vars.new, fit_vars.new)

nms = names(d1)

for (i in 1:length(theory_vars)){
    
    if (theory_vars[i] %in% nms){
        
        c = grep(theory_vars[i], nms, fixed=T)
        names(d1)[c[1]] = theory_vars.new[i]
        
    }
}

coding <- d1

# Decided to rename "Aggression" to "AngrySB" to
# better reflect operationalization

coding = dplyr::rename(coding, AngrySB = Aggression)

bar_vars.new[11] = 'AngrySB'
theory_vars.new = c(bar_vars.new, fit_vars.new)
selectvars = c('id', fit_vars.new, bar_vars.new)

# Merge Syme Garfield Hagen consensus

sgh = read.csv('data-raw/coding.csv', stringsAsFactors = F)
sgh = sgh[, c(1, 3:19)]
names(sgh) = selectvars

# Some rows were deleted (because they were duplicates)
# and some rows were split in two. So, need to 
# delete or duplicate those rows in coding

# First duplicate these rows which actually had two cases/cultural models
# that needed to be coded separately

r1655b = coding[coding$id=='1655',]
r1655b$id = '1655b'
coding$Sex[coding$id=='1655'] = 'female'
coding$Sex2[coding$id=='1655'] = 'female'

r1906b = coding[coding$id=='1906',]
r1906b$id = '1906b'
r1906b$content_type = 'Case'
coding = rbind(coding, r1655b, r1906b)

# Delete these rows

coding = coding[coding$id != 1788,] # Duplicate of id 58
coding = coding[coding$id != 1894,] # Duplicate of id 297
coding = coding[coding$id != 1903,] # Not suicidal model or case
coding = coding[coding$id != 'g',]  # Not suicide model or case (lit review)

# Now replace old coding with new consensus coding

coding = left_join(coding[,!(names(coding) %in% theory_vars.new)], sgh, by='id')

# Convert -1 to new variables

d = coding[, theory_vars.new]

# Add new variables to capture -1's
d$`Outcome: victim worse off` = as.integer(d$`Outcome: victim better off`==-1)
d$`High lethality of attempt` = as.integer(d$`Low lethality of attempt`==-1)
d$`No social partner fitness` = as.integer(d$`Social partner fitness`==-1)
d$`Private SB` = as.integer(d$`Public SB`==-1)
d$`Evidence against burdensomeness` = as.integer(d$`Evidence of burdensomeness`==-1)
d$`Evidence against fitness threat` = as.integer(d$`Fitness threat`==-1)

d = lapply(d, function(x) as.integer(x==1)) # For non-negative matrix factorization
d = data.frame(d, check.names=F)

d = cbind(d, coding[, !(names(coding) %in% theory_vars.new)])

# Add age categories

n = nrow(d)

d$age_estimate=d$age_min+(d$age_max-d$age_min)/2

d$age.category = 'Child'
d$age.category[d$age_estimate>=15] = 'Adolescent'
d$age.category[d$age_estimate>=20] = 'Adult'
d$age.category[d$age_estimate>=60] = 'Elderly'
d$age.category = factor(d$age.category, levels=c('Child', 'Adolescent', 'Adult', 'Elderly'))

#Remove 634 from d
d = d[d$id != '634',]

# Select and reorder columns

coding <- d %>%
    select(
           id,
           culture,
           record = extract, 
           record_type = content_type,
           age_category = age.category, 
           sex = Sex2,
           sb_type = TypeSB4, 
           1:23
           )

coding2 <- d # Not in public data package

# # Apology data
# apology <- read_csv('data-raw/KristenApologyRevise.csv', col_types = 'ccccciiiiicii') # Because ID has chr values
# 
# ##Entry errors
# apology$transgression[apology$id == 446] = 0
# apology$transgression[apology$id == 766] = 0
# apology$id[apology$id=="I"] = "i"
# 
# ##Remove duplicates and blank data
# apology <- apology[apology$id != 634,]
# apology = apology[apology$id != 1788,]
# apology = apology[apology$id != 1894,]
# apology = apology[apology$id != 1903,]
# apology = apology[apology$id != 'g',]
# apology = apology[-c(466, 467,468),]
# 
# #Remove 1909 from apology
# apology <- apology[apology$id != 1909,]
# 
# transgression <- read_csv("data-raw/transgression_data.csv", col_types = 'ccccccci')
# transgression <- transgression[transgression$id !=1909,]
# 
# #Remove from apology and transgression, not in original coding
# apology <- apology[apology$id != 382,]
# apology = apology[apology$id != 411,]
# apology = apology[apology$id != 463,]
# apology = apology[apology$id != 468,]
# apology = apology[apology$id != 'm',]
# apology = apology[apology$id != 'l',]
# transgression <- transgression[transgression$id != 382,]
# transgression = transgression[transgression$id != 411,]
# transgression = transgression[transgression$id != 463,]
# transgression = transgression[transgression$id != 468,]
# transgression = transgression[transgression$id != 'm',]
coltypes <- c(id = 'text', 
              coder = 'text', 
              content_type = 'text', 
              culture = 'text', 
              extract = 'text',
              forgiven = 'numeric', 
              guilt = 'numeric', 
              motive_apologize = 'numeric', 
              punishment = 'numeric', 
              punishment_threat = 'numeric', 
              punishment_type = 'text', 
              shame = 'numeric', 
              transgression = 'numeric', 
              transgression_type = 'text', 
              unjustly_accused_punished = 'numeric')

apology <- read_csv("data-raw/Caitlin Kristen Reconciliation.csv")
causetypes_raw <- read_csv("data-raw/CauseTypesFinal.csv") ### Final

#check coding is identical
syme <- apology[apology$coder == 'syme', -c(2, 5)]
calsbeek <- apology[apology$coder == 'calsbeek', -c(2, 5)]
dif <- anti_join(syme, calsbeek)
which(syme[[13]]!=calsbeek[[13]])

apology_unreconciled<-read_csv('data-raw/CandK.csv')
apology_unreconciled <- apology_unreconciled[apology_unreconciled$id!='382', ]
apology_unreconciled <- apology_unreconciled[apology_unreconciled$id!='411', ]
apology_unreconciled <- apology_unreconciled[apology_unreconciled$id!='463', ]
apology_unreconciled <- apology_unreconciled[apology_unreconciled$id!='468', ]
apology_unreconciled <- rbind(apology_unreconciled, apology[apology$coder=='calsbeek' & apology$id=='634',])
syme <- apology_unreconciled[apology_unreconciled$coder=='syme',]
calsbeek <- apology_unreconciled[apology_unreconciled$coder=='calsbeek',]
apology <- apology[apology$coder == 'syme',-2]

save(coding, coding2, apology, apology_unreconciled, file = "data/coding.RData", compress = "xz")

apology_raw <- apology
# Now convert apology_raw, which has -1 values, to apology, which will only have 0's and 1's

apology$culpable <- apology$unjustly_accused_punished == -1
apology$culpable <- as.numeric(apology$culpable)
apology$unjustly_accused_punished[apology$unjustly_accused_punished == -1] <- 0 
apology$punishment_type[apology$punishment_type == 'unknown'] <- 'unknown punishment'
apology$punishment_type[apology$punishment_type == 'death'] <- 'death penalty'

#Remove 466, 467, and 634 from apology
apology = apology[-c(466, 467,468),]

lapply(apology, function(x){sum(x==-1)})

apology$forgiven[apology$forgiven == -1] <- 0
apology$guilt[apology$guilt == -1] <- 0
apology$motive_apologize[apology$motive_apologize == -1] <- 0
apology$punishment[apology$punishment == -1] <- 0

caitlin_cause_types <-read_csv('data-raw/CaitlinCauseTypes.csv')
kristen_cause_types <- d[c('id', 'Cause_type2')]
kristen_cause_types_clean <- read_csv(('data-raw/kristen_cause_types.csv'))


tmp <- left_join(caitlin_cause_types[c('id', 'Cause_type')], kristen_cause_types_clean, by='id')

library(stringr)

cause_types <- function(v){
    l1 <- list()
    for (i in 1:length(v)){
        c1 <- str_split(v[i], ',')[[1]]
        l1[[i]] <- c1
    }
    return(l1)
}
ctcomparison <- function(x){
    total_causes <- c()
    matching_causes <- c()
    for (i in 1:length(x$l1)){
        total_causes <- c(total_causes, length(union(x$l1[[i]], x$l2[[i]])))
        matching_causes <- c(matching_causes, length(intersect(x$l1[[i]], x$l2[[i]])))
    }
    return(data.frame(total_causes=total_causes, matching_causes=matching_causes))
}

rcd <- function(mylist,original,newc){
    for (i in 1:length(mylist)){
        a <- mylist[[i]]
        x <- match(original,a)
        if (!is.na(x)) a[x] <- newc
        mylist[[i]] <- a
    }
    return(mylist)
}

rcd2 <- function(mylist, sbstns){
    for (i in 1:length(sbstns)){
        s <- sbstns[i]
        mylist <- rcd(mylist, names(s), s)
    }
    return(mylist)
}

l1 <- cause_types(tmp$Cause_type)
names(l1) <- tmp$id

l2 <- cause_types(tmp$Cause_type2)
names(l2) <- tmp$id

l_final <- cause_types(causetypes$Cause_type2)
names(l_final) <- tmp$id

substitutions <- c(
    'fear of supernatural' = 'spirit_attack',
    'family tension' = 'interpersonal_confli',
    'emotional distress' = 'psychological distre',
    'mental illness' = 'psychological distre',
    'loneliness' = 'alienation',
    'fear of imprisonment' = 'enslavement_capture',
    'fear of enslavement' = 'enslavement_capture',
    'fear of rape' = 'rape',
    'fear of illness disf' = 'illness',
    'gambling loss' = 'resource_loss',
    'inability to marry' = 'thwarted marriage',
    'senility' = 'illness',
    'infirmity' = 'illness',
    'thwarted_status' = 'loss_social_position',
    'commit adultry' = 'commit adultery',
    'failure or sense of' = 'failure/sense of failure',
    'inability to have ch' = 'infertility',
    'psychological distre' = 'psychological distress',
    'failed romantic rela' = 'failed romantic relationship',
    'disappointment in ma' = 'disappointment in marriage',
    'anomie/social tensio' = 'anomie/social tension',
    'bring in cowife' = 'cowife',
    'failed romantic rela' = 'failed romantic relationship',
    
)

l1 <- rcd2(l1, substitutions)
l2 <- rcd2(l2, substitutions)
l_final <- rcd2(l_final, substitutions)

# x$l1 <- rcd(x$l1, 'fear of supernatural', 'spirit_attack')
# x$l2 <- rcd(x$l2, 'fear of supernatural', 'spirit_attack')
# x$l1 <- rcd(x$l1, 'family tension', 'interpersonal_confli')
# x$l2 <- rcd(x$l2, 'family tension', 'interpersonal_confli')
# x$l1 <- rcd(x$l1, 'emotional distress', 'psychological distre')
# x$l2 <- rcd(x$l2, 'emotional distress', 'psychological distre')
# x$l1 <- rcd(x$l1, 'mental illness', 'psychological distre')
# x$l2 <- rcd(x$l2, 'mental illness', 'psychological distre')
# x$l1 <- rcd(x$l1, 'loneliness', 'alienation')
# x$l2 <- rcd(x$l2, 'loneliness', 'alienation')
# x$l1 <- rcd(x$l1, 'fear of imprisonment', 'enslavement_capture')
# x$l2 <- rcd(x$l2, 'fear of imprisonment', 'enslavement_capture')
# x$l1 <- rcd(x$l1, 'fear of rape', 'rape')
# x$l2 <- rcd(x$l2, 'fear of rape', 'rape')
# x$l1 <- rcd(x$l1, 'fear of illness disf', 'illness')
# x$l2 <- rcd(x$l2, 'fear of illness disf', 'illness')
# x$l1 <- rcd(x$l1, 'gambling loss', 'resource_loss')
# x$l2 <- rcd(x$l2, 'gambling loss', 'resource_loss')
# x$l1 <- rcd(x$l1, 'inability to marry', 'thwarted marriage')
# x$l2 <- rcd(x$l2, 'inability to marry', 'thwarted marriage')
# x$l1 <- rcd(x$l1, 'senility', 'illness')
# x$l2 <- rcd(x$l2, 'senility', 'illness')
# x$l1 <- rcd(x$l1, 'infirmity', 'illness')
# x$l2 <- rcd(x$l2, 'infirmity', 'illness')
# x$l1 <- rcd(x$l1, 'thwarted_status', 'loss_social_position')
# x$l2 <- rcd(x$l2, 'thwarted_status', 'loss_social_position')
# x$l1 <- rcd(x$l1, 'commit adultry', 'commit adultery')
# x$l2 <- rcd(x$l2, 'commit adultry', 'commit adultery')
# x$l1 <- rcd(x$l1, 'failure or sense of ', 'failure or sense of')
# x$l2 <- rcd(x$l2, 'failure or sense of ', 'failure or sense of')

# Remove cause types that are redundant or not informative

bad_causetypes <- c('failed expectations', 
                    'disconnected from fa', 
                    'separation from love', 
                    'significant loss of', 
                    'significant loss of ', # Note the extra space
                    'significant loss soc',
                    'accus_commit_wrongdo',
                    'thwarted purpose',
                    'rejection', 
                    'ridicule', 
                    'group_conflict', 
                    'interpersonal_confli', 
                    'family shame', 
                    'bad luck', 
                    'commit adultry', 
                    'imprisonment',
                    'public humiliation',
                    "")

l1 <- lapply(l1, function(x) setdiff(x, bad_causetypes))
l2 <- lapply(l2, function(x) setdiff(x, bad_causetypes))
l_final <- lapply(l_final, function(x) setdiff(x, bad_causetypes))

# incorporate "transgression" "shame" "punishment_type" "transgresion_type" 
# from apology, and conflict from ZK

for (i in 1:length(l_final)) {
    nm <- names(l_final[i])
    row1 <- coding[coding$id == nm,]
    row2 <- apology[apology$id == nm,]
    
    if (row1$Conflict) {
        l_final[[i]] <- c(l_final[[i]], 'conflict')
    }
    
    if (row2$transgression_type != 'none'){
        l_final[[i]] <- c(l_final[[i]], row2$transgression_type)
    }    
    
    if (row2$punishment_type != 'na'){
        l_final[[i]] <- c(l_final[[i]], row2$punishment_type)
    }
    
}

# Cause groups--groups in terms of impact on fitness


# left: original cause type. right: new, more general cause group
cause_groups <- c(

    # generalized conflict
    'conflict' = 'conflict', 
    
    # issues of mating
    'incest' = 'mating',  # added clan incest distinct from incest
    'clan incest' = 'mating',
    ' clan incest' = 'mating',
    'unfaithful spouse' = 'mating',
    'rape' = 'mating',
    'failed romantic relationship' = 'mating',
    'disappointment in marriage' = 'mating',
    'divorce' = 'mating',
    'divorce or attempted' = 'mating',
    'thwarted marriage' = 'mating',
    'forced marriage' = 'mating',
    'cowife' = 'mating',
    'inability to marry' = 'mating',
    'adultery' = 'mating',
    'commit adultery' = 'mating', 
    'sexual_taboo' = 'mating',
    
    # issues of reproduction
    'pregnancy' = 'reproduction',
    'loss of children' = 'reproduction',
    'infertility' = 'reproduction',
    
    # resource loss
    'natural disaster' = 'resource loss', # Good categorization?
    'owed debt' = 'resource loss',
    'fear of loss' = 'resource loss',
    'resource_loss' = 'resource loss',
    'fine' = 'resource loss',
    
    # issues related to being a burden on others
    'fear of harming others' = 'burden on others',  
    'burdensomeness' = 'burden on others',
    'failure/sense of failure' = 'burden on others',
    'fail_others' = 'burden on others',
    'squandered_resources' = 'burden on others', # since extracts are more about impact of loss on others
   
    # demoted social status
    'thwarted status' = 'loss of social position',
    'loss of status' = 'loss of social position',
    'loss_social_position' = 'loss of social position',
    'loss_position' = 'loss of social position',      # could also be loss of resources
    
    # alienated from social group
    'ostracism' = 'social estrangement',
    'public_humiliation' = 'social estrangement',
    'ridicule' = 'social estrangement',
    'social_condemnation' = 'social estrangement',
    'alienation' = 'social estrangement',
    'betrayal' = 'social estrangement', 
    
    # social unrest resutling from conflict with external groups or colonial powers
    'military_defeat' = 'between group conflict',
    'political unrest' = 'between group conflict',
    'warn others' = 'between group conflict',
    'anomie/social tensio' = 'between group conflict',
    'nonconversion' = 'between group conflict',
    
    # issues of confinement--can't invest elsewhere
    'labor exploitation' = 'loss of autonomy/mobility',
    'enslavement_capture' = 'loss of autonomy/mobility',
    'imprisonment' = 'loss of autonomy/mobility',
    
    # inflicted physical bodily harm or death
    'physical abuse' = 'physical harm to victim',
    'bodily trauma' = 'physical harm to victim',
    'disfigurement' = 'physical harm to victim',
    'nonlethal_physical' = 'physical harm to victim',
    'death penalty' = 'physical harm to victim',
    
    # physical illness
    'illness' = 'illness',
    'disease outbreak' = 'illness',
    
    # mental health issues
    'psychological distress' = 'mental health',
    'boredom' = 'mental health',
    'drunkenness' = 'mental health',
    
    # a pervasive cultural model
    'spirit_attack' = 'spirit attack',
    
    # conflict between children/adolescents and parents
    'neglect' = 'child/adolescent parental conflict',
    'childhood_disobedience' = 'child/adolescent parental conflict',
    'strike_parents' = 'child/adolescent parental conflict',
    
    # loss of social partner through death or relationship defection
    'death_loved_one' = 'social partner loss',
    'trauma to loved one' = 'social partner loss',
    'loss_social_partner' = 'social partner loss',
    
    # the victim physically harmed others
    'manslaughter' = 'physically harm others',
    'murder' = 'physically harm others',
    'physical_attack' = 'physically harm others',
    'attempted_murder' = 'physically harm others',
    'threaten_murder' = 'physically harm others',
    
    # too complex to lump in with anything else
    'witchcraft' = 'witchcraft', 
    
    # social faux pas
    'public_flatulence' = 'social faux pas',
    'disrespect_ritual' = 'social faux pas',
    
    # unknown or a lack of information to categorize it
    'fear of punishment' = 'an unknown punishment',
    'unknown punishment' = 'an unknown punishment',
    'arrogance' = 'unknown', # based on a cultural model
    'unknown' = 'unknown',
    
)

a1 <- lapply(l1, function(x) unique(cause_groups[x]))
a2 <- lapply(l2, function(x) unique(cause_groups[x]))
a3 <- lapply(l_final, function(x) unique(cause_groups[x]))

# Something else

y <- ctcomparison(list(l1=l1, l2=l2))
c1 <- 0
for (i in 1:length(l1)){
    if ('spirit_attack' %in% l1[[i]]){
        if ('spirit_attack' %in% l2[[i]]){
            c1 <- c1+1
        }
    }
}

library(irr)
ctfind <- function(ct, l1, l2){
    v1 <- sapply(l1, function(a) ct %in% a)
    v2 <- sapply(l2, function(a) ct %in% a)
    print(kappa2(cbind(v1, v2)))
    #return(list(v1=as.numeric(v1), v2=as.numeric(v2)))
    #return(c(ct=cor(as.numeric(v1), as.numeric(v2), use='complete.obs')))
    #return(c(ct=kappa2(cbind(as.numeric(v1), as.numeric(v2)))$value))
    print(ct)
    print(table(v1,v2))
}

# Lower level cause types
u <- unlist(l1)
u <- c(u,unlist(l2))
u <- unique(u)
z <- sapply(u,ctfind, l1=l1, l2=l2)

# Higher level cause groups
cg <- unique(cause_groups)
z2 <- sapply(cg, ctfind, l1=a1, l2=a2)

# rename l_final, a3

causetypes <- l_final
causegroups <- a3

#a,b,c,d,e,f,h,i,j,k make no sense (replication of c) in kristen cause types, need to recode
save(causetypes_raw, causetypes, causegroups, coding, coding2, apology, apology_raw, apology_unreconciled, file = "data/coding.RData", compress = "xz")

