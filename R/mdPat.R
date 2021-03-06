##mdPat.r
##2009-11-16 dmontaner@cipf.es
##2013-03-27 dmontaner@cipf.es


##' @name mdPat
## @docType 
##' @author David Montaner \email{dmontaner@@cipf.es}
##' 
## @aliases 
##' 
##' @keywords multidimensional multivariate GSA pattern
##' @seealso \code{\link{mdGsa}}, \code{\link{uvPat}}
##'
##' @title Multi-Dimensional Gene Set Analysis Pattern Classification.
##' 
##' @description
##' Classifies significant patterns form a Multi-Variate Gene Set Analysis.
##' 
##' @details
##' Sign of the three 'lor' and p-values are used to classify functional blocks.
##' The classification is done in the two dimensional space previously analyzed
##' by mdGsa.
##'
##' All possible functional block classifications in the bi-dimensional
##' gene set analysis are:
##' \itemize{
##'   \item q1i: block displaced toward quadrant \bold{1} (0 < X & 0 < Y) with interaction.
##'   \item q2i: block displaced toward quadrant \bold{2} (0 > X & 0 < Y) with interaction.
##'   \item q3i: block displaced toward quadrant \bold{3} (0 > X & 0 > Y) with interaction.
##'   \item q4i: block displaced toward quadrant \bold{4} (0 < X & 0 > Y) with interaction.
##'   \item q1f: block displaced toward quadrant \bold{1}, no interaction. 
##'   \item q2f: block displaced toward quadrant \bold{2}, no interaction. 
##'   \item q3f: block displaced toward quadrant \bold{3}, no interaction. 
##'   \item q4f: block displaced toward quadrant \bold{4}, no interaction. 
##'   \item xh: block shifted to \bold{positive X} values.
##'   \item xl: block shifted to \bold{negative X} values. 
##'   \item yh: block shifted to \bold{positive Y} values.
##'   \item yl: block shifted to \bold{negative Y} values.
##'   \item b13: bimodal block. Half of the genes displaced towards quadrant \bold{1} and the other half towards quadrant \bold{3}.
##'   \item b24: bimodal block. Half of the genes displaced towards quadrant \bold{2} and the other half towards quadrant \bold{4}.
##'   \item NS: \bold{non significant} block.
##' }
##' 
##' @param gsaout data.frame; output from mdGsa.
##' @param cutoff p-value cutoff for considering significant a Gene Set.
##' @param pvalue p-value column to be used. Default is named "padj" as in
##' mdGsa output.
##' 
##' @return A character vector indicating the pattern associated to each
##' Gene Set.
##' 
##' @references
##' Montaner et al. (2010)
##' "Multidimensional Gene Set Analysis of Genomic Data."
##' PLoS ONE.
##'
##' @examples
##' N <- c (10, 20, 30, 40)
##' lor.X <- c (1.45, -0.32, 1.89, -1.66)
##' lor.Y <- c (2.36, -1.86, 0.43, -2.01)
##' lor.I <- c (0.89, -0.12, 0.24,  3.55)
##' pval.X <- c (0.001, 0.002, 0.003, 0.06)
##' pval.Y <- c (0.002, 0.003, 0.06,  0.07)
##' pval.I <- c (0.003, 0.02,  0.05,  0.08)
##' padj.X <- p.adjust (pval.X, "BY")
##' padj.Y <- p.adjust (pval.Y, "BY")
##' padj.I <- p.adjust (pval.I, "BY")
##'
##' mdGsa.res <- as.data.frame (cbind (N,
##'                                    lor.X, lor.Y, lor.I,
##'                                    pval.X, pval.Y, pval.I,
##'                                    padj.X, padj.Y, padj.I))
##' mdGsa.res
##' 
##' mdGsa.res[,"pat"] <- mdPat (mdGsa.res)
##' mdGsa.res
##' 
##' @export
mdPat <- function (gsaout, cutoff = 0.05, pvalue = "padj") {
    
    ## ##mdGsa Patterns
    ## patron <- c ( 1,  1,  1, "q1i",
    ##               1,  0,  1, "q1i",
    ##               0,  1,  1, "q1i",
    ##              -1, -1,  1, "q3i",
    ##              -1,  0,  1, "q3i",
    ##               0, -1,  1, "q3i",
    ##              -1,  1, -1, "q2i",
    ##              -1,  0, -1, "q2i",
    ##               0,  1, -1, "q2i",
    ##               1, -1, -1, "q4i",
    ##               1,  0, -1, "q4i",
    ##               0, -1, -1, "q4i",
    ##               0,  0,  1, "b13",
    ##               0,  0, -1, "b24", #corrected from the paper
    ##               1,  1,  0, "q1f",
    ##              -1, -1,  0, "q3f",
    ##              -1,  1,  0, "q2f",
    ##               1, -1,  0, "q4f",
    ##               1,  0,  0, "xh",
    ##              -1,  0,  0, "xl",
    ##               0,  1,  0, "yh",
    ##               0, -1,  0, "yl",
    ##               0,  0,  0, "NS",
    ##               1,  1, -1, "q1f", #not in the paper
    ##              -1, -1, -1, "q3f", #not in the paper
    ##              -1,  1,  1, "q2f", #not in the paper
    ##               1, -1,  1, "q4f") #not in the paper
    ## patron <- matrix (patron, ncol = 4, byrow = TRUE)
    ## colnames (patron) <- c ("alpha", "beta", "gamma", "pattern")
    ## colnames (patron) <- c (  "X"  ,  "Y"  ,   "I"  , "pattern")
    
    patFile <- system.file (package = "mdgsa", "extdata","mdGsaPatterns.txt")
    patron <- read.table (patFile, header = TRUE, colClasses = "character")
    
    mdGsaPattern <- patron[,"pattern"]
    mdGsaPattern.name <- apply (patron[,c ("X", "Y", "I")], 1, paste, collapse = "") 
    names (mdGsaPattern) <- mdGsaPattern.name
    
    
    ##COLUMNS
    lors <- sub ("lor", "", grep ("lor.", colnames (gsaout), value = TRUE))
    pvals <- sub (pvalue, "",
                  grep (paste (pvalue, ".", sep = ""),
                        colnames (gsaout), value = TRUE))
    
    tags <- intersect (lors, pvals)
    
    if (length (tags) != 3) {
        stop ("lor and pvalue columns could not be matched")
    } else {
        lors <- paste ("lor", tags, sep = "")
        pvals <- paste (pvalue, tags, sep = "")
    }
    
    ## Log Odds Ratio sign * {1, 0} for significant and no significant
    significance <- sign (gsaout[,lors]) * as.numeric (gsaout[,pvals] < cutoff)
    colnames (significance) <- c("alpha", "beta", "gamma")
    
    
    ##pattern assignment
    significance.id <- apply (significance, 1, paste, collapse = "") 
    res <- mdGsaPattern[significance.id]
    names (res) <- rownames (significance)
    
    ##non relevant patterns
    res[is.na (res)] <- "NR"  #CHECK THIS
    
    ## OUTPUT
    res
}
