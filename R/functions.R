################################################################################
### R script for  the MetaAnalysis function used in Lucaciu &                ###
### Constantine-Cooke et al.'s                                               ###
### "Real-world experience with tofacitinib in ulcerative colitis -          ###
### a systematic review and  meta-analysis"                                  ###
### Script written by Nathan Constantine-Cooke                               ###  
### https://github.com/nathansam                                             ###
################################################################################

#' @title Create directories for output from meta-analysis
#' @description If not already available, creates folders for all output, 
#' for the specific outcome and for png and pdf versions of files   
#' @param outcome String. Name of outcome. 
#' @param dir Top-level directory to save plots and tables.   
#' @return List which provides location of pdf and png directories for
#' \code{outome}
CreateDirectory <- function(outcome, dir){
  # Create directory if it doesn't already exist
  if(dir.exists(dir) == FALSE) dir.create(dir)
  # Create directory for outcome
  subdir <- paste(dir, "/", outcome, sep = "")
  if(dir.exists(subdir) == FALSE) dir.create(subdir)
  # Create directory within the outcome directory for pdf files
  pdf.dir <- paste(subdir, "/pdf", sep = "")
  if(dir.exists(pdf.dir) == FALSE) dir.create(pdf.dir)
  # Create directory within the outcome directory for png files
  png.dir <- paste(subdir, "/png", sep = "")
  if(dir.exists(png.dir) == FALSE) dir.create(png.dir)
  return(list(pdf.dir = pdf.dir, png.dir = png.dir))
}

#' @title Plot diagnostics for outliers/ influential studies. 
#' @param pes.logit A Random effects model fitted using the DerSimonian and
#' Laird method  
#' @param outcome String. Name of outcome of interest. 
#' @param directories List of directories created by \link{CreateDirectory}
#' @param img.format String. Format to save plots. Either "png" or "pdf".  
#' @return influence object
PlotOutliers <- function(pes.logit, outcome, directories, img.format){
  # Outlier plot
  inf <- metafor::influence.rma.uni(pes.logit)
  if (img.format == "png"){
    png(file <-  paste(directories$png.dir,
                       "/",
                       outcome,
                       "_outliers.png",
                       sep = ""),
        width = 600)
  }
  if (img.format == "pdf"){
    pdf(file <-  paste(directories$pdf.dir,
                       "/", outcome,
                       "_outliers.pdf",
                       sep = ""),
        width = 8)
  }
  plot(inf)
  dev.off()
  return(inf)
}

#' @title Plot a funnel plot for an outcome and perform Egger's regression test
#' @param pes.logit A Random effects model fitted using the DerSimonian and
#' Laird method  
#' @param outcome String. Name of outcome of interest. 
#' @param funnel.outcome Title to be used in the funnel plot used for diagnostic
#' bias. Default to \code{cases}.
#' @param directories List of directories created by \link{CreateDirectory}
#' @param img.format String. Format to save plots. Either "png" or "pdf" 
#' @return p-value from Egger's regression test
PlotFunnel <- function(pes.logit,
                       outcome,
                       funnel.outcome,
                       directories,
                       img.format){
  egger.pval <- round(regtest(pes.logit)$pval, 3) 
  if (egger.pval < 0.05){
    plot.col <- "red"
  }  else{
    plot.col <- "black"
  } 
  if (img.format == "png"){
  png(file <-  paste(directories$png.dir,
                     "/",
                     outcome,
                     "_funnel.png",
                     sep = ""),
      width = 600)
  }
  if (img.format == "pdf"){
    pdf(file <-  paste(directories$pdf.dir,
                       "/", outcome,
                       "_funnel.pdf",
                       sep = ""),
        width = 8)
  }

  funnel(pes.logit)
  if (is.null(funnel.outcome)) {
    title(main = paste("Funnel plot of", outcome))
  } else {
    title(main = paste("Funnel plot of", funnel.outcome))
  }
  legend("topright",
         paste("p =", egger.pval),
         bty="n",
         text.col = plot.col,
         cex = 1.2) 
  dev.off()
  
  egger.pval <- round(regtest(pes.logit)$pval, 3) 
  return(egger.pval)
}
  

