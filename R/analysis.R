################################################################################
### R script for Lucaciu & Constantine-Cooke et al.'s                        ###
### "Real-world experience with tofacitinib in ulcerative colitis -          ###
### a systematic review and  meta-analysis"                                  ###
### Script written by Nathan Constantine-Cooke                               ###
### https://github.com/nathansam                                             ###
################################################################################

if (dir.exists("output") == FALSE) dir.create("output")
# Load the MetaAnalysis function
source("R/functions.R")
# If meta and/or metafor packages not installed then install them
packages <- c("meta", "metafor")
Npackages <- packages[!(packages %in% installed.packages()[, "Package"])]
if (length(Npackages)) install.packages(Npackages)

# Load table of efficacy results.
efficacy <- read.csv("data/efficacy.csv")


# Add column which combines Author name and year (used for forest plots)
efficacy$AuthorYear <- paste(as.vector(efficacy$Author),
                             as.character(efficacy$Year))

# Load table of safety results
safety <- read.csv("data/safety.csv")
safety$AuthorYear <- paste(as.vector(safety$Author),
                           as.character(safety$Year))

################################################################################
################################# All patients #################################
################################################################################

# This takes the maximum number of people for which an outcome can occur to be
# the number of patients in the trial. (not the patients which haven't dropped
# out)

################################### Efficacy ###################################

# Clinical remission at induction
defn <- "Proportion in clinical remission at induction"
outcome <- "clinical remission at induction"
result.eff <- MetaAnalysis(cases = earlyRem,
                           total = ni,
                           authorYear = AuthorYear,
                           data = efficacy,
                           xlab = defn,
                           funnel.outcome = outcome,
                           dir = "output/all_patients/")

# clinical remission at maintenance
defn <- "Proportion in clinical remission at maintenance"
outcome <- "clinical remission at maintenance"
result.eff <- rbind(result.eff,
                    MetaAnalysis(cases = lateRem,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = efficacy,
                                 xlab = defn,
                                 funnel.outcome = outcome,
                                 dir = "output/all_patients/"))

# Steroid-free clinical remission at maintenance
defn <- "Proportion in steroid-free clinical remission at maintenance"
result.eff <- rbind(result.eff,
                    MetaAnalysis(cases = lateSFrem,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = efficacy,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

# Endoscopic remission
defn <- "Proportion in endoscopic remission"
result.eff <- rbind(result.eff,
                    MetaAnalysis(cases = endorem,
                                 total = endoTot,
                                 authorYear = AuthorYear,
                                 data = efficacy,
                                 xlab = defn,
                                 dir = "output/all_patients/"))


# Clinical response during induction
defn <- "Proportion with clinical response at induction"
outcome <- "clinical response at induction"
result.eff <- rbind(result.eff,
                    MetaAnalysis(cases = earlyResp,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = efficacy,
                                 xlab = defn,
                                 funnel.outcome = outcome,
                                 dir = "output/all_patients/"))

# Clinical response during Maintenance
defn <- "Proportion with clinical response at maintenance"
outcome <- "clinical response at maintenance"
result.eff <- rbind(result.eff,
                    MetaAnalysis(cases = lateResp,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = efficacy,
                                 xlab = defn,
                                 funnel.outcome = outcome,
                                 dir = "output/all_patients/"))

# Save tau^2, I^2 & predictions with confidence intervals to a csv file
result.eff <- round(result.eff, 4)
write.csv(result.eff,
          file = "output/all_patients/results.efficacy.csv")


#################################### Safety ####################################

defn <- "Proportion had an adverse event"
result.saf <- MetaAnalysis(cases = AE,
                           total = ni,
                           authorYear = AuthorYear,
                           data = safety,
                           xlab = defn,
                           dir = "output/all_patients/")


defn <- "Proportion discontinued treatment"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = discont,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

defn <- "Proportion with primary non-response"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = PNR,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

defn <- "Proportion developed herpes zoster"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = HZ,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

defn <- "Proportion developed dyslipidaemia"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = Dyslipidemia,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

defn <- "Proportion had a mild infection"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = InfectionM,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

defn <- "Proportion had a serious infection"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = InfectionS,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

defn <- "Proportion developed VTE"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = VTE,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))


defn <- "Proportion had a colectomy"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = Colectomy,
                                 total = ni,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

defn <- "Proportion discontinued treatment due to AE"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = discontAE,
                                 total = discont,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

defn <- "Proportion discontinued treatment due to colectomy"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = discontColectomy,
                                 total = discont,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

defn <- "Proportion discontinued treatment due to PNR"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = discontPNR,
                                 total = discont,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

defn <- "Proportion discontinued treatment due to patient choice"
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = discontPatient,
                                 total = discont,
                                 authorYear = AuthorYear,
                                 data = safety,
                                 xlab = defn,
                                 dir = "output/all_patients/"))

result.saf <- round(result.saf, 4)
write.csv(result.saf, file = "output/all_patients/results.safety.csv")


################################################################################
############################# Non-dropout patients #############################
################################################################################

# This takes the maximum number of people for which an outcome can occur to be
# the number of patients haven't dropped out of the trial by the exoected
# time of the event. Only efficacy is investigated.


earlyCases <- efficacy[is.na(efficacy[, "earlyTot"]) == FALSE, ]

defn <- "Proportion in clinical remission at induction"
result.dropout <- MetaAnalysis(cases = earlyRem,
                               total = ni,
                               authorYear = AuthorYear,
                               data = earlyCases,
                               xlab = defn,
                               dir = "output/nondropout_patients/")

