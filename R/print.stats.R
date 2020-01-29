#' Generic S3 print method for objects of class stats
#'
print.stats <- function(x, ...) { 
  options(scipen = 10)
  print(round(x[[1]], 5))  
  on.exit(options(scipen = NA), add = TRUE)
}
