source("functions.R")
require(meta)
require(metafor)

efficacy <- read.csv("efficacy.csv")
efficacy$AuthorYear <- paste(as.vector(efficacy$Author),
                             as.character(efficacy$Year))

result.eff <- MetaAnalysis(cases = rem8, total = ni,
                        authorYear = AuthorYear, data = efficacy,
                        xlab = "Prop. in Clinical Remission at Wk8", 
                        dir = "Plots")

result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = rem24, total = ni,
                               authorYear = AuthorYear, data = efficacy,
                               xlab = "Prop. in Clinical Remission at Wk24", 
                               dir = "Plots"))

 result.eff <- rbind(result.eff,
                  MetaAnalysis(cases = sfrem24, total = ni,
                               authorYear = AuthorYear, data = efficacy,
                               xlab = "Prop in Steroid-Free Clinical Remission at Wk24", 
                               dir = "Plots"))

result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = endorem, total = ni,
                              authorYear = AuthorYear, data = efficacy,
                              xlab = "Prop. in Endoscopic Remission", 
                              dir = "Plots"))

result.eff <- rbind(result.eff,
                 MetaAnalysis(cases = discont, total = ni,
                              authorYear = AuthorYear, data = efficacy,
                              xlab = "Prop. Discontinued Treatment", 
                              dir = "Plots"))
result.eff <- round(result.eff, 4)
write.csv(result.eff, file = "results.efficacy.csv")



safety <- read.csv("safety.csv")
safety$AuthorYear <- paste(as.vector(safety$Author),
                             as.character(safety$Year))

result.saf <- MetaAnalysis(cases = AE, total = ni,
                           authorYear = AuthorYear, data = safety,
                           xlab = "Prop. who had an Adverse Event", 
                           dir = "Plots")

result.saf <- rbind(result.saf, 
                    result.saf <- MetaAnalysis(cases = Infection, total = ni,
                                               authorYear = AuthorYear,
                                               data = safety,
                                               xlab = "Prop. who had an Infection", 
                                               dir = "Plots"))

result.saf <- rbind(result.saf, 
                    result.saf <- MetaAnalysis(cases = Colectomy, total = ni,
                                               authorYear = AuthorYear,
                                               data = safety,
                                               xlab = "Prop. who had a Colectomy", 
                                               dir = "Plots"))
result.saf <- round(result.saf, 4)
write.csv(result.saf, file = "results.safety.csv")
