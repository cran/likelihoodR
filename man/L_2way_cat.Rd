% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/L_2way_cat.R
\name{L_2way_cat}
\alias{L_2way_cat}
\title{Likelihood Support for Two-way Categorical Data}
\usage{
L_2way_cat(table, verb=TRUE)
}
\arguments{
\item{table}{a 2 x 2 matrix or contingency table containing counts.}

\item{verb}{show output, default = TRUE.}
}
\value{
$S.int - support for the interaction.

$df - the degrees of freedom for the interaction.

$S.int.unc - the uncorrected support for the interaction.

$S.Main.rows - support for the rows main effect.

$S.Main.cols - support for the columns main effect.

$S.Mr.uncorr - uncorrected support for rows main effect.

$S.Mc.uncorr - uncorrected support for the columns main effect.

$df.rows - degrees of freedom for rows.

$df.cols - degrees of freedom for columns.

$S.total - support for the whole table.

$S.trend - support for the trend across columns (if ordered).

$too.good - support for the variance being different from expected.

$observed - the observed table frequencies.

$expected - the expected values for null hypothesis of no interaction.

$residuals - the Pearson residuals.

$LR.test = the likelihood ratio test statistic.

$lrt.p - the p value for likelihood ratio test.

$chi.sq - chi-squared value.

$p.value - p value for chi-squared.

$trend.p - p value for trend (from chi-squared dist.).
}
\description{
This function calculates supports for two-way categorical data. This consists of the
support for the interaction and the two main effects. Support for the interaction
being closer or worse (different variance) than expected (Edwards p 187, Cahusac p 158)
is calculated. The support
for trend across the columns is given (assuming the levels for columns are ordered),
and conventional p value for trend.
Finally, Chi-squared and likelihood ratio test (G) statistics are given.
}
\examples{
# S. mansoni eggs in stools example, p 151
eggs <- as.table(rbind(c(14, 16, 14, 7, 6), c(87, 33, 66, 34, 11)))
dimnames(eggs) = list("Infested" = c("Positive","Negative"),
                  "Age Group" = c("0-","10-", "20-",
                  "30-", "40-"))
L_2way_cat(eggs)

# or as a matrix
eggs <- as.matrix(c(14, 87, 16, 33, 14, 66, 7, 34, 6, 11))
dim(eggs) <- c(2,5)
L_2way_cat(eggs)


}
\references{
Cahusac, P.M.B. (2020) Evidence-Based Statistics, Wiley, ISBN : 978-1119549802

Royall, R. M. (1997). Statistical evidence: A likelihood paradigm. London: Chapman & Hall, ISBN : 978-0412044113

Edwards, A.W.F. (1992) Likelihood, Johns Hopkins Press, ISBN : 978-0801844430
}
\keyword{2-way}
\keyword{Likelihood-based;}
\keyword{contingency}
\keyword{table}
