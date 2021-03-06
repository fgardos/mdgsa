% Generated by roxygen2 (4.0.2): do not edit by hand
\name{annotList2mat}
\alias{annotList2mat}
\title{Convert an annotation list into an annotation matrix.}
\usage{
annotList2mat(lis, tag = "listPos")
}
\arguments{
\item{lis}{annotation list.}

\item{tag}{substitutes missing list names if any.}
}
\value{
An annotation matrix: the first column contains the gene or
feature ids,
the second column contains the Gene Set or functional block ids.
}
\description{
Converts an annotation list to an annotation matrix.
The annotation matrix should have 2 columns, the first one with the
gene ids;
the second one with the annotation ids.
}
\details{
Each element of the annotation list represents a functional block;
it is a character vector containing the gene ids annotated under
the function.
The names of the list are the annotation ids.
}
\examples{
lis <- list (Block1 = c("gen1", "gen2"), Block2 = c("gen3"))
annotList2mat (lis)
}
\author{
David Montaner \email{dmontaner@cipf.es}
}
\seealso{
\code{\link{annotMat2list}}, \code{\link{revList}}, \code{split}
}
\keyword{annotation}
\keyword{list}
\keyword{matrix}

