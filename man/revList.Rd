% Generated by roxygen2 (4.0.2): do not edit by hand
\name{revList}
\alias{revList}
\title{Revert an annotation list.}
\usage{
revList(lis, tag = "listPos")
}
\arguments{
\item{lis}{annotation list.}

\item{tag}{substitutes missing list names if any.}
}
\value{
An inverted list.
}
\description{
Inverts a list: names to elements / elements to names
}
\examples{
lis <- list (Block1 = c("gen1", "gen2"), Block2 = c("gen1", "gen3"))
revList (lis)
}
\author{
David Montaner \email{dmontaner@cipf.es}
}
\seealso{
\code{\link{annotMat2list}}, \code{\link{revList}}
annotMat2list, annotList2mat
}
\keyword{annotation}
\keyword{list}
\keyword{revert}

