#' F Test to Compare Two Variances
#'
#' Performs an F test to compare the variances of two samples from normal populations.
#' 
#' @param data an optional matrix or data frame (or similar: see model.frame) containing the variables in the formula formula. By default the variables are taken from environment(formula).
#' @param formula a formula of the form lhs ~ rhs where lhs is a numeric variable giving the data values and rhs a factor with two levels giving the corresponding groups.
#' @param x numeric vectors of data values, or fitted linear model objects (inheriting from class "lm").
#' @param y numeric vectors of data values, or fitted linear model objects (inheriting from class "lm").
#' @param ratio a character string specifying the alternative hypothesis, must be one of "two.sided" (default), "greater" or "less". You can specify just the initial letter.
#' @param alternative a character string specifying the alternative hypothesis, must be one of "two.sided" (default), "greater" or "less". You can specify just the initial letter.
#' @param conf.level confidence level for the returned confidence interval.
#' @param obj a logical whether the test object of stats::var.test() should be returned.
#' @param na.action a function which indicates what should happen when the data contain NAs. Defaults to getOption("na.action").
#' @param ... further arguments to be passed to or from methods.
#' 
#' @examples
#' \dontrun{
#' library(magrittr)
#' data(big_five, package = "inductive")
#' 
#' big_five %>% 
#'   sta_var(Extraversion ~ Gender)
#' 
#' big_five %>% 
#'   sta_var(Extraversion ~ Neuroticism)
#' 
#' big_five %>% 
#'   sta_var(x = Extraversion, y = Neuroticism)
#' 
#' sta_var(big_five, x = Extraversion, y = Neuroticism)
#' 
#' sta_var(x = big_five$Extraversion, y = big_five$Neuroticism)
#' 
#' sta_var(big_five, Extraversion ~ Gender)
#' }
#' 
#' @export
sta_var <- function(data = NULL, formula = NULL, x = NULL, y = NULL, 
                    ratio = 1, alternative = "two.sided", 
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
    test_obj <- stats::var.test(formula = formula, data = data,
                       na.action = na.action, ratio = ratio, 
                       alternative = alternative, 
                       conf.level = conf.level, ...)
  } else {
    test_obj <- stats::var.test(x = x, y = y, ratio = ratio, 
                       alternative = alternative, 
                       conf.level = conf.level, 
                       na.action = na.action,...)
  }
  
  result <- suppressMessages(
    as.data.frame(broom::tidy(test_obj)[ ,c(2:7)])
  )
  
  names(result) <- c("df1", "df2", "F.value", "p.value", 
                        "conf.low", "conf.high")
  
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