defn <- "Proportion with clinical response at induction"
result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = earlyResp,
                                     total = ni,
                                     authorYear = AuthorYear,
                                     data = earlyCases,
                                     xlab = defn,
                                     dir = "output/nondropout_patients/"))

lateCases <- efficacy[is.na(efficacy[, "lateTot"]) == FALSE, ]

defn <- "Proportion in clinical remission at maintenance"
result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = lateRem,
                                     total = ni,
                                     authorYear = AuthorYear,
                                     data = lateCases,
                                     xlab = defn,
                                     dir = "output/nondropout_patients/"))

defn <- "Proportion with clinical response at maintenance"
result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = lateResp,
                                     total = ni,
                                     authorYear = AuthorYear,
                                     data = lateCases,
                                     xlab = defn,
                                     dir = "output/nondropout_patients/"))

defn <- "Proportion in late steroid-free clinical remission"
result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = lateSFrem,
                                     total = ni,
                                     authorYear = AuthorYear,
                                     data = lateCases,
                                     xlab = defn,
                                     dir = "output/nondropout_patients/"))
write.csv(result.dropout,
          file = "output/nondropout_patients/results.dropout.csv")


################################################################################
################################# Full papers ##################################
################################################################################

# This only uses the full papers (not abstracts)

################################### Efficacy ###################################

full.papers.efficacy <- efficacy[c(1, 3, 5, 6, 10, 11, 12, 13), ]

defn <- "Proportion in clinical remission at induction"
result.eff.full <- MetaAnalysis(cases = earlyRem,
                                total = ni,
                                authorYear = AuthorYear,
                                data = full.papers.efficacy,
                                xlab = defn,
                                dir = "output/full_papers/")

# clinical remission at maintenance
defn <- "Proportion in clinical remission at maintenance"
result.eff.full <- rbind(result.eff.full,
                         MetaAnalysis(cases = lateRem,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.efficacy,
                                      xlab = defn,
                                      dir = "output/full_papers/"))


# Steroid-free clinical remission at induction
defn <- "Proportion in steroid-free clinical remission at induction"
result.eff.full <- rbind(result.eff.full,
                         MetaAnalysis(cases = earlySFrem,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.efficacy,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

# Steroid-free clinical remission at maintenance
defn <- "Proportion in steroid-free clinical remission at maintenance"
result.eff.full <- rbind(result.eff.full,
                         MetaAnalysis(cases = lateSFrem,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.efficacy,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

# Clinical response during induction
defn <- "Proportion with clinical response at induction"
result.eff.full <- rbind(result.eff.full,
                         MetaAnalysis(cases = earlyResp,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.efficacy,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

# Clinical response during Maintenance
defn <- "Proportion with clinical response at maintenance"
result.eff.full <- rbind(result.eff.full,
                         MetaAnalysis(cases = lateResp,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.efficacy,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

# Save tau^2, I^2 & predictions with confidence intervals to a csv file
result.eff.full <- round(result.eff.full, 4)
write.csv(result.eff.full,
          file = "output/full_papers/results.efficacy.csv")

#################################### Safety ####################################

full.papers.safety <- safety[c(1, 2, 4, 5, 8, 10, 11, 12, 13), ]


defn <- "Proportion discontinued treatment"
result.saf.full <- MetaAnalysis(cases = discont,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.safety,
                                      xlab = defn,
                                      dir = "output/full_papers/")

defn <- "Proportion had an adverse event"
result.saf <- MetaAnalysis(cases = AE,
                           total = ni,
                           authorYear = AuthorYear,
                           data = full.papers.safety,
                           xlab = defn,
                           dir = "output/full_papers/")

defn <- "Proportion with primary non-response"
result.saf.full <- rbind(result.saf.full,
                         MetaAnalysis(cases = PNR,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.safety,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

defn <- "Proportion developed herpes zoster"
result.saf.full <- rbind(result.saf.full,
                         MetaAnalysis(cases = HZ,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.safety,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

defn <- "Proportion developed dyslipidaemia"
result.saf.full <- rbind(result.saf.full,
                         MetaAnalysis(cases = Dyslipidemia,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.safety,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

defn <- "Proportion had a mild infection"
result.saf.full <- rbind(result.saf.full,
                         MetaAnalysis(cases = InfectionM,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.safety,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

defn <- "Proportion had a serious infection"
result.saf.full <- rbind(result.saf.full,
                         MetaAnalysis(cases = InfectionS,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.safety,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

defn <- "Proportion had a colectomy"
result.saf.full <- rbind(result.saf.full,
                         MetaAnalysis(cases = Colectomy,
                                      total = ni,
                                      authorYear = AuthorYear,
                                      data = full.papers.safety,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

defn <- "Proportion discontinued treatment due to AE"
result.saf.full <- rbind(result.saf.full,
                         MetaAnalysis(cases = discontAE,
                                      total = discont,
                                      authorYear = AuthorYear,
                                      data = full.papers.safety,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

defn <- "Proportion discontinued treatment due to colectomy"
result.saf.full <- rbind(result.saf.full,
                         MetaAnalysis(cases = discontColectomy,
                                      total = discont,
                                      authorYear = AuthorYear,
                                      data = full.papers.safety,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

defn <- "Proportion discontinued treatment due to PNR"
result.saf.full <- rbind(result.saf.full,
                         MetaAnalysis(cases = discontPNR,
                                      total = discont,
                                      authorYear = AuthorYear,
                                      data = full.papers.safety,
                                      xlab = defn,
                                      dir = "output/full_papers/"))

result.saf.full <- round(result.saf.full, 4)
write.csv(result.saf.full, file = "output/full_papers/results.safety.csv")
