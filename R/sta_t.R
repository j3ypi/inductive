#' Student's t-Test or Welch-Test
#'
#' Performs one and two sample t-tests or Welch-tests on vectors of data.
#' 
#' @param data an optional matrix or data frame (or similar: see model.frame) containing the variables in the formula formula. By default the variables are taken from environment(formula).
#' @param formula a formula of the form lhs ~ rhs where lhs is a numeric variable giving the data values and rhs a factor with two levels giving the corresponding groups.
#' @param x numeric vectors of data values, or fitted linear model objects (inheriting from class "lm").
#' @param y numeric vectors of data values, or fitted linear model objects (inheriting from class "lm").
#' @param alternative a character string specifying the alternative hypothesis, must be one of "two.sided" (default), "greater" or "less". You can specify just the initial letter.
#' @param mu a number indicating the true value of the mean (or difference in means if you are performing a two sample test).
#' @param paired a logical indicating whether you want a paired t-test.
#' @param var.equal a logical variable indicating whether to treat the two variances as being equal. If TRUE then the pooled variance is used to estimate the variance otherwise the Welch (or Satterthwaite) approximation to the degrees of freedom is used.
#' @param conf.level confidence level for the returned confidence interval.
#' @param obj a logical whether the test object of stats::t.test() should be returned.
#' @param na.action a function which indicates what should happen when the data contain NAs. Defaults to getOption("na.action").
#' @param ... further arguments to be passed to or from methods.
#' 
#' @examples
#' \dontrun{
#' library(magrittr)
#' data(big_five, package = "inductive")
#' 
#' big_five %>% 
#'   sta_t(Extraversion ~ Gender)
#' 
#' big_five %>% 
#'   sta_t(x = Extraversion, y = Neuroticism, var.equal = TRUE)
#' 
#' big_five %>% 
#'   sta_t(x = Neuroticism, y = Extraversion)
#' 
#' big_five %>% 
#'   sta_t(Extraversion ~ Neuroticism)
#' 
#' sta_t(big_five, Extraversion ~ Gender)
#' }
#' 
#' @export
sta_t <- function(data = NULL, formula = NULL, x = NULL, y = NULL,
                  alternative = "two.sided", mu = 0, 
                  paired = FALSE, var.equal = FALSE,
                  conf.level = 0.95, obj = TRUE,  
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
    test_obj <- t.test(formula = formula, data = data,
                     na.action = na.action, alternative = alternative, 
                     mu = mu, paired = paired, var.equal = var.equal, 
                     conf.level = conf.level,...)
    cohen <- effsize::cohen.d(x ~ y)[["estimate"]]

  } else {
    test_obj <- t.test(x = x, y = y, alternative = alternative, 
                     mu = mu, paired = paired, var.equal = var.equal, 
                     conf.level = conf.level, ...)
    cohen <- effsize::cohen.d(d = x, f = y)[["estimate"]]
    
  }
  
  result <- suppressMessages(
    as.data.frame(cbind(
      broom::tidy(test_obj),
      cohen))
  )
  vars <- grepl("estimate", names(result))
  result <- result[!vars]
  result <- result[, -c(6, 7)]
  
  names(result) <- c("t.value", "p.value", "df", 
                     "conf.low", "conf.high", "cohen.d")

  result <- result[ , c(1, 3, 2, 4, 5, 6)]
  
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