
library(tidyverse)

# Suicide attempt and mortality data from CDC 2001-2011

cdc = read.delim('data-raw/CDC-2001-2011.txt')
cdc$age2 = cdc$age2 + 2.5 # Put in middle of original age range, instead of beginning

cdc = rename(cdc, `Suicide rate` = suiciderate, `Attempt rate` = selfharmrate)

# Suicide attempt and mortality data from CDC 1999-2019

cleanup <- function(d){
    d %>% 
        dplyr::filter(Sex != 'B', Sex != 'U', `Age Group` != 'Ages 0 to 85+') %>% 
        mutate(
            Sex = case_when(
                Sex == 'F' ~ 'Females',
                Sex == 'M' ~ 'Males',
                TRUE ~ Sex
            ),
            `Age Group` = str_replace(`Age Group`, ' yrs', ''),
            Age = as.numeric(str_sub(`Age Group`, start = 1, end=2)) + 2.5
        ) %>% 
        relocate(Age, .after = Sex)
}

cdc_deaths <- 
    read_csv('data-raw/cdc.suicide1999-2019.by-year.csv') %>% 
    dplyr::select(Sex, `Age Group`, Year, Deaths, Population, `Crude Rate`) %>% 
    rename(Number = Deaths) %>% 
    mutate(Type = 'Deaths')

cdc_attempts <-
    read_csv('data-raw/cdc.attempts.2001-2019.by-year.csv', na = c('.')) %>% 
    dplyr::select(Sex, `Age Group`, Year, Injuries, Population, `Crude Rate`) %>% 
    rename(Number = Injuries) %>% 
    mutate(Type = 'Injuries')

cdc1999_2019 <- 
    bind_rows(cdc_deaths, cdc_attempts) %>% 
    cleanup()

cdc2_deaths <- 
    read_csv('data-raw/cdc.suicide.1999-2019.csv') %>% 
    dplyr::select(Sex, `Age Group`, Deaths, Population, `Crude Rate`) %>% 
    rename(Number = Deaths) %>% 
    mutate(Type = 'Deaths')

cdc2_attempts <-
    read_csv('data-raw/cdc.attempts.2001-2019.csv', na = c('.')) %>% 
    dplyr::select(Sex, `Age Group`, Injuries, Population, `Crude Rate`) %>% 
    rename(Number = Injuries) %>% 
    mutate(Type = 'Injuries')

cdc2 <- 
    bind_rows(cdc2_deaths, cdc2_attempts) %>% 
    cleanup()


# Save
usethis::use_data(cdc, cdc2, cdc1999_2019, overwrite = T)
