source("functions.R")
require(meta)
require(metafor)

efficacy <- read.csv("efficacy.csv")
efficacy$AuthorYear <- paste(as.vector(efficacy$Author),
                             as.character(efficacy$Year))

result.eff <- MetaAnalysis(cases = rem8, total = ni,
                        authorYear = AuthorYear, data = efficacy,
                        xlab = "Prop. in Clinical Remission at Wk8", 
                        dir = "all_patients")

result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = rem24, total = ni,
                               authorYear = AuthorYear, data = efficacy,
                               xlab = "Prop. in Clinical Remission at Wk24", 
                               dir = "all_patients"))

 result.eff <- rbind(result.eff,
                  MetaAnalysis(cases = sfrem24, total = ni,
                               authorYear = AuthorYear, data = efficacy,
                               xlab = "Prop in Steroid-Free Clinical Remission at Wk24", 
                               dir = "all_patients"))

result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = endorem, total = ni,
                              authorYear = AuthorYear, data = efficacy,
                              xlab = "Prop. in Endoscopic Remission", 
                              dir = "all_patients"))

result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = discont, total = ni,
                              authorYear = AuthorYear, data = efficacy,
                              xlab = "Prop. Discontinued Treatment", 
                              dir = "all_patients"))
result.eff <- round(result.eff, 4)
write.csv(result.eff, file = "results.efficacy.csv")



safety <- read.csv("safety.csv")
safety$AuthorYear <- paste(as.vector(safety$Author),
                             as.character(safety$Year))

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


week8cases <- efficacy[is.na(efficacy[, "wk8Tot"])==FALSE,]
result.dropout <- MetaAnalysis(cases = rem8, total = ni,
                               authorYear = AuthorYear, data = week8cases,
                               xlab = "Prop. in Clinical Remission at Wk8", 
                               dir = "nondropout_patients")

week24cases <- efficacy[is.na(efficacy[, "wk24Tot"])==FALSE,]
result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = rem24, total = ni,
                                     authorYear = AuthorYear,
                                     data = week24cases,
                                     xlab = "Prop. in Clinical Remission at Wk24",
                                     dir = "nondropout_patients"))

result.dropout <- rbind(result.dropout,
                        MetaAnalysis(cases = sfrem24, total = ni,
                                     authorYear = AuthorYear,
                                     data = week24cases,
                                     xlab = "Prop. in steroid-free clinical Remission at Wk24",
                                     dir = "nondropout_patients"))
write.csv(result.dropout, file = "results.dropout.csv")
