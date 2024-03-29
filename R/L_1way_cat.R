#' Likelihood Support for One-way Categorical Data
#'
#' This function calculates the support for one-way categorical data (multinomial), also
#' gives chi-squared and likelihood ratio test (G) statistics. If there are only 2
#' categories then binomial information
#' is given too with likelihood interval, including the likelihood-based % confidence
#' interval. Support for the variance being more different than expected (Edwards p 187,
#' Cahusac p 158) is also calculated.
#' It uses the optimize function to locate desired limits for both intervals.
#'
#' @usage L_1way_cat(obs, exp.p=NULL, L.int=2, alpha=0.05, toler=0.0001,
#' logplot=FALSE, supplot=-10, verb=TRUE)
#' @param obs a vector containing the number of counts in each category.
#' @param exp.p a vector containing expected probabilities. If NULL then this is 1/#cats.
#' @param L.int likelihood interval given as support values, e.g. 2 or 3, default = 2.
#' @param alpha the significance level used, 1 - alpha interval calculated, default = 0.05.
#' @param toler the desired accuracy using optimise, default = 0.0001.
#' @param logplot plot vertical axis as log likelihood, default = FALSE
#' @param supplot set minimum likelihood display value in plot, default = -10
#' @param verb show output, default = TRUE.
#'
#' @return
#' $S.val - support for one-way observed versus expected.
#'
#' $uncorrected.sup - uncorrected support.
#'
#' $df - degrees of freedom for table.
#'
#' $observed - observed counts.
#'
#' $exp.p - expected probabilities.
#'
#' $too.good - support for the variance of counts being more different than expected.
#'
#' $chi.sq - chi-squared value.
#'
#' $p.value - p value for chi-squared.
#'
#' $LR.test = the likelihood ratio test statistic.
#'
#' $lrt.p = the p value for the likelihood ratio test statistic
#'
#' Additional outputs for binomial:
#'
#' $prob.val - MLE probability from data.
#'
#' $succ.fail - number of successes and failures.
#'
#' $like.int - likelihood interval.
#'
#' $like.int.spec - specified likelihood interval in units of support.
#'
#' $conf.int - likelihood-based confidence interval.
#'
#' $alpha.spec - specified alpha for confidence interval.
#'
#' $err.acc - error accuracy for optimize function.
#'
#' @keywords Likelihood-based; binomial; confidence interval
#' @export
#'
#' @importFrom graphics curve
#' @importFrom graphics lines
#' @importFrom graphics segments
#' @importFrom stats chisq.test
#' @importFrom stats qchisq
#' @importFrom stats optimize
#'
#' @examples # example for binomial, p 123
#' obs <- c(6,4)
#' L_1way_cat(obs, L.int=2, toler=0.0001, logplot=FALSE, supplot=-10, verb = TRUE)
#'
#' # example for multinomial, p 134
#' obs <- c(60,40,100)
#' exp <- c(0.25,0.25,0.5)
#' L_1way_cat(obs, exp.p=exp, L.int=2, toler=0.0001, logplot=FALSE, supplot=-10,
#' verb = TRUE)
#'
#' @references Aitkin, M. et al (1989) Statistical Modelling in GLIM, Clarendon Press, ISBN : 978-0198522041
#'
#' Cahusac, P.M.B. (2020) Evidence-Based Statistics, Wiley, ISBN : 978-1119549802
#'
#' Royall, R. M. (1997). Statistical evidence: A likelihood paradigm. London: Chapman & Hall, ISBN : 978-0412044113
#'
#' Edwards, A.W.F. (1992) Likelihood, Johns Hopkins Press, ISBN : 978-0801844430

