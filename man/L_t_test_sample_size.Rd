% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/L_t_test_sample_size.R
\name{L_t_test_sample_size}
\alias{L_t_test_sample_size}
\title{Sample size calculation using the evidential approach for t tests}
\usage{
L_t_test_sample_size(MW = 0.05, sd = 1, d = 1.2, S = 3, paired = FALSE, verb=TRUE)
}
\arguments{
\item{MW}{set M1 + W1 probability, default = .05.}

\item{sd}{set standard deviation, default = 1.}

\item{d}{set desired effect size, default = 1.2.}

\item{S}{set strength of evidence (support), default = 3.}

\item{paired}{set to TRUE for one sample and FALSE for independent samples, default = FALSE.}

\item{verb}{show output, default = TRUE.}
}
\value{
$N - required sample size.

$S - specified strength (support) for evidence from the test.

$sd - specified standard deviation.

$d - Cohen's effect size specified.

$m1.w1 - specified probability for combined misleading and weak evidence.
}
\description{
This function calculates
the required sample size for t tests. The standard deviation and effect size are
specified. Calculations given for one sample and independent samples t tests. For a related
samples test calculation use the sd for paired differences.
}
\examples{
# for one sample or related samples (differences)
v = L_t_test_sample_size(MW = 0.2, sd = 1, d = 1, S = 3, paired = TRUE)
v
# for 2 independent samples
v = L_t_test_sample_size(MW = 0.05, sd = 1, d = 1.2, S = 3, paired = FALSE)
v

}
\references{
Cahusac, P.M.B. (2020) Evidence-Based Statistics, Wiley, ISBN : 978-1119549802

Cahusac, P.M.B. & Mansour, S.E. (2022) Estimating sample sizes for evidential t tests, Research in Mathematics, 9(1):1-12
https://doi.org/10.1080/27684830.2022.2089373

Royall, R. (2000). "On the Probability of Observing Misleading Statistical Evidence." Journal of the
American Statistical Association 95(451): 760.

Royall, R. (2004). The Likelihood paradigm for statistical evidence. The Nature of Scientific Evidence.
M. L. Taper and S. R. Lele. Chicago, University of Chicago: 119.

Royall, R. M. (1997). Statistical evidence: A likelihood paradigm. London: Chapman & Hall, ISBN : 978-0412044113

Edwards, A.W.F. (1992) Likelihood, Johns Hopkins Press, ISBN : 978-0801844430
}
\keyword{Likelihood;}
\keyword{evidence}
\keyword{evidence;}
\keyword{misleading}
\keyword{sample}
\keyword{size;}
\keyword{t}
\keyword{test;}
\keyword{weak}
