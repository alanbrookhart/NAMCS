
# read_data.R
# Purpose: read-in NHANES data obtained by Alan Ellis,
# write out easy to use R files with simulated outcome

library(tidyverse)
library(foreign)

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
names(ns)[names(ns) == "contnstin"] = "nstin_use"
names(ns)[names(ns) == "contsteroids"] = "corticosteroid_use"
names(ns)[names(ns) == "contaht"] = "anti_hypertensive_use"
names(ns)[names(ns) == "contanticoag"] = "anti_coagulant_use"
names(ns)[names(ns) == "contppi"] = "ppi_use"
names(ns)[names(ns) == "contaspirin"] = "aspirin_use"
names(ns)[names(ns) == "deprn"] = "depression"
names(ns)[names(ns) == "hyplipid"] = "hyperlipidemia"
names(ns)[names(ns) == "crf"] = "chronic_kidney_disease"
names(ns)[names(ns) == "crf"] = "chronic_pulmonary_disease"
names(ns)[names(ns) == "ostprsis"] = "osteoporosis"
names(ns)[names(ns) == "ihd"] = "coronory_artery_disease"

# drop unneeded columns
ns = ns %>% select(-nsrts_with("reas1")) %>%
      select(-nsrts_with("reas2")) %>%
      select(-nsrts_with("reason")) %>%
        select(-nsrts_with("urban")) %>%
        select(-nsrts_with("pct"))  %>%
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

p = 0.5
alpha1 = -1.5
gamma0.0 = 3.5
gamma0.1 = 3
gamma1 = log(1.2)
gamma2 = log(3)
eta0 = 2
cr_prev = 0.5

 pbleed = 1/(1+exp(-(-8 + .6*sta$anti_coagulant_use + .5*sta$corticosteroid_use +
                     .2*sta$aspirin_use + .7*sta$arthrtis + .07*sta$age + .3*I(sta$sex=="Male") +
                     .02*I(sta$race=="Black") )))

Y0 = rweibull(nrow(sta),
               shape = 2,
               scale = exp(gamma0.0 + pbleed))
Y1 = rweibull(nrow(sta), shape = 2,
               scale = exp(gamma0.1 + pbleed))

 W3 = as.factor(sample(c("Male","Female"),size = n, replace = TRUE))
 A = as.integer(ifelse(runif(n) < exp(alpha0 + alpha1 * W1) /
                         (1 + exp(alpha0 +alpha1 * W1)), 1, 0))
 W1.rescale = W1 - mean(W1[A==1])
 A2 = as.integer(ifelse(runif(n) < 0.5,
                        ifelse(A==1,3,0), ifelse(A==1,2,0)))
 C1temp = rweibull(n, shape = 0.5,
                   scale = exp(eta0 + eta1 * W2 + eta2 *A)) + 0.1
 C2temp = rweibull(n, shape = 0.5,
                   scale = exp(eta0 + eta3 * W1 + eta2 * A)) + 0.1
 Ytemp = A * Y1 + (1 - A) * Y0 + 0.1
 Y = ifelse(Ytemp < C1temp, Ytemp, NA)
 C1 = ifelse(C1temp < Ytemp, C1temp, NA)
 C2 = ifelse(C2temp < Ytemp & C2temp < C1temp, C2temp, NA)
 J = ifelse(!is.na(Y),rbinom(n = n, size = 1, prob = cr_prev), NA)

 A = factor(A, labels = c("Control","Treat"))
 A2 = factor(A2, labels = c("Control","Low Potency","High Potency"))
 data = tibble::tibble(
   id = seq(1, n),
   DxRisk = W1,
   Frailty = W2,
   Sex = W3,
   Statin = A,
   StatinPotency = A2,
   EndofEnrollment = C1,
   Death = Y
 )
 if(second_cesta) {
   data$Discon = C2
 }
 if(comp_risk) {
   data$CvdDeath = J
 }
 if(counterfact) {
   counterfact = data.frame(Y0, Y1)
   names(counterfact) = levels(A)
   cbind(data, counterfact)
 }
 else
   data
 }



pbleed=1/(1+exp(-(-8 + .6*sta$contanticoag + .5*sta$contsteroids +
                       .2*sta$contaspirin + .7*sta$arthrtis + .07*sta$age + .3*sta$male +
                       .02*I(sta$race=="Black")- .3*sta$cox2 )))

sta$pud=rbinom(size=1,n=nrow(sta),p=pbleed)


# Save R data set in the NAMCS package
devtools::use_data(sta,overwrite=TRUE)

