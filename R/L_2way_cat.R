#' Likelihood Support for Two-way Categorical Data
#'
#' This function calculates supports for two-way categorical data. This consists of the
#' support for the interaction and the two main effects. Support for the interaction
#' being closer or worse (different variance) than expected (Edwards p 187, Cahusac p 158)
#' is calculated. The support
#' for trend across the columns is given (assuming the levels for columns are ordered),
#' and conventional p value for trend.
#' Finally, Chi-squared and likelihood ratio test (G) statistics are given.
#'
#' @usage L_2way_cat(table, verb=TRUE)
#'
#' @param table a 2 x 2 matrix or contingency table containing counts.
#' @param verb show output, default = TRUE.
#'
#' @return
#' $S.int - support for the interaction.
#'
#' $df - the degrees of freedom for the interaction.
#'
#' $S.int.unc - the uncorrected support for the interaction.
#'
#' $S.Main.rows - support for the rows main effect.
#'
#' $S.Main.cols - support for the columns main effect.
#'
#' $S.Mr.uncorr - uncorrected support for rows main effect.
#'
#' $S.Mc.uncorr - uncorrected support for the columns main effect.
#'
#' $df.rows - degrees of freedom for rows.
#'
#' $df.cols - degrees of freedom for columns.
#'
#' $S.total - support for the whole table.
#'
#' $S.trend - support for the trend across columns (if ordered).
#'
#' $too.good - support for the variance being different from expected.
#'
#' $observed - the observed table frequencies.
#'
#' $expected - the expected values for null hypothesis of no interaction.
#'
#' $residuals - the Pearson residuals.
#'
#' $LR.test = the likelihood ratio test statistic.
#'
#' $lrt.p - the p value for likelihood ratio test.
#'
#' $chi.sq - chi-squared value.
#'
#' $p.value - p value for chi-squared.
#'
#' $trend.p - p value for trend (from chi-squared dist.).
#'
#' @keywords Likelihood-based; 2-way contingency table
#'
#' @export
#'
#' @importFrom stats prop.trend.test
#' @importFrom stats chisq.test
#'
#' @examples # S. mansoni eggs in stools example, p 151
#' eggs <- as.table(rbind(c(14, 16, 14, 7, 6), c(87, 33, 66, 34, 11)))
#' dimnames(eggs) = list("Infested" = c("Positive","Negative"),
#'                   "Age Group" = c("0-","10-", "20-",
#'                   "30-", "40-"))
#' L_2way_cat(eggs)
#'
#' # or as a matrix
#' eggs <- as.matrix(c(14, 87, 16, 33, 14, 66, 7, 34, 6, 11))
#' dim(eggs) <- c(2,5)
#' L_2way_cat(eggs)
#'
#'
#' @references
#'
#' Cahusac, P.M.B. (2020) Evidence-Based Statistics, Wiley, ISBN : 978-1119549802
#'
#' Royall, R. M. (1997). Statistical evidence: A likelihood paradigm. London: Chapman & Hall, ISBN : 978-0412044113
#'
#' Edwards, A.W.F. (1992) Likelihood, Johns Hopkins Press, ISBN : 978-0801844430


L_2way_cat <- function(table, verb=TRUE) {

# check table is at least 2 x 2
  if (nrow(table) < 2)
    stop("Error: fewer than 2 rows")
  if (ncol(table) < 2)
    stop("Error: fewer than 2 columns")

# calculating the interaction
  S2way <- 0

  suppressWarnings(lt <- chisq.test(table, correct=FALSE)) # ignore warning message

  tabt1=lt$observed
  for (i in 1:length(table)) {
    tabt1[i] <- lt$observed[i]
    if (lt$observed[i] < 1) tabt1[i]=1   # turn 0s into 1s for one table used for log
  }

  S2way <- sum(lt$observed * log(tabt1/lt$expected))

  df <- unname(lt$parameter)
  S2wayc <- S2way - (df-1)/2

# main marginal totals

  row_sum <- rowSums(table)
  for (i in 1:length(row_sum)) {
    if (row_sum[i] < 1) stop("Error: marginal totals cannot be 0")
  }

  col_sum <- colSums(table)
  for (i in 1:length(col_sum)) {
    if (col_sum[i] < 1) stop("Error: marginal totals cannot be 0")
  }

  grandtot <- sum(table)
  RowMain <- sum(row_sum*log(row_sum))-grandtot*log(grandtot) + grandtot*log(length(row_sum))
  RowMain_c <- RowMain - ((length(row_sum)-1)-1)/2 # corrected for row df

  ColMain <- sum(col_sum*log(col_sum))-grandtot*log(grandtot) + grandtot*log(length(col_sum))
  ColMain_c <- ColMain - ((length(col_sum)-1)-1)/2 # corrected for column df

# Total S
  Tot_S <- sum(lt$observed*log(tabt1))-sum(lt$observed)*log(sum(lt$observed)/length(table))

# same as components added together (without correction for df)
# S2way + RowMain + ColMain

  chi.s <- unname(lt$statistic)
  toogood <- df/2*(log(df/chi.s)) - (df - chi.s)/2

# likelihood ratio test
  lrt <- 2*S2way
  LRt_p <- 1-pchisq(lrt,df)

# evidence for trend
  trX <- NULL
  tr <- NULL
  trX$p.value <- NULL
  if (length(col_sum)>=3) {
    table.pos <- table[1:length(col_sum)]
    trX <- prop.trend.test(table[1,], col_sum)
    tr <- unname(trX$statistic)/2      # S for trend
  }
  if(verb) {
    print(table)
    cat("\nSupport for interaction corrected for ", df, " df = ", round(S2wayc,3), sep= "",
    "\n Support for rows main effect corrected for ",
    length(row_sum)-1, " df = ", round(RowMain_c,3),
    "\n Support for columns main effect corrected for ", length(col_sum)-1, " df = ",
    round(ColMain_c,3), "\n Total support for whole table = ", round(Tot_S,3),
    "\n Support for trend across columns = ", if (length(col_sum)>=3) round(tr,3),
    "\n Support for variance differing more than expected = ", round(toogood,3),
    "\n\n Chi-squared(", df, ") = ", round(chi.s,3), ",  p = ", format.pval(lt$p.value,4),
    "\n Likelihood ratio test G(", df, ") = ", round(lrt,3),
    ", p = ", signif(LRt_p,5), ", N = ", grandtot,
    "\n\n Trend p value from chi-squared = ", if (length(col_sum)>=3) format.pval(trX$p.value,4), "\n ")
  }

  invisible(list(S.int = S2wayc, df = df, S.int.unc = S2way,
               S.Main.rows = RowMain_c, S.Main.cols = ColMain_c,
               S.Mr.uncorr = RowMain, S.Mc.uncorr = ColMain,
               df.rows = length(row_sum)-1, df.cols = length(col_sum)-1,
               S.total = Tot_S, S.trend = tr, too.good = toogood,
               observed = lt$observed, expected = lt$expected,
               residuals = lt$residuals, chi.sq = lt$statistic, p.value = lt$p.value,
               LR.test = lrt, lrt.p = LRt_p, trend.p = trX$p.value))
}

