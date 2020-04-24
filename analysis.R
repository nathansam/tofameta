################################################################################
### R script for Lucaciu et al.'s pooled analysis of tofacitinib efficacy &  ###
### safety.  Script written by Nathan Constantine-Cooke                      ###
### https://github.com/nathansam                                             ###
################################################################################

# Load the MetaAnalysis function
source("functions.R")

# If meta and/or metafor packages not installed then install them 
packages <- c("meta", "metafor")
Npackages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(Npackages)) install.packages(Npackages)

library(meta); library(metafor)

# Load table of efficacy results. 
efficacy <- read.csv("efficacy.csv")


# Add column which combines Author name and year (used for forest plots)
efficacy$AuthorYear <- paste(as.vector(efficacy$Author),
                             as.character(efficacy$Year))

# Load table of safety results
safety <- read.csv("safety.csv")
safety$AuthorYear <- paste(as.vector(safety$Author),
                           as.character(safety$Year))

################################################################################
################################# All patients #################################
################################################################################

# This takes the maximum number of people for which an outcome can occur to be
# the number of patients in the trial. (not the patients which haven't dropped
# out )

################################### Efficacy ###################################

# Clinical remission at induction
result.eff <- MetaAnalysis(cases = earlyRem, total = ni,
                        authorYear = AuthorYear, data = efficacy,
                        xlab = "Proportion in clinical remission at Induction", 
                        dir = "all_patients")

# clinical remission at maintenance
result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = lateRem, total = ni,
                               authorYear = AuthorYear, data = efficacy,
                               xlab = "Proportion in clinical remission at maintenance", 
                               dir = "all_patients"))

# Steroid-free clinical remission at maintenance.
result.eff <- rbind(result.eff,
                    MetaAnalysis(cases = lateSFrem, total = ni,
                                 authorYear = AuthorYear, data = efficacy,
                                 xlab = "Proportion in steroid-free clinical remission at maintenance", 
                                 dir = "all_patients"))

# Endoscopic remission
result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = endorem, total = endoTot,
                              authorYear = AuthorYear, data = efficacy,
                              xlab = "Proportion in endoscopic remission", 
                              dir = "all_patients"))
# Discontinued treatment
result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = discont, total = ni,
                              authorYear = AuthorYear, data = safety,
                              xlab = "Proportion discontinued treatment", 
                              dir = "all_patients"))

# Clinical response during induction
result.eff <- rbind(result.eff,
                    MetaAnalysis(cases = earlyResp, total = ni,
                                 authorYear = AuthorYear, data = efficacy,
                                 xlab = "Proportion with clinical response at induction", 
                                 dir = "all_patients"))

# Clinical response during Maintenance
result.eff <- rbind(result.eff,
                    MetaAnalysis(cases = lateResp, total = ni,
                                 authorYear = AuthorYear, data = efficacy,
                                 xlab = "Proportion with clinical response at maintenance", 
                                 dir = "all_patients"))




# Save tau^2, I^2 & predictions with confidence intervals to a csv file
result.eff <- round(result.eff, 4)



write.csv(result.eff, file = "results.efficacy.csv")


#################################### Safety ####################################

result.saf <- MetaAnalysis(cases = AE, total = ni,
                           authorYear = AuthorYear, data = safety,
                           xlab = "Proportion had an adverse event", 
                           dir = "all_patients")


result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = PNR, total = ni,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Proportion with primary non-response", 
                                 dir = "all_patients"))

result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = HZ, total = ni,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Proportion developed herpes zoster", 
                                 dir = "all_patients"))
                    
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = Dyslipidemia, total = ni,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Proportion developed dyslipidaemia", 
                                 dir = "all_patients"))

result.saf <- rbind(result.saf, 
                    MetaAnalysis(cases = InfectionM, total = ni,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Proportion had a mild infection", 
                                 dir = "all_patients"))

result.saf <- rbind(result.saf, 
                    MetaAnalysis(cases = InfectionS, total = ni,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Proportion had a serious infection", 
                                 dir = "all_patients"))

result.saf <- rbind(result.saf, 
                    MetaAnalysis(cases = Colectomy, total = ni,
                                               authorYear = AuthorYear,
                                               data = safety,
                                               xlab = "Proportion had a colectomy", 
                                               dir = "all_patients"))

############################### Treatment Discont. #############################

result.saf <- rbind(result.eff,
                    MetaAnalysis(cases = discontAE, total = discont,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Proportion discontinued treatment due to AE", 
                                 dir = "all_patients"))

result.saf <- rbind(result.eff,
                    MetaAnalysis(cases = discontColectomy, total = discont,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Proportion discontinued treatment due to colectomy", 
                                 dir = "all_patients"))
result.saf <- rbind(result.eff,
                    MetaAnalysis(cases = discontPNR, total = discont,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Proportion discontinued treatment due to PNR", 
                                 dir = "all_patients"))

result.saf <- rbind(result.eff,
                    MetaAnalysis(cases = discontLOR, total = discont,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Proportion discontinued treatment due to LOR", 
                                 dir = "all_patients"))

result.saf <- rbind(result.eff,
                    MetaAnalysis(cases = discontPatient, total = discont,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Proportion discontinued treatment due to patient choice", 
                                 dir = "all_patients"))

result.saf <- round(result.saf, 4)
write.csv(result.saf, file = "results.safety.csv")


################################################################################
############################# Non-dropout patients #############################
################################################################################

# This takes the maximum number of people for which an outcome can occur to be
# the number of patients haven't dropped out of the trial by the exoected
# time of the event. Only efficacy is investigated. 


earlyCases <- efficacy[is.na(efficacy[, "earlyTot"])==FALSE,]
result.dropout <- MetaAnalysis(cases = earlyRem, total = ni,
                               authorYear = AuthorYear, data = earlyCases,
                               xlab = "Proportion in clinical remission at induction", 
                               dir = "nondropout_patients")
result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = earlyResp, total = ni,
                                     authorYear = AuthorYear, data = earlyCases,
                                     xlab = "Proportion with clinical response at induction", 
                                     dir = "nondropout_patients"))

lateCases<- efficacy[is.na(efficacy[, "lateTot"])==FALSE,]
result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = lateRem, total = ni,
                                     authorYear = AuthorYear,
                                     data = lateCases,
                                     xlab = "Proportion in clinical remission at maintenance",
                                     dir = "nondropout_patients"))
result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = lateResp, total = ni,
                                     authorYear = AuthorYear, data = lateCases,
                                     xlab = "Proportion with clinical response at maintenance", 
                                     dir = "nondropout_patients"))

result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = lateSFrem, total = ni,
                                     authorYear = AuthorYear,
                                     data = lateCases,
                                     xlab = "Proportion in late steroid-free clinical remission",
                                     dir = "nondropout_patients"))
write.csv(result.dropout, file = "results.dropout.csv")
