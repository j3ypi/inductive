#' Pearson's or McNemar's Chi-squared Test for Count Data
#'
#' Performs chi-squared contingency table tests and goodness-of-fit tests.
#' 
#' @param x a numeric vector or matrix. x and y can also both be factors.
#' @param y a numeric vector; ignored if x is a matrix. If x is a factor, y should be a factor of the same length.
#' @param paired a logical variable indicating whether to treat the two variances as being equal.
#' @param obj a logical whether the test object of stats::chisq.test() or stats::mcnemar.test should be returned.
#' @param correct a logical indicating whether to apply continuity correction when computing the test statistic for 2 by 2 tables: one half is subtracted from all |O - E| differences; however, the correction will not be bigger than the differences themselves. No correction is done if simulate.p.value = TRUE.
#' @param p a vector of probabilities of the same length of x. An error is given if any entry of p is negative.
#' @param rescale.p a logical scalar; if TRUE then p is rescaled (if necessary) to sum to 1. If rescale.p is FALSE, and p does not sum to 1, an error is given.
#' @param simulate.p.value a logical indicating whether to compute p-values by Monte Carlo simulation.
#' @param B an integer specifying the number of replicates used in the Monte Carlo test.
#' 
#' @examples
#' \dontrun{
#' library(magrittr)
#' data(big_five, package = "inductive")
#' 
#' kont <- table(big_five$Geschlecht, big_five$Extraversion > 4)
#' 
#' sta_chisq(kont)
#' 
#' kont %>% 
#'   sta_chisq(paired = TRUE)
#' 
#' }
#' 
#' @export
sta_chisq <- function(x = NULL, y = NULL, paired = FALSE, obj = TRUE,
                      correct = TRUE, p = rep(1/length(x), length(x)), 
                      rescale.p = FALSE, 
                      simulate.p.value = FALSE, B = 2000) {
  
  if (!paired) {
    test_obj <- stats::chisq.test(x = x, y = y, correct = correct, 
                           p = p, rescale.p = rescale.p, 
                           simulate.p.value = simulate.p.value, B = B)
  } else if (paired) {
    test_obj <- stats::mcnemar.test(x = x, y = y, correct = correct)  
  } else {
    stop("The paired argument must be either TRUE or FALSE.",
         call. = FALSE)
  }
  
  result <- suppressMessages(
    as.data.frame(broom::tidy(test_obj)[ ,-4])
  )
  names(result) <- c("chi.squared", "p.value", "df")
  result <- result[ ,c(1, 3, 2)]
  
  if (obj) {
    ls <- vector("list", 2)
    names(ls) <- c("result", "obj")
    ls[["result"]] <- result
    ls[["obj"]] <- test_obj
    class(ls) <- c("list", "stats")
    ls
  } else if (!obj) {
    class(result) <- c("data.frame", "stats")
    result
  } else {
    stop("The obj argument must be either TRUE or FALSE.",
         call. = FALSE)
  }
  
}