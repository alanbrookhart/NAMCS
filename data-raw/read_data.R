
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
ns$sex=ifelse(ns$male==1,"Male","Female")
ns$race=factor(ns$racer,
               labels=c("White","Black","Other"))
ns$cox2 = ns$newcox2

names(ns)[names(ns) == "conth2antagonist"] = "h2_antagonist_use"
names(ns)[names(ns) == "contnstatin"] = "statin_use"
names(ns)[names(ns) == "contsteroids"] = "corticosteroid_use"
names(ns)[names(ns) == "contaht"] = "anti_hypertensive_use"
names(ns)[names(ns) == "contanticoag"] = "anti_coagulant_use"
names(ns)[names(ns) == "contppi"] = "ppi_use"
names(ns)[names(ns) == "htn"] = "hypertension"
names(ns)[names(ns) == "contaspirin"] = "aspirin_use"
names(ns)[names(ns) == "deprn"] = "depression"
names(ns)[names(ns) == "hyplipid"] = "hyperlipidemia"
names(ns)[names(ns) == "ckd"] = "chronic_kidney_disease"
names(ns)[names(ns) == "crf"] = "chronic_pulmonary_disease"
names(ns)[names(ns) == "ostprsis"] = "osteoporosis"
names(ns)[names(ns) == "arthrtis"] = "arthritis"
names(ns)[names(ns) == "ihd"] = "coronory_artery_disease"
names(ns)[names(ns) == "cox2"] = "cox2_initiation"

# drop unneeded columns
ns = ns %>% select(-starts_with("reas1")) %>%
  select(-starts_with("reas2")) %>%
  select(-starts_with("reason")) %>%
  select(-starts_with("urban")) %>%
  select(-starts_with("pct"))  %>%
  select(-contains("imp")) %>%
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

pbleed = 1/(1+exp(-(-8 + .6*ns$anti_coagulant_use+ .5*ns$corticosteroid_use +
                    .2*ns$aspirin_use + .7*ns$arthritis + .07*ns$age + .3*I(ns$sex == "Male") +
                    .02*I(ns$race == "Black")- .3*ns$cox2_initiation )))

ns$incident_pud = rbinom(size = 1, n = nrow(ns), p = pbleed)



# Save R data set in the NAMCS package
usethis::use_data(ns, overwrite = TRUE)

