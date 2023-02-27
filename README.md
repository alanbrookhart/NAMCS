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
selective non-steroidal antiinflammatory drugs (NSAIDs). The data are
augmented with a simulated peptic ulcer disease outcome. Variables were
selected for this extract based on relevance to the example analyses and
on availability for most or all of the 2005-2009 time range.

Installation
------------

You can install the package from Github

    library("devtools")
    devtools::install_github("alanbrookhart/NAMCS")

### Variable names

    library("NAMCS")
    names(ns)

    ##  [1] "year"                      "region"                   
    ##  [3] "age"                       "arthritis"                
    ##  [5] "asthma"                    "cancer"                   
    ##  [7] "cerebrovascular_disease"   "chronic_kidney_disease"   
    ##  [9] "heart_failure"             "chronic_pulmonary_disease"
    ## [11] "depression"                "diabetes"                 
    ## [13] "hyperlipidemia"            "hypertension"             
    ## [15] "coronory_artery_disease"   "osteoporosis"             
    ## [17] "cox2_initiation"           "anti_hypertensive_use"    
    ## [19] "statin_use"                "h2_antagonist_use"        
    ## [21] "ppi_use"                   "aspirin_use"              
    ## [23] "anti_coagulant_use"        "corticosteroid_use"       
    ## [25] "sex"                       "race"                     
    ## [27] "incident_pud"

### Example of data

    head(ns) 

    ##   year    region age arthritis asthma cancer cerebrovascular_disease
    ## 1 2005 Northeast  44        No     No     No                      No
    ## 2 2005 Northeast  58        No     No     No                      No
    ## 3 2005 Northeast  78        No     No     No                      No
    ## 4 2005 Northeast  23        No     No     No                      No
    ## 5 2005 Northeast  56       Yes     No     No                      No
    ## 6 2005 Northeast  68       Yes     No     No                      No
    ##   chronic_kidney_disease heart_failure chronic_pulmonary_disease depression
    ## 1                     No            No                        No         No
    ## 2                     No            No                        No         No
    ## 3                     No            No                        No         No
    ## 4                     No            No                        No         No
    ## 5                     No            No                        No         No
    ## 6                     No            No                        No         No
    ##   diabetes hyperlipidemia hypertension coronory_artery_disease osteoporosis
    ## 1       No             No           No                      No           No
    ## 2       No             No           No                      No           No
    ## 3       No             No           No                      No           No
    ## 4       No             No           No                      No           No
    ## 5       No             No           No                      No           No
    ## 6      Yes             No           No                      No           No
    ##   cox2_initiation anti_hypertensive_use statin_use h2_antagonist_use ppi_use
    ## 1              No                    No         No                No      No
    ## 2             Yes                    No         No                No      No
    ## 3              No                    No         No                No      No
    ## 4              No                    No         No                No      No
    ## 5              No                    No         No                No      No
    ## 6              No                    No         No                No     Yes
    ##   aspirin_use anti_coagulant_use corticosteroid_use    sex  race incident_pud
    ## 1          No                 No                 No   Male White           No
    ## 2          No                 No                 No Female White           No
    ## 3          No                 No                 No Female White           No
    ## 4          No                 No                 No   Male White           No
    ## 5          No                 No                 No   Male White           No
    ## 6          No                 No                 No Female White           No
    
    
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


Notes
-----

NAMCS sampling weights are not included.
