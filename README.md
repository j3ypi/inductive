<!-- badges: start -->

[![Build Status](https://travis-ci.org/j3ypi/inductive.svg?branch=master)](https://travis-ci.org/j3ypi/inductive) [![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/inductive)](https://cran.r-project.org/package=inductive)

<!-- badges: end -->

## Installation

A pipe-friendly and consistent framework for frequentist statistics in R. The package aims to lower the entry level for beginners and provide convenient functions for experienced users as their daily driver. Since the package isn’t released on CRAN yet, the development version needs to be downloaded from Github.

```R
remotes::install_github("j3ypi/inductive")
```

Check out the vignette [Get Started](https://j3ypi.github.io/inductive/articles/getstarted.html) for concrete examples on how to use the functions of this package. 

## Features 

This package is build on the principle that you should learn the theory once and than apply it to every other scenario. Meaning, if you understand the usage of one statistical test within this package, you won’t have a problem with any other function from the `inductive` package, ever. Behind the scenes it is not about reinventing the wheel but standing on the shoulder of giants. Nonetheless, dependencies will be reduced as much as it makes sense over time. 

**Consistent formula syntax.** The core concept is the formula syntax first introduced by Wilkinson & Rogers (1973), which is best explained on an ordinary regression model. One the left hand side of the formula is the dependent variable and on the right hand side are all the independent variables with potential influence on the dependent variable. Lets pretend one would like to investigate the influence of gender and age on the average manifestation of *extraversion* – one of the big five personality traits. The formula would look like this:

`Extraversion ~ Age + Gender`

To include random effect to the model, the `lme4` package introduced an extension of this formula syntax by integrating those random effects within round brackets. For a simple repeated measure design without any additional within-subject factors, one would write 

`Extraversion ~ Age + Gender + (1 | Person)`, 

where `Person` is some kind of identification of the subject. This package adapts those two mechanism and expands them to tests, where only two vectors are compared to each other. Suppose you want to conduct Student’s t-test between extroversion and neuroticism (another personality trait). Up until now, you would have to pass those to variables as vectors. Now you can pass them with the formula syntax, which treats the former `x` and `y` formula (e.g. see `stats::t.test()`) as `x ~ y`.

`Extraversion ~ Neuroticism`

To provide a certain degree of flexibility there are also alternative ways to input the variables (see [Get started](https://j3ypi.github.io/inductive/articles/getstarted.html)). 

**Pipe-friendly.** The first argument of each function is the `data` argument, which means that the pipe-operator from the [margrittr](https://magrittr.tidyverse.org/) package is able to pass the data invisibly to the function without the need to add this argument explicitly. For the example of Student’s t-test mentioned above, one could write 

```{r}
big_five %>%
   sta_t(Extraversion ~ Neuroticism, var.equal = TRUE)
```

to get the results returned. This feature makes it particularly easy to integrate those statistical tests with the [tidyverse](https://www.tidyverse.org/). Actually, up until now statistical tests where the last missing piece for a tidy introduction to R for scientists which is completely consistent. Thus, beginners do not have to learn about data structures like vectors and the dollar- and `[[` operator to access those vectors from `data.frames` anymore. Instead they can concentrate on the understanding of the principles which are consistent for all function within the `tidyverse`.

**Modified print method.** Many additional statistical R packages adapt the approach of propriety software like SPSS where they return a lot of tables you didn’t explicitly asked for, which makes it hard for beginners to understand which table they where looking for and impossible to use the results for continuous calculations. This package takes another approach. The functions only return the result you explicitly asked for. Though the `broom` package follows a similar philosophy it has two disadvantages for beginner-friendly scientific reporting. First, the output is too generic, which means for example that every estimate is just called `estimate` and second, the output is printed as a `tibble`. While `tibbles` are an awesome invention for most task, it is not optimal if you want to report exact (not rounded) numbers. Another problem is the scientific notation which cannot be disabled. Even for more experiences researchers `5.72e-4` is more difficult to read than `0.000572`. Furthermore, any numbers containing a minus sign are highlighted in red indicating for example negative *p*-values which can be confusing for students. By default the functions of the `inductive` package return a list with the results and the object created by the base R functions they are wrapped around. But when you print the result only the result table is displayed. This is achieved by a customization of the generic S3 print method for class `stats` objects returned by the function in this package. If you don’t need the complete result list you can easy disable to output the object with `obj = FALSE`.

**Prefix for auto-completion.** Who doesn’t know how it is to look up the name of an `stats` function in R for the hundredths time, because the names are inconsistent? The `inductive` package provides the prefix `sta_*` for all statistical tests making it particularly suited for auto-completion and suggestion within RStudio. The prefix leans on the `stat_*` prefix from the `ggplot2` package where it’s an acronym for **sta**tistical **t**ransformation. Derived from that one could say that `sta_*` stand for **sta**tistical. The prefix is not `test_` because it is already in use in the [testthat](https://testthat.r-lib.org/) package.

**Adapted documentation.** The documentation is expanded and adapted compared to their base R counterparts, making it easier to understand their arguments and how they can be used in practice. 

**All in one.** The resources for the most commonly used statistical tests are now in one place. No need to look it up every time on some site with your favorite search engine. Just type in the prefix `sta` to select the function you want to use.

**New but familiar.** Arguments are the same as in base R. This means that everything that works with functions from the `stats` package work with functions from the `inductive` package. Even the names are similar with the little tweak to turn the parts around so that `t.test()` becomes `sta_t()` or `var.test()` is now called `sta_var()`.

## Roadmap

- [x] F test: `sta_var()` 
- [x] t-test and Welch-test: `sta_t()`
- [x] Wilcoxon test: `sta_wilcox()`
- [x] Pearson’s and Mcnemars’s $\chi^2$ test: `sta_chisq()`
- [x] Fisher’s Exact test: `sta_fisher()` 
- [ ] Linear regression Model (with fixed and/or random effects): `sta_lm()` 
- [ ] ANOVA (with and without repeated measures): `sta_anova()` 
- [ ] Correlation: `sta_cor()`
- [ ] Kolgomorov-Smirnov test: `sta_ks()`
- [ ] Kruskall-Wallis test: `sta_kruskal()`
- [ ] Bartletts test: `sta_bartlett()`
- [ ] Shapiro-Wilks test: `sta_shapiro()`
- [ ] Mauchly test: `sta_mauchly()`
- [ ] Levene test: `sta_levene()`
- [ ] Reduce internal dependencies
- [ ] Contingency table: `cont_table()`
- [ ] Modify print method: `modify_printing()`

## Reference

Bache, S.M. and Wickham, H. (2014). magrittr: A Forward-Pipe Operator for R. R package version 1.5. https://CRAN.R-project.org/package=magrittr

Bates, D., Maechler M., Bolker B. and Walker S. (2015). Fitting Linear Mixed-Effects Models Using lme4. Journal of Statistical Software, 67(1), 1-48. doi:10.18637/jss.v067.i01.

Robinson, D. and Hayes, A. (2019). broom: Convert Statistical Analysis Objects into Tidy Tibbles. R package version 0.5.2. https://CRAN.R-project.org/package=broom

Wickham, H. (2017). tidyverse: Easily Install and Load the 'Tidyverse'. R package version 1.2.1. https://CRAN.R-project.org/package=tidyverse

Wilkinson, G., & Rogers, C. (1973). Symbolic Description of Factorial Models for Analysis of Variance. *Journal of the Royal Statistical Society. Series C (Applied Statistics),* *22*(3), 392-399. doi:10.2307/2346786.

