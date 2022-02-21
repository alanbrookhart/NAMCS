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

    ## Loading required package: usethis

    ## Downloading GitHub repo alanbrookhart/NAMCS@HEAD

    ## 
    ## * checking for file ‘/private/var/folders/mc/th3fg_h15qlgvxv6znh6rkncjl_0ds/T/Rtmphw3JLa/remotesac4464c865fb/alanbrookhart-NAMCS-29fe223/DESCRIPTION’ ... OK
    ## * preparing ‘NAMCS’:
    ## * checking DESCRIPTION meta-information ... OK
    ## * checking for LF line-endings in source and make files and shell scripts
    ## * checking for empty or unneeded directories
    ## * building ‘NAMCS_0.1.0.tar.gz’
    ## Warning: invalid uid value replaced by that for user 'nobody'
    ## Warning: invalid gid value replaced by that for user 'nobody'

### Variable names

    library("NAMCS")
    names(ns)

    ##  [1] "year"                      "region"                   
    ##  [3] "age"                       "cam"                      
    ##  [5] "arthritis"                 "asthma"                   
    ##  [7] "cancer"                    "cerebrovascular_disease"  
    ##  [9] "chronic_pulmonary_disease" "chf"                      
    ## [11] "copd"                      "depression"               
    ## [13] "diabetes"                  "hyperlipidemia"           
    ## [15] "hypertension"              "coronory_artery_disease"  
    ## [17] "osteoporosis"              "cox2_initiation"          
    ## [19] "anti_hypertensive_use"     "contstatin"               
    ## [21] "h2_antagonist_use"         "ppi_use"                  
    ## [23] "aspirin_use"               "anti_coagulant_use"       
    ## [25] "corticosteroid_use"        "pud"                      
    ## [27] "sex"                       "race"                     
    ## [29] "incident_pud"

### Example of data

    head(ns) 

    ##   year    region age cam arthritis asthma cancer cerebrovascular_disease
    ## 1 2005 Northeast  44   0         0      0      0                       0
    ## 2 2005 Northeast  58   0         0      0      0                       0
    ## 3 2005 Northeast  78   0         0      0      0                       0
    ## 4 2005 Northeast  23   0         0      0      0                       0
    ## 5 2005 Northeast  56   0         1      0      0                       0
    ## 6 2005 Northeast  68   0         1      0      0                       0
    ##   chronic_pulmonary_disease chf copd depression diabetes hyperlipidemia
    ## 1                         0   0    0          0        0              0
    ## 2                         0   0    0          0        0              0
    ## 3                         0   0    0          0        0              0
    ## 4                         0   0    0          0        0              0
    ## 5                         0   0    0          0        0              0
    ## 6                         0   0    0          0        1              0
    ##   hypertension coronory_artery_disease osteoporosis cox2_initiation
    ## 1            0                       0            0               0
    ## 2            0                       0            0               1
    ## 3            0                       0            0               0
    ## 4            0                       0            0               0
    ## 5            0                       0            0               0
    ## 6            0                       0            0               0
    ##   anti_hypertensive_use contstatin h2_antagonist_use ppi_use aspirin_use
    ## 1                     0          0                 0       0           0
    ## 2                     0          0                 0       0           0
    ## 3                     0          0                 0       0           0
    ## 4                     0          0                 0       0           0
    ## 5                     0          0                 0       0           0
    ## 6                     0          0                 0       1           0
    ##   anti_coagulant_use corticosteroid_use pud    sex  race incident_pud
    ## 1                  0                  0   0   Male White            1
    ## 2                  0                  0   0 Female White            0
    ## 3                  0                  0   0 Female White            0
    ## 4                  0                  0   0   Male White            0
    ## 5                  0                  0   0   Male White            0
    ## 6                  0                  0   0 Female White            0

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
