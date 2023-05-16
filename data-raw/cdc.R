
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

# Incomplete
mechanism_dict <- c(
    "BB / Pellet Gun" = "BB / Pellet Gun",
    "Bite: Other, including sting" = "Bite: Other, including sting",
    "Cut/Pierce" = "Cut/Pierce",
    'Drowning (includes water transport)' = 'Drowning',
    'Drowning / Submersion' = 'Drowning',
    'Drug Poisoning' = 'Poisoning',
    "Fall" = "Fall",
    'Fire / Burn' = 'Fire/Burn',
    'Fire/Flame' = 'Fire/Burn',
    "Firearm" = "Firearm",
    "Foreign Body" = "Foreign Body",
    'Hot object/Substance' = 'Fire/Burn',
    'Inhalation / Suffocation' = 'Suffocation',
    "Machinery" = "Machinery",
    "Motor Vehicle Occupant" = "Transportation",
    "Motorcyclist" = "Transportation",
    "Natural / Environmental" = "Natural / Environmental",
    'Non-Drug Poisoning' = 'Poisoning',
    "Other Specified" = "Other",
    "Other specified / NEC" = "Other",
    "Other specified and classifiable" = "Other",
    "Other Transportation" = "Transportation",
    "Overexertion" = "Overexertion",
    "Pedal cyclist (bicycle, etc.)" = "Transportation",
    "Pedestrian" = "Pedestrian",
    "Poisoning" = "Poisoning",
    "Struck by / against" = "Struck",
    'Struck by /Against' = 'Struck',
    "Suffocation" = "Suffocation",
    "Transport, other land" = "Transportation",
    'Unknown / Unspecified' = 'Unspecified',
    "Unspecified" = "Unspecified"
)

cdc3_attempts <-
    read_csv('data-raw/cdc-suicide-attempts-2001-2020.csv', n_max = 5341, na = '--') %>% 
    dplyr::select(Year:`Crude Rate`) %>% 
    mutate(
        Age = as.numeric(str_sub(`Age Group`, start = 1, end=2)) + 2.5,
        Type = 'Injuries',
        # Mechanism2 = Mechanism,
        # Mechanism2 = str_replace(Mechanism2, 'Drowning \\/ Submersion', 'Drowning'),
        # Mechanism2 = str_replace(Mechanism2, 'Fire \\/ Burn', 'Fire/Burn'),
        # Mechanism2 = str_replace(Mechanism2, 'Inhalation \\/ Suffocation', 'Suffocation'),
        # Mechanism2 = str_replace(Mechanism2, 'Unknown \\/ Unspecified', 'Unspecified'),
        # Mechanism2 = str_replace(Mechanism2, 'Struck by \\/Against', 'Struck')
    ) %>% 
    rename(Number = `Estimated Number`) %>% 
    relocate(Age, .after = `Age Group`) %>% 
    relocate(Type)

cdc3_deaths <-
    read_csv('data-raw/cdc-suicide-deaths-2001-2020.csv', n_max = 7177, na = '--') %>% 
    dplyr::select(Year:`Crude Rate`) %>% 
    mutate(
        Age = as.numeric(str_sub(`Age Group`, start = 1, end=2)) + 2.5,
        Deaths = as.numeric(str_remove(Deaths, "\\*\\*")),
        `Crude Rate` = as.numeric(str_remove(`Crude Rate`, "\\*\\*")),
        Type = 'Deaths',
        # Mechanism2 = Mechanism,
        # Mechanism2 = str_replace(Mechanism2, 'Drug Poisoning', 'Poisoning'),
        # Mechanism2 = str_replace(Mechanism2, 'Non-Drug Poisoning', 'Poisoning'),
        # Mechanism2 = str_replace(Mechanism2, 'Drowning \\(includes water transport\\)', 'Drowning'),
        # Mechanism2 = str_replace(Mechanism2, 'Fire\\/Flame', 'Fire/Burn'),
        # Mechanism2 = str_replace(Mechanism2, 'Hot object\\/Substance', 'Fire/Burn'),
        # Mechanism2 = str_replace(Mechanism2, 'Struck by \\/ against', 'Struck')
    ) %>% 
    rename(
        Number = Deaths
    ) %>%
    relocate(Age, .after = `Age Group`) %>% 
    relocate(Type)

