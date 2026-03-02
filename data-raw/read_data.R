# read_data.R
# Purpose: read-in subsetted NAMCS data and save as package data
library(tidyverse)
library(foreign)

# 1. Helpers
to_no_yes <- function(x) factor(x, levels = c(0, 1), labels = c("No", "Yes"))

drop_patterns <- c("reas", "urban", "pct", "imp", "pud", "cam", "bp",
                   "major", "code", "mddo", "new", "nsnsaid", "spec",
                   "west", "east", "payer", "south", "racer", "raceb",
                   "nonmetro", "male", "contnsaid", "msa", "pcdoc", "do", "zip")

# 2. Processing
ns <- read.dta("./data-raw/nsaid008.dta") %>%
  as_tibble() %>%
  rename(
    h2_antagonist_use = conth2antagonist,
    statin_use = contstatin,
    corticosteroid_use = contsteroids,
    anti_hypertensive_use = contaht,
    anti_coagulant_use = contanticoag,
    heart_failure = chf,
    ppi_use = contppi,
    cerebrovascular_disease = cebvd,
    hypertension = htn,
    aspirin_use = contaspirin,
    depression = deprn,
    hyperlipidemia = hyplipid,
    chronic_kidney_disease = crf,
    chronic_pulmonary_disease = copd,
    osteoporosis = ostprsis,
    arthritis = arthrtis,
    coronory_artery_disease = ihd,
    cox2_initiation = newcox2
  ) %>%
  mutate(
    region = factor(region, labels = c("Northeast", "Midwest", "South", "West")),
    year   = as_factor(year),
    sex    = if_else(male == 1, "Male", "Female"),
    race   = factor(racer, labels = c("White", "Black", "Other")),
    across(where(is.numeric) & !c(age, year), to_no_yes)
  ) %>%
  select(-any_of(drop_patterns), -starts_with(c("reas", "reason")))

# 3. Simulation
set.seed(102)
ns <- ns %>%
  mutate(
    pbleed = 1 / (1 + exp(-(-6.5 +
                              0.6 * (anti_coagulant_use == "Yes") +
                              0.5 * (corticosteroid_use == "Yes") +
                              0.2 * (aspirin_use == "Yes") +
                              0.7 * (arthritis == "Yes") +
                              0.07 * age +
                              0.3 * (sex == "Male") +
                              0.02 * (race == "Black") -
                              0.3 * (cox2_initiation == "Yes")
    ))),
    incident_pud = rbinom(n(), size = 1, prob = pbleed),
    incident_pud = factor(incident_pud, labels = c("No", "Yes"))
  ) %>%
  select(-pbleed)

# 4. Save as .rda in the data/ folder
if (!dir.exists("data")) dir.create("data")

# Saving 'ns' as 'ns.rda' ensures data(ns) works once the package is loaded
save(ns, file = "data/ns.rda", compress = "xz")

message("Data saved to data/ns.rda")
