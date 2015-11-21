\name{hrafsuicidedata-package}
\alias{hrafsuicidedata-package}
\alias{hrafsuicidedata}
\docType{package}
\title{
Coding of HRAF Probability Sample suicide extracts
}
\description{
All paragraphs on suicide in the HRAF Probability Sample were retrieved and coded on 23
variables derived from the inclusive fitness model and bargaining model of suicidal behavior.
}
\details{
\tabular{ll}{
Package: \tab hrafsuicidedata\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2015-05-02\cr
License: \tab CC BY\cr
}
Contains 3 data frames:

coding: Coding of suicide records

cultures: Data on the cultures in the PS with paragraphs describing suicidal behavior.

cdc: rate of suicide attempts and completions in the US, 2001-2011.
}
\author{
Kristen Syme, Zachary Garfield and Ed Hagen

Maintainer: Ed Hagen <ehagen@gmail.com>

}
\references{
Syme K, Hagen EH and Garfield Z. Testing the bargaining vs. inclusive fitness models of suicidal behavior against the ethnographic record. \link{http://dx.doi.org/10.1016/j.evolhumbehav.2015.10.005}
}
\keyword{ package }
\seealso{
\code{\link{coding}}, \code{\link{cultures}}, \code{\link{cdc}}
}
\examples{
data(coding)
data(cultures)
data(cdc)
}