#' @title Plot a forest plot of estimated proportions for an outcome
#' @param pes.summary Object created from \code{meta::metaprop}
#' @param outcome String. Name of outcome of interest. 
#' @param xlab String. Text to be displayed on the x axis of the forest plot
#' @param directories List of directories created by \link{CreateDirectory}
#' @param img.format String. Format to save plots. Either "png" or "pdf". 
#' @return p-value from Egger's regression test
PlotForest <- function(pes.summary, outcome, xlab, directories, img.format){
  # xlim larger than maximum CI value and a multiple of 0.2.
  xlim <- (max(ceiling(pes.summary$upper[is.na(pes.summary$upper) == F] / 0.2)) * 0.2) 
  
  if (img.format == "png"){
    png(file = paste(directories$png.dir, "/", outcome, ".png", sep = ""),
        width = 600)
  }
  if (img.format == "pdf"){
    pdf(file = paste(directories$pdf.dir, "/", outcome, ".pdf", sep = ""),
        width = 8)
  }
  
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
}

#' @title Perform suite of meta-analysis techniques
#' @description Performs random-effects (DerSimonian and Laird) meta-analysis 
#' with a logit transformation. Produces diagnostic plots for outlier detection
#' and publication bais. Heterogeneity statistics are also produced.    
#' @param cases Case number Column
#' @param total ni column
#' @param authorYear Column with author and year data
#' @param data Dataframe for all of the data extracted from the studies
#' @param xlab String. Text to be displayed on the x axis of the forest plot
#' @param funnel.outcome Title to be used in the funnel plot used for diagnostic
#' bias. Default to \code{cases}
#' @param dir Directory to save plots and tables.   
#' @return Dataframe with 1 row. tau2, I2, and estimates of proportions with 
#' upper and lower bounds for 95% confidence intervals. p-value from Eggers'
#' regression test
MetaAnalysis <- function(cases,
                         total,
                         authorYear,
                         data,
                         xlab,
                         funnel.outcome = NULL,
                         dir) {
  
  outcome <- deparse(substitute(cases)) #outcome name as string"
  
  directories <- CreateDirectory(outcome, dir)
  
  cases <- round(eval(substitute(cases), data, parent.frame()))
  non.NA <- is.na(cases) == FALSE
  cases <- cases[non.NA]
  total <- round(eval(substitute(total), data, parent.frame()))
  total <- total[non.NA]
  authorYear <- eval(substitute(authorYear), data, parent.frame())
  authorYear <- authorYear[non.NA]
  
  # Logit transfromation
  ies <- metafor::escalc(xi = cases, ni = total, measure = "PLO")
  # Random effects model fitted using the DerSimonian and Laird method
  pes.logit <- metafor::rma(yi, vi, data = ies, method = "DL")
  
  # Outliers
  inf <- PlotOutliers(pes.logit, outcome, directories,  img.format = "pdf")
  PlotOutliers(pes.logit, outcome, directories,  img.format = "png")
  
  # Funnel plot
  egger.pval <- PlotFunnel(pes.logit,
                           outcome,
                           funnel.outcome,
                           directories,
                           img.format = "pdf")
  PlotFunnel(pes.logit,
             outcome,
             funnel.outcome,
             directories,
             img.format = "png")
  
  values <- confint(pes.logit)$random
  tau2 <- matrix(values[1, ], nrow = 1) # tau^2 pred + CI values
  colnames(tau2) <- c("tau2", "tau2.lb", "tau2.up")
  
  I2 <- matrix(values[3, ], nrow = 1) # I^2 pred + CI values
  colnames(I2) <- c("I2", "I2.lb", "I2.up")
  
  # Add * to influential studies
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
  
  PlotForest(pes.summary, outcome, xlab, directories = directories,
             img.format = "pdf")
  PlotForest(pes.summary, outcome, xlab, directories = directories,
             img.format = "png")
  return(result)
}