cdc3 <- 
    bind_rows(cdc3_attempts, cdc3_deaths) %>% 
    mutate(
        Mechanism2 = mechanism_dict[Mechanism],
        Mechanism2 = ifelse(is.na(Mechanism2), 'Unspecified', Mechanism2)
    )

# Homicides ---------------------------------------------------------------

homicides1999_2020 <- 
    read_tsv('data-raw/Underlying Cause of Death, 1999-2020.tsv', n_max = 36) %>%
    rename(
        age_group = `Five-Year Age Groups Code`
    ) %>% 
    mutate(
        Age = case_when(
            age_group == '1' ~ '0.5',
            age_group == '1-4' ~ '2.5',
            age_group == '5-9' ~ '7',
            TRUE ~ str_sub(age_group, 1, 2)
        ),
        Age = as.numeric(Age) + 2
    ) %>% 
    relocate(Age) %>% 
    dplyr::select(-Notes, -`Five-Year Age Groups`)


# Sexual assaults ---------------------------------------------------------

sexual_assaults2001_2020 <- 
    read_csv('data-raw/sexual assaults2001-2020.csv', na = '.') %>% 
    dplyr::select(Sex, `Age Group`, Year, Injuries, Population, `Crude Rate`, `Lower 95%$Confidence$Limit`, `Upper 95%$Confidence$Limit`) %>%
    dplyr::filter(Sex != 'B', Sex != 'U') %>% 
    rename(
        lower95 = `Lower 95%$Confidence$Limit`,
        upper95 = `Upper 95%$Confidence$Limit`
    ) %>% 
    mutate(
        Age = as.numeric(str_sub(`Age Group`, 1, 2)) + 2
    ) %>% 
    relocate(Age, .after = Sex)


# Non sexual assaults -----------------------------------------------------

nonsexual_assaults2001_2020 <- 
    read_csv('data-raw/nonsexual assaults2001-2020.csv', na = '.') %>% 
    dplyr::select(Sex, `Age Group`, Year, Injuries, Population, `Crude Rate`, `Lower 95%$Confidence$Limit`, `Upper 95%$Confidence$Limit`) %>%
    dplyr::filter(Sex != 'B', Sex != 'U') %>% 
    rename(
        lower95 = `Lower 95%$Confidence$Limit`,
        upper95 = `Upper 95%$Confidence$Limit`
    ) %>% 
    mutate(
        Age = as.numeric(str_sub(`Age Group`, 1, 2)) + 2
    ) %>% 
    relocate(Age, .after = Sex)


# All assaults ------------------------------------------------------------

assaults2001_2020 <- 
    read_csv('data-raw/all assaults2001-2020.csv', na = '.') %>% 
    dplyr::select(Sex, `Age Group`, Year, Injuries, Population, `Crude Rate`, `Lower 95%$Confidence$Limit`, `Upper 95%$Confidence$Limit`) %>%
    dplyr::filter(Sex != 'B', Sex != 'U') %>% 
    rename(
        lower95 = `Lower 95%$Confidence$Limit`,
        upper95 = `Upper 95%$Confidence$Limit`
    ) %>% 
    mutate(
        Age = as.numeric(str_sub(`Age Group`, 1, 2)) + 2
    ) %>% 
    relocate(Age, .after = Sex)


# Save --------------------------------------------------------------------

usethis::use_data(cdc, cdc2, cdc3, cdc1999_2019, homicides1999_2020, sexual_assaults2001_2020, nonsexual_assaults2001_2020, assaults2001_2020, overwrite = T)
