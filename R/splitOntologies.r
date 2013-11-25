##splitOnotologies.r
##2013-04-07 dmontaner@cipf.es


##' @name splitOntologies
## @docType 
##' @author David Montaner \email{dmontaner@@cipf.es}
##' 
## @aliases 
##' 
##' @keywords split GO ontology
##' @seealso \code{\link{propagateGO}}, \code{\link{goLeaves}}
##'
##' @title Split an annotation list of GO terms by ontologies.
##'
##' @description
##' Splits an annotation list of GO terms according to the ontology to which each term belongs to.
##' 
##' @details
##' Uses the information form the library GO.db.
##' If some id could not be associated to any ontology, they are returned in an unknown ontology
##' named "missing".
##'
##' @param annot annotation list.
##' @param na.rm if TRUE 'unknown' terms are excluded.
##' @param verbose verbose
##' 
##' @return A list with tree components, one for each ontology.
##' A fourth component is included is some term could not be allocated to any of the three GO ontologies.
##' 
##' @import DBI
##' @import GO.db
##'
##' @export

splitOntologies <- function (annot, na.rm = FALSE, verbose = TRUE) {

  if (verbose) {
    message ("\n", "Using GO.db version: ", packageDescription ("GO.db", fields = "Version")) #2.3.5
  }

  ##go id to ontology
  micon <- GO_dbconn ()
  tabla <- dbReadTable (micon, "go_term")
  tabla <- tabla[,c("go_id", "ontology")]
  tabla <- tabla[tabla$go_id != "all",]
  
  go2ontology <- tabla[,"ontology"]
  names (go2ontology) <- tabla[,"go_id"]

  ##my go ids
  misgos <- names (annot)
  ##
  ontologia <- go2ontology[misgos]
  ontologia[is.na (ontologia)] <- "missing"
  table (ontologia, exclude = NULL)
  
  es.bp <- ontologia == "BP"
  es.cc <- ontologia == "CC"
  es.mf <- ontologia == "MF"
  es.na <- ontologia == "missing"
  
  res <- list ()
  res[["BP"]] <- annot[es.bp]
  res[["CC"]] <- annot[es.cc]
  res[["MF"]] <- annot[es.mf]
  
  if (sum (es.na) > 0) {
    cat ("Some GO ids where not found, ", fill = FALSE)
    if (na.rm) {
      cat ("they will be excluded from the list", fill = TRUE)
    } else {
      cat ("they are included in the fourth element of the output list.", fill = TRUE)
      res[["missing"]] <- annot[es.na]
    }
  }

  return (res)
}
