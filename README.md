# Tofameta

- [Tofameta](#tofameta)
  - [Introduction](#introduction)
    - [R scripts](#r-scripts)
    - [Data](#data)
  - [Running the analysis](#running-the-analysis)
    - [Conventional approach](#conventional-approach)
    - [Docker image](#docker-image)
  - [Metadata](#metadata)
    - [Efficacy](#efficacy)
    - [Safety](#safety)

## Introduction

R scripts/ data for Lucaciu & Constantine-Cooke et al. *Real-world experience
with tofacitinib in ulcerative colitis - a systematic review and meta-analysis
of observational studies*. The scripts have been written by [Nathan
Constantine-Cooke](https://github.com/nathansam) and are licensed under the [MIT
license](LICENSE).

### R scripts

R scripts can be found in the `R/` directory.

`analysis.R` is the primary R script for performing the analysis.

`functions.R` contains the MetaAnalysis function used to perform the analysis.
This file does not need to be loaded separately, as the script will be sourced by
`analysis.R`

### Data

Data can be found in the `data/` directory

`efficacy.csv` and `safety.csv` contain the data used for the pooled analysis of
efficacy and safety respectively. Metadata for these files can be found below
in the dedicated section of this file.

## Running the analysis

Assuming [R](https://cloud.r-project.org) is already installed, this analysis
can be run either conventionally (using the `Rscript` terminal
command or Rstudio IDE), or via a Docker container. The former is easier to use
and more conventional to those familiar to R, whilst the latter is optimal for
reproducibility. Docker uses an image of the environment used to produce the analysis and will , in theory,
reproduce the same output many years into the future.

### Conventional approach

 If taking the conventional approach, the analysis can be run in just three
 lines from a bash/zsh terminal.

``` bash
git clone https://github.com/nathansam/tofameta
cd tofameta
Rscript R/analysis.R
```

You can now find the generated plots and csv files in the `output/` folder
within the `tofameta/` directory.

For those adverse to using git, you may prefer to download the source code from
the [releases page](https://github.com/nathansam/tfameta/releases), unzip the
source code and then run the `analysis.R` script in the `R/` folder. Please note
that your working directory will need to be the top-level directory of
`tofameta`.

### Docker image

If Docker is not already installed, then first
[install Docker](https://docs.docker.com/get-docker/). Running the below script
in a bash/zsh terminal will pull the `tofameta` image from GitHub's servers,
rename the image to a much nicer name than the format GitHub insists on, and
run the analysis. Note that in order to save the output outside of the container,
a volume must be specified using `-v`. Simply replace \<OUTPUTdirectory\> in the
below script with a path to where you wish the output to be saved.

``` bash
# Pull image
docker pull docker.pkg.github.com/nathansam/tofameta/tofameta:1.0.0
# Rename to a nicer tag
docker tag docker.pkg.github.com/nathansam/tofameta/tofameta:1.0.0 nathansam/tofameta
# Delete the old tag
docker rmi docker.pkg.github.com/nathansam/tofameta/tofameta:1.0.0
# Run the docker image
docker run -v <OutputDirectory>:/analysis/output nathansam/tofameta
```

Replacing \<OutputDirectory\> with the path to a directory you wish to store the
output from the script in (such as `~/output`).

If you wish to delete the image (around 1.25GB in size) after the analysis has
finished then run

``` bash
docker rmi -f nathansam/tofameta
```

## Metadata

This section provides descriptions of each of the columns in each data file.

### Efficacy

- `Year`: Year study was published
- `Author`: First author of study
- `ni`: Participants in the study
- `UC`: Participants with ulcerative colitis.
- `earlyResp`: Clinical response during the induction phase
- `lateResp`: Clinical response during the maintenance phase
- `earlyRem`: Clinical remission during the induction phase
- `lateRem`: Clinical remission during the maintenance phase
- `earlySFrem`: Steroid free clinical remission during the induction phase
- `lateSFrem24`: Steroid free clinical remission during the maintenance phase
- `endorem`: Endoscopic remission at any time point
- `CD`: Participants with Crohn's disease
- `IBDU`: Participants with inflammatory bowel disease unclassified
- `earlyTot`: Participants in study during induction phase
- `lateTot`: Participants in study during maintenance phase
- `antiTNF`: AntiTNF medication prior to joining study.
- `vedo`: Vedolizumab medication prior to joining study
- `uste`: Ustekinumab medication prior to joining study
- `noBio`: No biological medication prior to joining study (bio naive)
- `endoTot`: Participants who underwent endoscopy
- `age`: Median age of patients in the study

### Safety

- `Year`: Year study was published
- `Author`: Lead author of study
- `ni`: Participants in the study
- `Followup`: median followup for the study
- `AE`: Experienced an adverse event
- `HZ`: Developed herpes zoster
- `Dyslipidemia`: Developed dyslipidemia
- `malignancy`: Development of malignancy
- `Colectomy`: Underwent colectomy
- `PNR` Primary non-response
- `LOR` Loss of response
- `InfectionM`: Mild/moderate infection
- `InfectionS`: Severe infection
- `discont`: Treatment discontinuation at any time point
- `discontAE`: Treatment discontinued due to adverse event
- `discontColectomy`: Treatment discontinued due to colectomy
- `discontPNR`: Treatment discontinued due to primary non-response
- `discontLOR`: Treatment discontinued due to loss of response
- `discontPatient`: Treatment discontinued due to primary non-response
