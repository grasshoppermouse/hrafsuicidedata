
#' coding
#'
#' Coding of variables on all suicide reports from the probability sample.
#'
#' Coding of 23 variables related to the inclusive fitness and bargaining models of suicidal behavior.
#' 
#' Kristen Syme, Zach Garfield and Ed Hagen
#'
#' @format A data frame with 473 rows and 30 variables:
#' \describe{
#'   \item{\code{id}}{character. DESCRIPTION.}
#'   \item{\code{culture}}{character. DESCRIPTION.}
#'   \item{\code{record}}{character. DESCRIPTION.}
#'   \item{\code{record_type}}{character. DESCRIPTION.}
#'   \item{\code{age_category}}{integer. DESCRIPTION.}
#'   \item{\code{sex}}{integer. DESCRIPTION.}
#'   \item{\code{sb_type}}{integer. DESCRIPTION.}
#'   \item{\code{Conflict}}{integer. DESCRIPTION.}
#'   \item{\code{Fitness threat}}{integer. DESCRIPTION.}
#'   \item{\code{High RP}}{integer. DESCRIPTION.}
#'   \item{\code{Low lethality of attempt}}{integer. DESCRIPTION.}
#'   \item{\code{Motive: Leverage}}{integer. DESCRIPTION.}
#'   \item{\code{Outcome: victim better off}}{integer. DESCRIPTION.}
#'   \item{\code{Social partner fitness}}{integer. DESCRIPTION.}
#'   \item{\code{Powerlessness}}{integer. DESCRIPTION.}
#'   \item{\code{Motive: harm others}}{integer. DESCRIPTION.}
#'   \item{\code{Outcome: others harmed}}{integer. DESCRIPTION.}
#'   \item{\code{AngrySB}}{integer. DESCRIPTION.}
#'   \item{\code{Public SB}}{integer. DESCRIPTION.}
#'   \item{\code{Low RP}}{integer. DESCRIPTION.}
#'   \item{\code{Motive: kin better off}}{integer. DESCRIPTION.}
#'   \item{\code{Motive: make others better off}}{integer. DESCRIPTION.}
#'   \item{\code{Evidence of burdensomeness}}{integer. DESCRIPTION.}
#'   \item{\code{Outcome: others better off}}{integer. DESCRIPTION.}
#'   \item{\code{Outcome: victim worse off}}{integer. DESCRIPTION.}
#'   \item{\code{High lethality of attempt}}{integer. DESCRIPTION.}
#'   \item{\code{No social partner fitness}}{integer. DESCRIPTION.}
#'   \item{\code{Private SB}}{integer. DESCRIPTION.}
#'   \item{\code{Evidence against burdensomeness}}{integer. DESCRIPTION.}
#'   \item{\code{Evidence against fitness threat}}{integer. DESCRIPTION.}
#' }
"coding"


#' cdc
#'
#' CDC data on suicide attempt and mortality rates
#'
#' United States 2001-2011
#'
#' @format A data frame with 36 rows and 6 variables:
#' \describe{
#'   \item{\code{sex}}{integer. DESCRIPTION.}
#'   \item{\code{age}}{integer. DESCRIPTION.}
#'   \item{\code{age2}}{double. DESCRIPTION.}
#'   \item{\code{population}}{integer. DESCRIPTION.}
#'   \item{\code{Suicide rate}}{double. DESCRIPTION.}
#'   \item{\code{Attempt rate}}{double. DESCRIPTION.}
#' }
"cdc"


#' cultures
#'
#' Cultures from the HRAF Probability Sample with information on suicide
#' 
#' Contains information on cultures in the HRAF probability sample, including
#' information from matching SCCS cultures.
#'
#' @format A data frame with 57 rows and 10 variables:
#' \describe{
#'   \item{\code{Culture.code}}{character. DESCRIPTION.}
#'   \item{\code{Name}}{character. DESCRIPTION.}
#'   \item{\code{Region}}{character. DESCRIPTION.}
#'   \item{\code{Continental_region}}{character. DESCRIPTION.}
#'   \item{\code{subsistence}}{integer. DESCRIPTION.}
#'   \item{\code{complexity}}{double. DESCRIPTION.}
#'   \item{\code{postmarital.residence}}{integer. DESCRIPTION.}
#'   \item{\code{descent}}{integer. DESCRIPTION.}
#'   \item{\code{longitude}}{double. DESCRIPTION.}
#'   \item{\code{latitude}}{double. DESCRIPTION.}
#' }
"cultures"


