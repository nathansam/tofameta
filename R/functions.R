################################################################################
### R script for  the MetaAnalysis function used in Lucaciu &                ###
### Constantine-Cooke et al.'s                                               ###
### "Real-world experience with tofacitinib in ulcerative colitis -          ###
### a systematic review and  meta-analysis"                                  ###
### Script written by Nathan Constantine-Cooke                               ###  
### https://github.com/nathansam                                             ###
################################################################################

MetaAnalysis <- function(cases, total, authorYear, data, xlab, dir) {
  
  outcome <- deparse(substitute(cases)) #outcome name as string"
  
  # Create directory if it doesn't already exist
  if(dir.exists(dir) == FALSE) dir.create(dir)
  
  subdir <- paste(dir, "/", outcome, sep = "")
  if(dir.exists(subdir) == FALSE) dir.create(subdir)
  
  pdf.dir <- paste(subdir, "/pdf", sep = "")
  if(dir.exists(pdf.dir) == FALSE) dir.create(pdf.dir)
  
  png.dir <- paste(subdir, "/png", sep = "")
  if(dir.exists(png.dir) == FALSE) dir.create(png.dir)
 
  cases <- round(eval(substitute(cases), data, parent.frame()))
  non.NA <- is.na(cases) == FALSE
  cases <- cases[non.NA]
  total <- round(eval(substitute(total), data, parent.frame()))
  total <- total[non.NA]
  authorYear <- eval(substitute(authorYear), data, parent.frame())
  authorYear <- authorYear[non.NA]
  
  # Logit transfromation
  ies <- metafor::escalc(xi = cases, ni = total, measure = "PLO")
  # Random effects model fitted using the DerSimonian and Laird
  pes.logit <- metafor::rma(yi, vi, data = ies, method = "DL")

  # Outlier plot
  inf <- influence(pes.logit)
  png(file <-  paste(png.dir, "/", outcome, "_outliers.png", sep = ""),
      width = 600)
  plot(inf)
  dev.off()
  
  pdf(file <-  paste(pdf.dir, "/", outcome, "_outliers.pdf", sep = ""),
      width = 8)
  plot(inf)
  dev.off()
  
  # Funnel plot
  png(file <-  paste(png.dir, "/", outcome, "_funnel.png", sep = ""),
      width = 600)
  funnel(pes.logit)
  title(main = paste("Funnel plot of", outcome))
  egger.pval <- round(regtest(pes.logit)$pval, 3) 
  if (egger.pval < 0.05){
    plot.col <- "red"
  }  else{
    plot.col <- "black"
  } 
  legend("topright",
         paste("p =", egger.pval),
         bty="n",
         text.col = plot.col,
         cex = 1.2) 
  dev.off()
  
  pdf(file <-  paste(pdf.dir, "/", outcome, "_funnel.pdf", sep = ""),
      width = 8)
  funnel(pes.logit)
  title(main = paste("Funnel plot of", outcome))
  egger.pval <- round(regtest(pes.logit)$pval, 3) 
  
  if (egger.pval < 0.05){
    plot.col <- "red"
  }  else{
    plot.col <- "black"
  } 
  legend("topright",
         paste("p =", egger.pval),
         bty="n",
         text.col = plot.col,
         cex = 1.2) 
  dev.off()
  
  values <- confint(pes.logit)$random
  tau2 <- matrix(values[1, ], nrow = 1) # tau^2 pred + CI values
  colnames(tau2) <- c("tau2", "tau2.lb", "tau2.up")
  
  I2 <- matrix(values[3, ], nrow = 1) # I^2 pred + CI values
  colnames(I2) <- c("I2", "I2.lb", "I2.up")
  
  # * for influential studies
  influential <- inf$inf$inf
  authorYear <- paste(authorYear, influential)
  
  # Inverse logit transformation
  pes <- predict(pes.logit, transf = transf.ilogit)
  
  # Predicted proportion + CI values
  pred <- matrix(c(pes$pred, pes$ci.lb, pes$ci.ub), nrow = 1)
  colnames(pred) <- c("prop", "prop.lb", "prop.ub")
  
  result <- cbind(tau2, I2, pred, egger.pval)
  rownames(result) <- outcome
  
  #### Forest plot ####
  
  pes.summary <- meta::metaprop(round(cases),
                                total,
                                authorYear,
                                sm = "PLO",
                                method.tau="DL",
                                method.ci="NAsm")
  
  # xlim larger than maximum CI value and a multiple of 0.2.
  xlim <- (max(ceiling(pes.summary$upper[is.na(pes.summary$upper) == F] / 0.2)) * 0.2) 
  
  
  png(file = paste(png.dir, "/", outcome, ".png", sep = ""), width = 600)
  meta::forest(pes.summary,
               rightcols = FALSE,
               leftcols = c("studlab", "event", "n", "effect", "ci"),
               leftlabs = c("Study",
                            "Cases",
                            "Total",
                            "Proportion",
                            "95% C.I."),
               xlab = xlab,
               smlab = "",
               weight.study = "random",
               squaresize = 0.5,
               col.square = "navy",
               col.square.lines = "navy",
               col.diamond = "maroon",
               col.diamond.lines = "maroon",
               pooled.totals = FALSE,
               comb.fixed = FALSE,
               fs.hetstat = 12,
               print.tau2 = TRUE,
               print.Q = TRUE,
               print.pval.Q = TRUE,
               print.I2 = TRUE,
               digits = 2,
               xlim = c(0, xlim))
  dev.off()
  
  # Same plot again but saved in vector format. 
  pdf(file = paste(pdf.dir, "/", outcome, ".pdf", sep = ""), width = 8)
  meta::forest(pes.summary, rightcols = FALSE,
               leftcols = c("studlab", "event", "n", "effect", "ci"),
               leftlabs = c("Study",
                            "Cases",
                            "Total",
                            "Proportion",
                            "95% C.I."),
               xlab = xlab,
               smlab = "",
               weight.study = "random",
               squaresize = 0.5,
               col.square = "navy",
               col.square.lines = "navy",
               col.diamond = "maroon",
               col.diamond.lines = "maroon",
               pooled.totals = FALSE,
               comb.fixed = FALSE,
               fs.hetstat = 12,
               print.tau2 = TRUE,
               print.Q = TRUE,
               print.pval.Q = TRUE,
               print.I2 = TRUE,
               digits = 2,
               xlim = c(0, xlim))
  dev.off()
  return(result)
}