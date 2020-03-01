################################################################################
### R script for Lucaciu et al.'s pooled analysis of Tofacitinib efficacy &  ###
### safety.  Script written by Nathan Constantine-Cooke                      ###
### https://github.com/nathansam                                             ###
################################################################################

# Load the MetaAnalysis function
source("functions.R")


require(meta)
require(metafor)

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

# Clinical remission at week 8
result.eff <- MetaAnalysis(cases = rem8, total = ni,
                        authorYear = AuthorYear, data = efficacy,
                        xlab = "Prop. in Clinical Remission at Wk8", 
                        dir = "all_patients")

# Clinical remission at week 24
result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = rem24, total = ni,
                               authorYear = AuthorYear, data = efficacy,
                               xlab = "Prop. in Clinical Remission at Wk24", 
                               dir = "all_patients"))

# Steroid-free clinical remission at week 24
result.eff <- rbind(result.eff,
                    MetaAnalysis(cases = sfrem24, total = ni,
                                 authorYear = AuthorYear, data = efficacy,
                                 xlab = "Prop in Steroid-Free Clinical Remission at Wk24", 
                                 dir = "all_patients"))

# Endoscopic remission
result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = endorem, total = ni,
                              authorYear = AuthorYear, data = efficacy,
                              xlab = "Prop. in Endoscopic Remission", 
                              dir = "all_patients"))
# Discontinued treatment
result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = discont, total = ni,
                              authorYear = AuthorYear, data = efficacy,
                              xlab = "Prop. Discontinued Treatment", 
                              dir = "all_patients"))

# Clinical response at week 8
result.eff <- rbind(result.eff,
                    MetaAnalysis(cases = resp8, total = ni,
                                 authorYear = AuthorYear, data = efficacy,
                                 xlab = "Prop. with Clinical Response at Wk8", 
                                 dir = "all_patients"))

# Clinical response at week 24
result.eff <- rbind(result.eff,
                    MetaAnalysis(cases = resp24, total = ni,
                                 authorYear = AuthorYear, data = efficacy,
                                 xlab = "Prop. with Clinical Response at Wk24", 
                                 dir = "all_patients"))

# Save tau^2, I^2 & predictions with confidence intervals to a csv file
result.eff <- round(result.eff, 4)
write.csv(result.eff, file = "results.efficacy.csv")


#################################### Safety ####################################

result.saf <- MetaAnalysis(cases = AE, total = ni,
                           authorYear = AuthorYear, data = safety,
                           xlab = "Prop. who had an Adverse Event", 
                           dir = "all_patients")


result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = PNR, total = ni,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Prop. with primary non-response", 
                                 dir = "all_patients"))

result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = HZ, total = ni,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Prop. who developed Herpes zoster", 
                                 dir = "all_patients"))
                    
result.saf <- rbind(result.saf,
                    MetaAnalysis(cases = Dislipidemia, total = ni,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Prop. who developed Dislipidemia", 
                                 dir = "all_patients"))

result.saf <- rbind(result.saf, 
                    MetaAnalysis(cases = Infection, total = ni,
                                 authorYear = AuthorYear, data = safety,
                                 xlab = "Prop. who had an Infection", 
                                 dir = "all_patients"))

result.saf <- rbind(result.saf, 
                    MetaAnalysis(cases = Colectomy, total = ni,
                                               authorYear = AuthorYear,
                                               data = safety,
                                               xlab = "Prop. who had a Colectomy", 
                                               dir = "all_patients"))
result.saf <- round(result.saf, 4)
write.csv(result.saf, file = "results.safety.csv")


################################################################################
############################# Non-dropout patients #############################
################################################################################

# This takes the maximum number of people for which an outcome can occur to be
# the number of patients who haven't dropped out of the trial for the time of
# the event. Only efficacy is investigated. 


week8cases <- efficacy[is.na(efficacy[, "wk8Tot"])==FALSE,]
result.dropout <- MetaAnalysis(cases = rem8, total = ni,
                               authorYear = AuthorYear, data = week8cases,
                               xlab = "Prop. in Clinical Remission at Wk8", 
                               dir = "nondropout_patients")
result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = resp8, total = ni,
                                     authorYear = AuthorYear, data = week8cases,
                                     xlab = "Prop. with Clinical Response at Wk8", 
                                     dir = "nondropout_patients"))

week24cases <- efficacy[is.na(efficacy[, "wk24Tot"])==FALSE,]
result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = rem24, total = ni,
                                     authorYear = AuthorYear,
                                     data = week24cases,
                                     xlab = "Prop. in Clinical Remission at Wk24",
                                     dir = "nondropout_patients"))
result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = resp24, total = ni,
                                     authorYear = AuthorYear, data = week8cases,
                                     xlab = "Prop. with Clinical Response at Wk24", 
                                     dir = "nondropout_patients"))

result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = sfrem24, total = ni,
                                     authorYear = AuthorYear,
                                     data = week24cases,
                                     xlab = "Prop. in steroid-free clinical Remission at Wk24",
                                     dir = "nondropout_patients"))
write.csv(result.dropout, file = "results.dropout.csv")
