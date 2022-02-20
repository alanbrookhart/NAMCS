# statin_data.R
# Purpose: read-in and modify NHANES statin data obtained by Alan Ellis,
# write out easy to use R files with simulated outcome

library(tidyverse)
library(foreign)
library(causalRisk)
library(foreach)
library(purrr)

#
# read-in statin data
#
tmp <- read.dta("./data-raw/statin010.dta")
sta <- as_tibble(tmp)

# recode variables

sta$region=factor(sta$region,
                  labels=c("Northeast","Midwest","South","West"))
sta$sex=ifelse(sta$male==1,"Male","Female")
sta$race=factor(sta$racer,
                labels=c("White","Black","Other"))

sta$newusercat=factor(sta$newusercat,
                      labels=c("No treatment","Low Potency","High Potency"))

sta$statin_use = as.factor(ifelse(sta$newusercat == "No treatment", "No Treatment", "Statin"))
set.seed(101)
sta = sta[sta$statin_use=="Statin" | runif(nrow(sta))>0.95, ]


names(sta)[names(sta) == "conth2antagonist"] = "h2_antagonist_use"
names(sta)[names(sta) == "newusercat"] = "statinpotency_use"
names(sta)[names(sta) == "contsteroids"] = "corticosteroid_use"
names(sta)[names(sta) == "contaht"] = "anti_hypertensive_use"
names(sta)[names(sta) == "contanticoag"] = "anti_coagulant_use"
names(sta)[names(sta) == "contppi"] = "ppi_use"
names(sta)[names(sta) == "contaspirin"] = "aspirin_use"
names(sta)[names(sta) == "deprn"] = "depression"
names(sta)[names(sta) == "hyplipid"] = "hyperlipidemia"
names(sta)[names(sta) == "crf"] = "chronic_kidney_disease"
names(sta)[names(sta) == "copd"] = "chronic_pulmonary_disease"
names(sta)[names(sta) == "ostprsis"] = "osteoporosis"
names(sta)[names(sta) == "ihd"] = "coronory_artery_disease"
names(sta)[names(sta) == "tobacco_imp"] = "tobacco_use"
names(sta)[names(sta) == "htn"] = "hypertension"
names(sta)[names(sta) == "contnsaid"] = "nsaid_use"
names(sta)[names(sta) == "obesity_"] = "obesity"
names(sta)[names(sta) == "arthrtis"] = "arthritis"
names(sta)[names(sta) == "cebvd"] = "cerebrovascular_disease"
names(sta)[names(sta) == "chf"] = "heart_failure"

# drop unneeded colums

sta = sta %>% select(-starts_with("reas1")) %>%
  select(-starts_with("reas2")) %>%
  select(-starts_with("reason")) %>%
  select(-starts_with("urban")) %>%
  select(-starts_with("pct"))  %>%
  select(-contains("imp")) %>%
  select(-contains("payer")) %>%
  select(-contains("bp")) %>%
  select(-contains("major")) %>%
  select(-contains("code")) %>%
  select(-contains("code")) %>%
  select(-contains("mddo")) %>%
  select(-contains("new")) %>%
  select(-contains("male")) %>%
  select(-contains("nsnsaid")) %>%
  select(-contains("nstin")) %>%
  select(-contains("nonuser")) %>%
  select(-contains("spec")) %>%
  select(-contains("west")) %>%
  select(-contains("east")) %>%
  select(-contains("south")) %>%
  select(-contains("racer")) %>%
  select(-contains("raceb")) %>%
  select(-contains("nonmetro")) %>%
  select(-contains("contsta")) %>%
  select(-contains("zip")) %>%
  select(-c("pcdoc", "msa", "do", "statinlo", "statinhi", "cam"))

sta = sta %>%
  dplyr::mutate_at(.vars = c(
                  "h2_antagonist_use",
                  "mi",
                  "cerebrovascular_disease",
                  "heart_failure",
                  "diabetes",
                  "arthritis",
                  "cancer",
                  "asthma",
                  "corticosteroid_use",
                  "anti_hypertensive_use",
                  "anti_coagulant_use",
                  "ppi_use",
                  "aspirin_use",
                  "depression",
                  "hyperlipidemia",
                  "chronic_kidney_disease",
                  "chronic_pulmonary_disease",
                  "osteoporosis",
                  "coronory_artery_disease",
                  "tobacco_use",
                  "hypertension",
                  "nsaid_use",
                  "obesity"),
          .funs = funs(factor(., labels = c("No", "Yes"))))

# simulate outcome
# baseline hazard: Weibull
# N = sample size
# lambda = scale parameter in h0()
# rho = shape parameter in h0()
# beta = fixed effect parameter
# rateC = rate parameter of the exponential distribution of C

simulWeib <- function(df.in)
{
  shape.t1 = 1 # cvd event
  shape.t2 = 1 # all-cause mortality
  shape.c = 1 # censoring hazard, shape=1: exponential distribution

  df1 = as.data.frame(df.in) # Note: when in data.table format all the column selection fails
  N = nrow(df1)

  age.rev = (df1$age-53)/10

  lp.1 = with(df1, log(0.5)*I(statin_use=="Statin")  +
                log(1.5)*age.rev +
                log(1.5)*I(coronory_artery_disease=="Yes") +
                log(1.5)*I(tobacco_use=="Yes") + log(1.5)*I(diabetes=="Yes"))

  lp.2 = with(df1, log(0.9)*I(statin_use=="Statin") + log(1.2)*age.rev +
                log(1.5)*I(cancer=="Yes") + log(1.4)*I(obesity=="Yes"))

  lp.3 = with(df1, 0.5+
              log(2.5)*I(statin_use=="Statin")  + log(2)*age.rev +
                log(2.5)*I(coronory_artery_disease=="Yes") +
                log(2.5)*I(tobacco_use=="Yes") + log(2.5)*I(cancer=="Yes"))


  # Weibull latent event times
  v <- runif(N)
  cv_time <- (- log(v) / (0.03 * exp(lp.1)))^(1 / shape.t1) + 0.1
  death_time <- (- log(v) / (0.03 * exp(lp.2)))^(1 / shape.t2) + 0.1 # risk is smaller for mortality compared to hospitalization. To make coefficients for cat.2 match that specified for lp.1 need to set the mortality risk much smaller than hospitalization (average of simulated parameters run in the following for loop)
  death_time = round(ifelse(death_time >10, NA, death_time), 2)
  cv_time = round(ifelse(cv_time >10 | cv_time > death_time, NA, cv_time),2)
  cv_death_time = pmin(cv_time, death_time, na.rm = TRUE)
  cv_indicator = ifelse(cv_time == cv_death_time, 1, 0)
  cv_indicator = ifelse(is.na(cv_indicator), 0, cv_indicator)
  cv_indicator = ifelse(is.na(cv_death_time), NA, cv_indicator)

  # censoring times
  v <- runif(N)
  nonadherence <- (- log(v) / (0.01 * exp(lp.3)))^(1 / shape.c) + 0.1
  nonadherence = ifelse(!is.na(death_time),
                           ifelse(nonadherence > death_time, NA, nonadherence),
                           nonadherence)
  nonadherence = round(ifelse(nonadherence > 10, NA, nonadherence), 2)
  end_followup = 10
  cbind(df1, data.frame(cv_time, death_time, nonadherence, cv_indicator,
                        end_followup, cv_death_time))
}
sta = simulWeib(sta)

# Save R data set in the NAMCS package
devtools::use_data(sta, overwrite=TRUE)
