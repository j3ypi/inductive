#' Fisher's Exact Test for Count Data
#'
#' Performs Fisher's exact test for testing the null of independence of rows and columns in a contingency table with fixed marginals.
#' 
#' @param x either a two-dimensional contingency table in matrix form, or a factor object.
#' @param y a factor object; ignored if x is a matrix.
#' @param obj a logical whether the test object of stats::fisher.test() should be returned.
#' @param workspace an integer specifying the size of the workspace used in the network algorithm. In units of 4 bytes. Only used for non-simulated p-values larger than 2 by 2 tables. Since R version 3.5.0, this also increases the internal stack size which allows larger problems to be solved, however sometimes needing hours. In such cases, simulate.p.values=TRUE may be more reasonable.
#' @param hybrid a logical. Only used for larger than 2 by 2 tables, in which cases it indicates whether the exact probabilities (default) or a hybrid approximation thereof should be computed.
#' @param hybridPars a numeric vector of length 3, by default describing “Cochran's conditions” for the validity of the chisquare approximation, see ‘Details’.
#' @param control a list with named components for low level algorithm control. At present the only one used is "mult", a positive integer ≥ 2 with default 30 used only for larger than 2 by 2 tables. This says how many times as much space should be allocated to paths as to keys: see file ‘fexact.c’ in the sources of this package.
#' @param or the hypothesized odds ratio. Only used in the 2 by 2 case.
#' @param alternative indicates the alternative hypothesis and must be one of "two.sided", "greater" or "less". You can specify just the initial letter. Only used in the 2 by 2 case.
#' @param conf.int logical indicating if a confidence interval for the odds ratio in a 2 by 2 table should be computed (and returned).
#' @param conf.level confidence level for the returned confidence interval. Only used in the 2 by 2 case and if conf.int = TRUE.
#' @param simulate.p.value a logical indicating whether to compute p-values by Monte Carlo simulation, in larger than 2 by 2 tables.
#' @param B an integer specifying the number of replicates used in the Monte Carlo test.
#' 
#' @examples
#' \dontrun{
#' library(magrittr)
#' data(big_five, package = "inductive")
#' 
#' kont <- table(big_five$Gender, big_five$Extraversion > 4)
#' 
#' kont %>% 
#'   sta_fisher()
#' 
#' fisher <- kont %>% 
#'   sta_fisher()
#' 
#' fisher$result
#' fisher$obj
#' }
#' 
#' @export
sta_fisher <- function(x, y = NULL, obj = TRUE,
                       workspace = 200000, hybrid = FALSE, 
                       hybridPars = c(expect = 5, percent = 80, Emin = 1),
                       control = list(), or = 1, 
                       alternative = "two.sided",
                       conf.int = TRUE, conf.level = 0.95,
                       simulate.p.value = FALSE, B = 2000) {
  
  test_obj <- stats::fisher.test(x = x, y = y, workspace = workspace, 
                          hybrid = hybrid, hybridPars = hybridPars, 
                          control = control, or = or, 
                          alternative = alternative, 
                          conf.int = conf.int, conf.level = conf.level, 
                          simulate.p.value = simulate.p.value, B = B)
  
  result <- suppressMessages(
    as.data.frame(broom::tidy(test_obj)[ ,-c(5, 6)])
  )
  
  names(result) <- c("odds.ratio", "p.value", "conf.low", "conf.high")
  
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