#' apology
#'
#' Coding of 11 variables of the apology model {0, 1}.
#' Reconciled version.
#' 
#' Kristen Syme and Caitlin Calsbeek
#'
#' @format A data frame with 471 rows and 15 variables:
#' \describe{
#'   \item{\code{id}}{character. DESCRIPTION.}
#'   \item{\code{content_type}}{character. DESCRIPTION.}
#'   \item{\code{culture}}{character. DESCRIPTION.}
#'   \item{\code{extract}}{character. DESCRIPTION.}
#'   \item{\code{forgiven}}{double. DESCRIPTION.}
#'   \item{\code{guilt}}{double. DESCRIPTION.}
#'   \item{\code{motive_apologize}}{double. DESCRIPTION.}
#'   \item{\code{punishment}}{double. DESCRIPTION.}
#'   \item{\code{punishment_threat}}{integer. DESCRIPTION.}
#'   \item{\code{punishment_type}}{character. DESCRIPTION.}
#'   \item{\code{shame}}{integer. DESCRIPTION.}
#'   \item{\code{transgression}}{integer. DESCRIPTION.}
#'   \item{\code{transgression_type}}{character. DESCRIPTION.}
#'   \item{\code{unjustly_accused_punished}}{double. DESCRIPTION.}
#'   \item{\code{culpable}}{double. DESCRIPTION.}
#' }
"apology"


#' apology_raw
#'
#' Coding of 10 variables of the apology model with {-1, 0, 1}.
#' Reconciled version.
#' 
#' Kristen Syme and Caitlin Calsbeek
#'
#' @format A data frame with 474 rows and 14 variables:
#' \describe{
#'   \item{\code{id}}{character. DESCRIPTION.}
#'   \item{\code{content_type}}{character. DESCRIPTION.}
#'   \item{\code{culture}}{character. DESCRIPTION.}
#'   \item{\code{extract}}{character. DESCRIPTION.}
#'   \item{\code{forgiven}}{integer. DESCRIPTION.}
#'   \item{\code{guilt}}{integer. DESCRIPTION.}
#'   \item{\code{motive_apologize}}{integer. DESCRIPTION.}
#'   \item{\code{punishment}}{integer. DESCRIPTION.}
#'   \item{\code{punishment_threat}}{integer. DESCRIPTION.}
#'   \item{\code{punishment_type}}{character. DESCRIPTION.}
#'   \item{\code{shame}}{integer. DESCRIPTION.}
#'   \item{\code{transgression}}{integer. DESCRIPTION.}
#'   \item{\code{transgression_type}}{character. DESCRIPTION.}
#'   \item{\code{unjustly_accused_punished}}{integer. DESCRIPTION.}
#' }
"apology_raw"

#' apology_unreconciled
#'
#' Coding of 10 variables of the apology model with {-1, 0, 1}.
#' Caitlin and Kristen coding (unreconciled).
#'
#' Kristen Syme and Caitlin Calsbeek
#' 
#' @format A data frame with 948 rows and 15 variables:
#' \describe{
#'   \item{\code{id}}{character. DESCRIPTION.}
#'   \item{\code{coder}}{character. DESCRIPTION.}
#'   \item{\code{content_type}}{character. DESCRIPTION.}
#'   \item{\code{culture}}{character. DESCRIPTION.}
#'   \item{\code{extract}}{character. DESCRIPTION.}
#'   \item{\code{forgiven}}{integer. DESCRIPTION.}
#'   \item{\code{guilt}}{integer. DESCRIPTION.}
#'   \item{\code{motive_apologize}}{integer. DESCRIPTION.}
#'   \item{\code{punishment}}{integer. DESCRIPTION.}
#'   \item{\code{punishment_threat}}{integer. DESCRIPTION.}
#'   \item{\code{punishment_type}}{character. DESCRIPTION.}
#'   \item{\code{shame}}{integer. DESCRIPTION.}
#'   \item{\code{transgression}}{integer. DESCRIPTION.}
#'   \item{\code{transgression_type}}{character. DESCRIPTION.}
#'   \item{\code{unjustly_accused_punished}}{integer. DESCRIPTION.}
#' }
"apology_unreconciled"

#' causetypes_raw
#'
#' DATASET DESCRIPTION
#'
#' @format A data frame with 471 rows and 4 variables:
#' \describe{
#'   \item{\code{id}}{character. Record id (extract id).}
#'   \item{\code{extract}}{character. Suicide record.}
#'   \item{\code{Cause_type2}}{character. DESCRIPTION.}
#'   \item{\code{List of changes}}{character. DESCRIPTION.}
#' }
"causetypes_raw"

#' causetypes
#' 
#' A list of cause types. Names are extract id's
#' 
"causetypes"

#' causegroups
#' 
#' A list of cause groups. Names are extract id's
#' 
"causegroups"