L_1way_cat <- function(obs, exp.p=NULL, L.int=2, alpha=0.05, toler=0.0001, logplot=FALSE, supplot=-10, verb=TRUE) {
    len <- length(obs)
    n <- sum(obs)
    if (!is.null(exp.p)) {
      if (sum(exp.p)!=1) stop("Error: expected probabilities must sum to 1")
    }
    if (is.null(exp.p)) {        # assign expected probabilities equally if not specified
      exp.p <- rep(1/len,each=len)
    }
    exp <- exp.p*n
    try(if(len < 2) stop("Error: Must have more than one category with counts"))  # trap errors
    for (i in 1:len) {
      if(is.na(obs[i])) stop("Error: Must not have categories with NA")
      if(is.nan(obs[i])) stop("Error: Must not have categories with NaN")
      if(is.na(exp[i])) stop("Error: Must not have NA for expected")
      if(is.nan(exp[i])) stop("Error: Must not have NaN for expected")
      try(if(obs[i] < 0) stop("Error: Must not have categories with negative counts"))
      try(if(exp[i]<=0) stop("Error: Must not have expected values that are zero or negative"))
      try(if(len == 2 && obs[i] == 0) stop("Error: Both categories must have counts > 0"))
    }

    count1 <- obs               # removing zero counts for support calculations
    for (i in 1:length(count1)) {
      count1[i] <- obs[i]
      if (obs[i] < 1) count1[i]=1   # turn 0s into 1s for one table used for log
    }

  Sup <- sum(obs*(log(count1)-log(exp)))
  df <- (length(obs)-1)
  Supc<- Sup-(df-1)/2 # corrected for df
  suppressWarnings(mc <- chisq.test(obs,p=exp.p,rescale.p = TRUE)) # suppress warnings
  p.value <- mc$p.value
  chi.s  <- unname(mc$statistic)
  lrt <- 2*Sup  # likelihood ratio statistic
  LRt_p <- 1-pchisq(lrt,df)
  toogood <- df/2*(log(df/chi.s)) - (df - chi.s)/2
  if (len!=2) {
    if(verb) cat("\nSupport for difference from expected, corrected for ", df, " df = ",  round(Supc,3), sep= "",
      "\n Support for variance differing more than expected = ",
      round(toogood,3), "\n\n Chi-square(", df, ") = ", chi.s,
      ",  p = ", format.pval(p.value,4),
      "\n Likelihood ratio test G(", df, ") = ", round(lrt,3),
    ", p = ", format.pval(LRt_p,4), ", N = ", n, "\n ")
  return(invisible(list(S.val = Supc, uncorrected.sup = Sup, df = df,
              observed = obs, exp.p = exp.p, too.good = toogood,
              chi.sq = chi.s, p.value = p.value)))
  }
# for binomial
  a <- obs[1]; r <- obs[2]
  p = a/n

# likelihood-based % confidence interval
  x=0

  f <- function(x,a,r,p,goal) (a*log(x)+r*log(1-x)-(a*log(p)+r*log(1-p))-goal)^2

  goal = -qchisq(1-alpha,1)/2
  xmin1 <- optimize(f, c(0, p), tol = toler, a, r, p, goal)
  xmin2 <- optimize(f, c(p, 1), tol = toler, a, r, p, goal)

# same for likelihood
  goal <- -L.int
  xmin1L <- optimize(f, c(0, p), tol = toler, a, r, p, goal)
  xmin2L <- optimize(f, c(p, 1), tol = toler, a, r, p, goal)

# to determine x axis space for plot
  goalx <- supplot    # with e^-10 we get x values for when curve is down to 0.00004539
  xmin1x <- optimize(f, c(0, p), tol = toler, a, r, p, goalx)
  xmin2x <- optimize(f, c(p, 1), tol = toler, a, r, p, goalx)
  lolim <- xmin1x$minimum
  hilim <- xmin2x$minimum

  if(isFALSE(logplot)) {
  curve((x^a*(1-x)^r)/(p^a*(1-p)^r), from = 0, to = 1, xlim = c(lolim,hilim), xlab = "Probability", ylab = "Likelihood")
  lines(c(p,p),c(0,1),lty=2) # add MLE as dashed line
  lines(c(exp.p[1],exp.p[1]),c(0,(exp.p[1]^a*(1-exp.p[1])^r)/(p^a*(1-p)^r)),
                                lty=1, col = "blue") # add H prob as blue line
  segments(xmin1L$minimum, exp(goal), xmin2L$minimum, exp(goal), lwd = 0.2, col = "red")
  } else {
    curve(log((x^a*(1-x)^r)/(p^a*(1-p)^r)), from = 0, to = 1, xlim = c(lolim,hilim), xlab = "Probability",
          ylim = c(supplot,0), ylab = "Log Likelihood")
    lines(c(p,p),c(supplot,0),lty=2) # add MLE as dashed line
    lines(c(exp.p[1],exp.p[1]),c(supplot,log((exp.p[1]^a*(1-exp.p[1])^r)/(p^a*(1-p)^r))),
          lty=1, col = "blue") # add H prob as blue line
    segments(xmin1L$minimum, goal, xmin2L$minimum, goal, lwd = 0.2, col = "red")
  }

    if(verb) cat("\nBinomial support for difference of MLE ", p, " (dashed line) \n from ", exp.p[1],
      " (blue line) with ", df, " df = ", round(Sup,3), sep= "",
      "\n Support for variance differing more than expected = ", round(toogood,3),
      "\n\n S-", L.int," likelihood interval (red line) from ",
      c(round(xmin1L$minimum,5), " to ", round(xmin2L$minimum,5)),
      "\n\nChi-square(", df, ") = ", round(chi.s,3), ",  p = ", format.pval(p.value,4),
      "\n Likelihood ratio test G(", df, ") = ", round(lrt,3),
      ", p = ", format.pval(LRt_p,4),", N = ", n,
      "\n Likelihood-based ", 100*(1-alpha), "% confidence interval from ",
      c(round(xmin1$minimum,5), " to ", round(xmin2$minimum,5)), "\n ")
  invisible(list(S.val = Sup, uncorrected.sup = Sup, df = df, prob.val = p,
                 succ.fail = c(a,r), exp.p = exp.p,
                 like.int = c(xmin1L$minimum, xmin2L$minimum), like.int.spec = L.int,
                 too.good = toogood,
                 chi.sq = chi.s, p.value = p.value, LR.test = lrt, lrt.p = LRt_p,
                 conf.int = c(xmin1$minimum, xmin2$minimum), alpha.spec = alpha,
                 err.acc = c(xmin1$objective, xmin2$objective)))
}
