% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lucC_allen_relations.r
\docType{data}
\name{lucC_relation_meets}
\alias{lucC_relation_meets}
\title{Allen Relation Meets}
\usage{
lucC_relation_meets(first_interval , second_interval)
}
\arguments{
\item{first_interval}{lucC_interval. An interval between two dates.}

\item{second_interval}{lucC_interval. An interval between two dates.}
}
\value{
Logical value if interval are TRUE or FALSE
}
\description{
Provide an Allen's interval relation to classified time series data. And return a logical value if an interval is TRUE or FALSE
}
\examples{
\dontrun{

library(lucC)

lucC_starting_point()

# create some examples of intervals
time1 <- lucC_interval("2011-09-01","2011-10-01")
time3 <- lucC_interval("2011-10-01","2011-11-01")

# Apply a relation 'meets' (end_I == start_J)
lucC_relation_meets(time1,time3)

}

}
\author{
Adeline M. Maciel
}
\keyword{datasets}
