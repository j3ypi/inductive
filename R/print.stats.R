#' Generic S3 print method for objects of class stats
#' 
#' @param x The object to be printed.
#' @param ... further arguments to be passed to or from methods.
#' 
#' @export
print.stats <- function(x, ...) { 
  options(scipen = 10)
  print(round(x[[1]], 5))  
  on.exit(options(scipen = NA), add = TRUE)
}