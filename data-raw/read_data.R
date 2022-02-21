
# read_data.R
# Purpose: read-in subsetted NAMCS data from selected years
# write out easy to use R files with simulated outcome

library(tidyverse)
library(foreign)
devtools::install_github("r-lib/usethis")

# read-in NSAID data
tmp <- read.dta("./data-raw/nsaid008.dta")
ns <- as_tibble(tmp)

# recode variables

ns$region=factor(ns$region,
                 labels=c("Northeast","Midwest","South","West"))
ns$year = as_factor(ns$year)

ns$sex=ifelse(ns$male==1,"Male","Female")
ns$race=factor(ns$racer,
               labels=c("White","Black","Other"))
ns$cox2 = ns$newcox2
names(ns)[names(ns) == "conth2antagonist"] = "h2_antagonist_use"
ns$h2_antagonist_use =factor(ns$h2_antagonist_use, labels=c("No","Yes"))
names(ns)[names(ns) == "contstatin"] = "statin_use"
ns$statin_use =factor(ns$statin_use, labels=c("No","Yes"))
names(ns)[names(ns) == "contsteroids"] = "corticosteroid_use"
ns$corticosteroid_use =factor(ns$corticosteroid_use, labels=c("No","Yes"))
names(ns)[names(ns) == "contaht"] = "anti_hypertensive_use"
ns$anti_hypertensive_use =factor(ns$anti_hypertensive_use, labels=c("No","Yes"))
names(ns)[names(ns) == "contanticoag"] = "anti_coagulant_use"
ns$anti_coagulant_use = factor(ns$anti_coagulant_use, labels=c("No","Yes"))
names(ns)[names(ns) == "chf"] = "heart_failure"
ns$heart_failure = factor(ns$heart_failure, labels=c("No","Yes"))
names(ns)[names(ns) == "contppi"] = "ppi_use"
ns$ppi_use =factor(ns$ppi_use, labels=c("No","Yes"))
names(ns)[names(ns) == "cebvd"] = "cerebrovascular_disease"
ns$cerebrovascular_disease = factor(ns$cerebrovascular_disease, labels=c("No","Yes"))
names(ns)[names(ns) == "htn"] = "hypertension"
ns$hypertension = factor(ns$hypertension, labels=c("No","Yes"))
names(ns)[names(ns) == "contaspirin"] = "aspirin_use"
ns$aspirin_use = factor(ns$aspirin_use, labels=c("No","Yes"))
names(ns)[names(ns) == "deprn"] = "depression"
ns$depression = factor(ns$depression, labels=c("No","Yes"))
names(ns)[names(ns) == "hyplipid"] = "hyperlipidemia"
ns$hyperlipidemia = factor(ns$hyperlipidemia, labels=c("No","Yes"))
names(ns)[names(ns) == "crf"] = "chronic_kidney_disease"
ns$chronic_kidney_disease = factor(ns$chronic_kidney_disease, labels=c("No","Yes"))
names(ns)[names(ns) == "copd"] = "chronic_pulmonary_disease"
ns$chronic_pulmonary_disease = factor(ns$chronic_pulmonary_disease, labels=c("No","Yes"))
names(ns)[names(ns) == "ostprsis"] = "osteoporosis"
ns$osteoporosis = factor(ns$osteoporosis, labels=c("No","Yes"))
names(ns)[names(ns) == "arthrtis"] = "arthritis"
ns$arthritis = factor(ns$arthritis, labels=c("No","Yes"))
names(ns)[names(ns) == "ihd"] = "coronory_artery_disease"
ns$coronory_artery_disease = factor(ns$coronory_artery_disease, labels=c("No","Yes"))
names(ns)[names(ns) == "cox2"] = "cox2_initiation"
ns$cox2_initiation = factor(ns$cox2_initiation, labels=c("No","Yes"))
ns$asthma = factor(ns$asthma, labels=c("No","Yes"))
ns$cancer = factor(ns$cancer, labels=c("No","Yes"))
ns$diabetes = factor(ns$diabetes, labels=c("No","Yes"))


# drop unneeded columns
ns = ns %>% select(-starts_with("reas1")) %>%
  select(-starts_with("reas2")) %>%
  select(-starts_with("reason")) %>%
  select(-starts_with("urban")) %>%
  select(-starts_with("pct"))  %>%
  select(-contains("imp")) %>%
  select(-contains("pud")) %>%
  select(-contains("cam")) %>%
  select(-contains("bp")) %>%
  select(-contains("major")) %>%
  select(-contains("code")) %>%
  select(-contains("code")) %>%
  select(-contains("mddo")) %>%
  select(-contains("new")) %>%
  select(-contains("nsnsaid")) %>%
  select(-contains("spec")) %>%
  select(-contains("west")) %>%
  select(-contains("east")) %>%
  select(-contains("payer")) %>%
  select(-contains("south")) %>%
  select(-contains("racer")) %>%
  select(-contains("raceb")) %>%
  select(-contains("nonmetro")) %>%
  select(-contains("male")) %>%
  select(-contains("contnsaid")) %>%
  select(-contains("msa")) %>%
  select(-contains("pcdoc")) %>%
  select(-contains("do")) %>%
  select(-contains("zip"))

# simulate outcome

pbleed = 1/(1+exp(-(-8 + .6*I(ns$anti_coagulant_use == "Yes") + .5*I(ns$corticosteroid_use == "Yes") +
                    .2 * I(ns$aspirin_use == "Yes") + .7*I(ns$arthritis == "Yes") + .07*ns$age + .3*I(ns$sex == "Male") +
                    .02*I(ns$race == "Black") - .3 * I(ns$cox2_initiation =="Yes" ))))

ns$incident_pud = rbinom(size = 1, n = nrow(ns), p = pbleed)
ns$incident_pud = factor(ns$incident_pud, labels=c("No","Yes"))


# Save R data set in the NAMCS package
usethis::use_data(ns, overwrite = TRUE)

