# Tofameta

## Introduction

R scripts/ data for Lucaciu & Constantine-Cooke et al. pooled analysis of
tofacitinib efficacy & safety. The scripts have been written by Nathan
Constantine-Cooke https://github.com/nathansam and are licensed under the MIT
license.

### R scripts

R scripts can be found in the `R/` directory.

`analysis.R` is the primary R script for performing the analysis.

`functions.R` contains the MetaAnalysis function used to perform the analysis.
This file does not need to be loaded separately, as the script will be run by
`analysis.R`

### Data

Data can be found in the `data/` directory

`efficacy.csv` and `safety.csv` contain the data used for the pooled analysis of
efficacy and safety respectively. Metadata for these files can be found below.

## Metadata

Descriptions of each of the columns stratified by data file. 

### Efficacy

* `Year`: Year study was published
* `Author`: First author of study
* `ni`: Participants in the study
* `UC`: Participants with ulcerative colitis.
* `earlyResp`: Clinical response during the induction phase
* `lateResp`: Clinical response during the maintenance phase
* `earlyRem`: Clinical remission during the induction phase
* `lateRem`: Clinical remission during the maintenance phase
* `earlySFrem`: Steroid free clinical remission during the induction phase
* `lateSFrem24`: Steroid free clinical remission during the maintenance phase
* `endorem`: Endoscopic remission at any time point
* `CD`: Participants with Crohn's disease
* `IBDU`: Participants with inflammatory bowel disease unclassified
* `earlyTot`: Participants in study during induction phase
* `lateTot`: Participants in study during maintenance phase
* `antiTNF`: AntiTNF medication prior to joining study.
* `vedo`: Vedolizumab medication prior to joining study
* `uste`: Ustekinumab medication prior to joining study
* `noBio`: No biological medication prior to joining study (bio naive)
* `endoTot`: Participants who underwent endoscopy
* `age`: Median age of patients in the study

### Safety

* `Year`: Year study was published
* `Author`: Lead author of study
* `ni`: Participants in the study
* `Followup`: median followup for the study
* `AE`: Experienced an adverse event
* `HZ`: Developed herpes zoster
* `Dyslipidemia`: Developed dyslipidemia
* `malignancy`: Development of malignancy
* `Colectomy`: Underwent colectomy
* `PNR` Primary non-response
* `LOR` Loss of response
* `InfectionM`: Mild/moderate infection
* `InfectionS`: Severe infection
* `discont`: Treatment discontinuation at any time point
* `discontAE`: Treatment discontinued due to adverse event
* `discontColectomy`: Treatment discontinued due to colectomy
* `discontPNR`: Treatment discontinued due to primary non-response
* `discontLOR`: Treatment discontinued due to loss of response
* `discontPatient`: Treatment discontinued due to primary non-response
