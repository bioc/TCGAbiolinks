% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{getNbFiles}
\alias{getNbFiles}
\title{Get Number of files in GDC for a project}
\usage{
getNbFiles(project, data.category)
}
\arguments{
\item{project}{A  GDC project}

\item{data.category}{A  GDC project data category}
}
\description{
Get Number of files in GDC for a project
}
\examples{
\dontrun{
getNbFiles("TCGA-ACC","Clinical")
getNbFiles("CPTAC-2","Clinical")
}
}
\author{
Tiago Chedraoui Silva
}
