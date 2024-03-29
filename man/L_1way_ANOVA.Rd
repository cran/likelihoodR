% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/L_1way_ANOVA.R
\name{L_1way_ANOVA}
\alias{L_1way_ANOVA}
\title{Likelihood Supports for One-way Independent Samples ANOVA}
\usage{
L_1way_ANOVA(data, group, contrast1=NULL, contrast2=NULL, verb=TRUE)
}
\arguments{
\item{data}{a (non-empty) numeric vector of data values.}

\item{group}{an integer vector the same length as data, coding for k groups.}

\item{contrast1}{first contrast, default = NULL.}

\item{contrast2}{second contrast, default = NULL.}

\item{verb}{show output, default = TRUE.}
}
\value{
$S.12c - corrected support for groups hypothesis versus null.

$S.12 - uncorrected support for groups hypothesis versus null.

S.1mc - support for contrast 1 versus the group means model.

$S.1m = uncorrected support for contrast 1 vs group means.

$S.cont.12 - support for contrast 1 versus contrast 2.

$contrast1 - first contrast.

$contrast2 - second contrast.

$gp.means - group means.

$df - degrees of freedom for groups and error.

$F.val - F value for overall ANOVA analysis.

$P.val - p value for overall analysis.

$eta.sq - eta-squared.

$Fval.c1 - F value for contrast 1.

$df.1 - degrees of freedom for contrast.

$P.val1 - p value for contrast 1.
}
\description{
This function calculates supports for independent samples ANOVA. One support is
for the model of group means against the null (no grouping), for the first contrast
versus the group means model, and the other for 2 contrasts.
Both contrasts should be either NULL or specified.
If the contrasts use the default of NULL, then it calculates a linear versus a
quadratic contrast. The corrected support is given for groups versus null, using
Akaike's correction (Hurvich & Tsai (1989)). No correction is necessary for the
two contrasts' support since they both involve 1 parameter.
Conventional frequentist F and p value statistics are given for the overall
analysis and for contrast 1. Unequal group sizes are
accommodated.
}
\examples{
# fitness example, p 81
dat <- c(7,	5,	9,	8,	3,	12,	10,	8,	7,	9,
5,	7,	7,	6,	4,	8,	12,	9,	7,	8,
3,	2,	7,	6,	8,	6,	5,	3,	4,	3,
4,	3,	3,	1,	2,	5,	7,	6,	8,	7)
gp <- as.factor(rep(1:4,each=10))
gp = gl(4,10,40, labels=c("6 hr",	"3 hr",	"Sports club",	"Video games"))
contrast1 <- c(-3, -1, 1, 3)  # linear
contrast2 <- c(1, -1, -1, 1)  # quadratic
contrast3 <- c(1, 1, -1, -1)
L_1way_ANOVA(dat,gp,contrast3, contrast1)

}
\references{
Cahusac, P.M.B. (2020) Evidence-Based Statistics, Wiley, ISBN : 978-1119549802

Hurvich CM, Tsai C-L. Regression and time series model selection in small
samples. Biometrika. 1989; 76(2):297.

Dixon P. The effective number of parameters in post hoc models. Behavior
Research Methods. 2013; 45(3):604.

Dixon P. The p-value fallacy and how to avoid it. Canadian Journal of
Experimental Psychology/Revue canadienne de psychologie expérimentale. 2003;
57(3):189.

Glover S, Dixon P. Likelihood ratios: a simple and flexible statistic for empirical
psychologists. Psychonomic Bulletin and Review. 2004; 11(5):791.
}
\keyword{ANOVA;}
\keyword{Likelihood;}
\keyword{contrasts}
\keyword{independent}
\keyword{samples}
\keyword{support;}
