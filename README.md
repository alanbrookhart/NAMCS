NAMCS NSAID data
----------------

This package builds a cohort from the 2005-2009 public use files from
National Ambulatory Medical Care Data Survey (NAMCS). The NAMCS survey
covers over 20,000 visits per year and includes data on patient
demographics, comorbidities, physician and practice characteristics, and
treatment received, including medications. Currently, medications are
classified using the Multum Lexicon. Each year a few variables are added
to, deleted from, or recoded in the public use dataset.

From these data, we identify new users of either NSAID or Cox-2
selective non-steroidal antiinflammatory drugs (NSAIDs). The data is
augmented with a simulated peptic ulcer disease outcome. Variables were
selected for this extract based on relevance to the example analyses and
on availability for most or all of the 2005-2009 time range.

Installation
------------

You can install the package from Github

    library("devtools")
    devtools::install_github("alanbrookhart/NAMCS")

Codebook
--------

-   age = age in years of participant (years)
-   sex = sex of participant (Male vs Female)
-   year = year of the survey
-   race = paricipant race (Hispanic, White, Black, Other)
-   region = region of tee
-   msa = weather the participant lives in a metropolitan area
-   region = region of the country (south, north east, mid-west, west)
-   pcdoc = indicator of whether the physician is a primary care doctors
-   do = indicator of whether the physician is osteopath
-   cam = indicator of whether the physician practices alternative
    medicine
-   arthrtis = history of osteoarthritis
-   asthma = history of asthma
-   cancer = history of cancer
-   cebvd = history of cerebrovascular disease
-   crf = history of chronic renal failure
-   chf = history of heart failure
-   copd = history of chronic obstructive pulmonary disease
-   deprn = history of depression
-   diabetes = history of diabetes
-   hyplipid = history of hyperlipidemia
-   htn = history of hypertension
-   ihd = history of ischemic heart disease
-   ostprsis = history of osteoporosis
-   cox2\_initiation = new user of COX-2 selective inhibitors versus
    non-selective NSAIDs
-   contaht = history of use of antihypertensives
-   contstatin = history of use of statins
-   conth2antagonist = history of use of H2 blockers
-   contppi = history of use of proton pump inhibitors
-   contaspirin = history of use of aspirin
-   contanticoag = history of use of anticoagulants
-   contsteroids = history of use of steroids
-   incident\_pud = incident peptic ulcer disease during follow-up
    (simulated)

### 

    #library("NAMCS")
    head(ns) 

NAMCS Statin cohort data
------------------------

We have built a cohort from the 2005-2009 public use files from National
Ambulatory Medical Care Data Survey (NAMCS). The NAMCS survey covers
over 20,000 visits per year and includes data on patient demographics,
comorbidities, physician and practice characteristics, and treatment
received, including medications. Currently, medications are classified
using the Multum Lexicon. Each year a few variables are added to,
deleted from, or recoded in the public use dataset.

From these data, we identify all visits among adults who are not
currently treated with a statin. Patients are then either observed to
initiate a statin or remain untreated. Statin initiators are further
classified into users of high vs low potency statins.

We then use the baseline data to simulate two outcomes: risk of a
cardiovascular disease event and death. We further simulate the time to
protocol non-adherence (initation of a statin among patients who are
untreated or discontinuation of a statin among initiators.)

Codebook
--------

-   age = age in years of participant (years)
-   sex = sex of participant (Male vs Female)
-   year = year of the survey
-   race = paricipant race (Hispanic, White, Black, Other)
-   region = region of the country (south, north east, mid-west, west)
-   arthritis = history of osteoarthritis
-   asthma = history of asthma
-   cancer = history of cancer
-   cerebrovascular\_disease = history of cerebrovascular disease
-   chronic\_kidney\_disease = history of chronic renal disease
-   heart\_failure = history of heart failure
-   chronic\_pulmonary\_disease = history of chronic obstructive
    pulmonary disease
-   depression = history of depression
-   diabetes = history of diabetes
-   hyplipididemia = history of hyperlipidemia
-   mi = history of myocardial infarction
-   hypertension = history of hypertension
-   coronory\_artery\_disease = history of ischemic heart disease
-   osteoporosis = history of osteoporosis
-   obesity = patient is obese
-   tabocco\_use = patient has a history of smoking
-   anti\_hypertensive\_use = history of use of antihypertensives
-   h2\_antagonist\_use = history of use of H2 blockers,
    gastroprotective agents
-   ppi\_use = history of use of proton pump inhibitors,
    gastroprotective agents
-   aspirin\_use = history of use of aspirin
-   anti\_coagulant\_use = history of use of anticoagulants
-   corticosteroid\_use = history of use of steroids
-   incident\_pud = new diagnosis peptic ulcer disease durig follow-up
    (simulated

Notes
-----

NAMCS sampling weights are not included.
