
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

################
# Testing
################
test <- big_five %>% 
  sta_wilcox(Extraversion ~ Geschlecht)

test$result
test$obj

big_five %>% 
  sta_wilcox(Extraversion ~ Neurotizismus)

big_five %>% 
  sta_wilcox(x = Extraversion, y = Neurotizismus)

big_five %>% 
  sta_wilcox(x = Neurotizismus, y = Extraversion)

wilcox.test(big_five$Extraversion, big_five$Neurotizismus)
wilcox.test(Extraversion ~ Geschlecht, data = big_five)














