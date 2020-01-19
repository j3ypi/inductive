#' Wilcoxon Rank Sum and Signed Rank Tests
#'
#' Performs one- and two-sample Wilcoxon tests on vectors of data; the latter is also known as ‘Mann-Whitney’ test.
#' 
#' @param data an optional matrix or data frame (or similar: see model.frame) containing the variables in the formula formula. By default the variables are taken from environment(formula).
#' @param formula a formula of the form lhs ~ rhs where lhs is a numeric variable giving the data values and rhs a factor with two levels giving the corresponding groups.
#' @param x numeric vector of data values. Non-finite (e.g., infinite or missing) values will be omitted.
#' @param y an optional numeric vector of data values: as with x non-finite values will be omitted.
#' @param alternative a character string specifying the alternative hypothesis, must be one of "two.sided" (default), "greater" or "less". You can specify just the initial letter.
#' @param mu a number specifying an optional parameter used to form the null hypothesis. See ‘Details’.
#' @param paired a logical indicating whether you want a paired test.
#' @param exact a logical indicating whether an exact p-value should be computed.
#' @param correct a logical indicating whether to apply continuity correction in the normal approximation for the p-value.
#' @param conf.int a logical indicating whether a confidence interval should be computed.
#' @param conf.level confidence level of the interval.
#' @param obj a logical whether the test object of stats::t.test() should be returned.
#' @param na.action a function which indicates what should happen when the data contain NAs. Defaults to getOption("na.action").
#' @param ...	 further arguments to be passed to or from methods. 
#' 
#' @examples
#' \dontrun{
#' library(magrittr)
#' data(big_five, package = "inductive")
#' 
#' res <- big_five %>%
#'   sta_wilcox(Extraversion ~ Geschlecht)
#' 
#' res$result
#' res$obj
#' 
#' big_five %>%
#'   sta_wilcox(Extraversion ~ Neurotizismus)
#' 
#' big_five %>%
#'   sta_wilcox(x = Extraversion, y = Neurotizismus)
#' 
#' big_five %>%
#'   sta_wilcox(x = Neurotizismus, y = Extraversion)
#' }
#' 
#' @export
sta_wilcox <- function(data = NULL, formula = NULL, x = NULL, y = NULL, 
                       alternative = c("two.sided", "less", "greater"),
                       mu = 0, paired = FALSE, 
                       exact = NULL, correct = TRUE,
                       conf.int = FALSE, conf.level = 0.95, obj = TRUE, 
                       na.action = getOption("na.action"), ...) {
  
  if (!is.null(data) & !is.null(formula)) {
    form <- as.character(formula)
    col1 <- form[2] 
    col2 <- form[3] 
    x <- data[[col1]]
    y <- data[[col2]]
  } else if (is.null(data) & is.null(formula) & 
             !(is.name(substitute(x)) & is.name(substitute(y)))) {
    
    if (is.vector(x) & is.vector(y)) {
      x 
      y
    } else {
      stop("If data and formula is not provided, x and y must be vectors.", 
           call. = FALSE)
    }
  } else if (!is.null(data) & is.null(formula) & 
             is.name(substitute(x)) & is.name(substitute(y))) {
    x <- data[[deparse(substitute(x))]]
    y <- data[[deparse(substitute(y))]]
  } else {
    stop("The combination of data, formula, x and y is incorrect.", 
         call. = FALSE)
  }
  # formula wird x und y vorgezogen, falls beides gegeben ist
  
  if (is.factor(x) | is.factor(y)) {
    test_obj <- wilcox.test(formula = formula, data = data,
                            na.action = na.action, 
                            alternative = alternative, 
                            mu = mu, 
                            paired = paired, 
                            exact = exact,
                            correct = correct,
                            conf.int = conf.int,
                            conf.level = conf.level,...)
  } else {
    test_obj <- wilcox.test(x = x, y = y, 
                            alternative = alternative, 
                            mu = mu, 
                            paired = paired, 
                            exact = exact,
                            correct = correct,
                            conf.int = conf.int,
                            conf.level = conf.level, ...)
  }
  
  result <- suppressMessages(
    as.data.frame(broom::tidy(test_obj)[ ,-c(3, 4)])
  )
  names(result) <- c("W", "p.value")
  
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