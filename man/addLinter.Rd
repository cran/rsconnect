% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lint-framework.R, R/linters.R
\name{addLinter}
\alias{addLinter}
\title{Add a Linter}
\usage{
addLinter(name, linter)

addLinter(name, linter)
}
\arguments{
\item{name}{The name of the linter, as a string.}

\item{linter}{A \code{\link[=linter]{linter()}}.}
}
\description{
Add a linter, to be used in subsequent calls to \code{\link[=lint]{lint()}}.

Add a linter, to be used in subsequent calls to \code{\link[=lint]{lint()}}.
}
\examples{
addLinter("no.capitals", linter(

  ## Identify lines containing capital letters -- either by name or by index
  apply = function(content, ...) {
    grep("[A-Z]", content)
  },

  ## Only use this linter on R files (paths ending with .r or .R)
  takes = function(paths) {
    grep("[rR]$", paths)
  },

  # Use the default message constructor
  message = function(content, lines, ...) {
    makeLinterMessage("Capital letters found on the following lines", content, lines)
  },

  # Give a suggested prescription
  suggest = "Do not use capital letters in these documents."
))
addLinter("no.capitals", linter(

  ## Identify lines containing capital letters -- either by name or by index
  apply = function(content, ...) {
    grep("[A-Z]", content)
  },

  ## Only use this linter on R files (paths ending with .r or .R)
  takes = function(paths) {
    grep("[rR]$", paths)
  },

  # Use the default message constructor
  message = function(content, lines, ...) {
    makeLinterMessage("Capital letters found on the following lines", content, lines)
  },

  # Give a suggested prescription
  suggest = "Do not use capital letters in these documents."
))
}
