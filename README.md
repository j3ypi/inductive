<!-- badges: start -->

[![Build Status](https://travis-ci.org/j3ypi/inductive.svg?branch=master)](https://travis-ci.org/j3ypi/inductive) [![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/inductive)](https://cran.r-project.org/package=inductive)

<!-- badges: end -->

A pipe-friendly and consistent framework for frequentist statistics in R. Since the package isn’t released on CRAN yet, it has to be downloaded from Github directly.

```R
remotes::install_github("j3ypi/inductive")
```

Check out [Get Started](https://j3ypi.github.io/inductive/articles/getstarted.html) for concrete examples on how to use the functions of this package. 

## Features 

This package is build on the principle that you should learn the theory once and than apply it to every other scenario. Meaning, if you understand the usage of one statistical test within this package, you won’t have a problem with any other function from the `inductive` package, ever. Behind the scenes it is not about reinventing the wheel but standing on the shoulder of giants instead. Nonetheless, dependencies will be reduced as much as it makes sense over time. 

**Consistent formula syntax.** The core concept is the formula syntax first introduced by Wilkinson & Rogers (1973), which is best explained on an ordinary regression model. One the left hand side of the formula is the dependent variable and on the right hand side are all the independent variables with potential influence on the dependent variable. Lets pretend one would like to investigate the influence of gender and age on the average manifestation of extroversion – one of the big five personality traits. The formula would look like this:

`Extraversion ~ Age + Gender`

The `lme4` package first introduced an extension of this formula syntax by integrating random effects within bracket. For a simple repeated measure, one would write 

`Extraversion ~ Age + Gender + (1 | Person)`. 

This package adapts those to mechanism and expands them to tests, where only two vectors are compared to each other. Suppose you want to conduct Student’s t-test between extroversion and neuroticism (another personality trait). Up until now, you would have to pass those to variables as vectors. Now you can pass them with the formula, which is treated as `x ~ y` compared to documentation the `stats` package where `x` and `y` can be either vectors or a grouping variable. 

`Extraversion ~ Neuroticism`

**Pipe-friendly.** The first argument of each function is the `data` argument, which means that the pipe-operator can pass the data invisible to the function without the need to add this argument manually. 

```{r}
big_five %>%
   sta_t(Extraversion ~ Neuroticism)
```

**Modified print method.** Many additional statistical R packages adapt the approach of propriety software like SPSS where they return a lot of tables you didn’t explicitly asked for, which makes it hard for beginners to understand which table they where looking for and impossible to use the results for continuous calculations. This package takes another approach. The functions only return the result you explicitly asked for. Though the `broom` package follows a similar philosophy it has two disadvantages for beginner-friendly scientific reporting. First, the output is two generic, which means that every estimate is just called `estimate` and second, the output is printed as a `tibble`. While `tibbles` are an awesome invention for most task, it is not optimal if you want to report exact (not rounded) numbers. Another problem is the scientific notation which cannot be disabled. Even for more experiences researchers `3.1E-10` .. is more difficult to read than `0.31`. Additionally, negative numbers (`3.1E-10`) are highlighted in red indicating for example negative *p*-values which might be confusing for students. By default the functions of the `inductive` package return a list with the results and the object created by the base R functions they are wrapped around. But when you print the result only the result table is displayed. If you don’t need the object’s complete result list you can easy disable to output the object (`obj = FALSE`).

**Prefix for auto-completion.** Who doesn’t know how it is to look up the name of an `stats` function in R for the hundredths time, because the names are inconsistent? The `inductive` package provides a prefix `sta_*` for all functions making it particularly suited for auto-completion and suggestion within RStudio.

**Adapted documentation.** The documentation is expanded and adapted compared to their base R counterparts, making it easier to understand their arguments and how they can be used in practice. 

**All in one.** The resources for the most commonly used functions are now in one place. No need to look it up every time with your favorite search engine. Just type in `sta` to select the functions you want to use.

## Roadmap

If you consider contributing please get in touch. 

- [x] F test: `sta_var()` 
- [x] t-test and Welch-test: `sta_t()`
- [x] Wilcoxon test: `sta_wilcoxon()`
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

## Reference

Bache, S.M. and Wickham, H. (2014). magrittr: A Forward-Pipe Operator for R. R package version 1.5. https://CRAN.R-project.org/package=magrittr

Robinson, D. and Hayes, A. (2019). broom: Convert Statistical Analysis Objects into Tidy Tibbles. R package version 0.5.2. https://CRAN.R-project.org/package=broom

Wickham, H. (2017). tidyverse: Easily Install and Load the 'Tidyverse'. R package version 1.2.1. https://CRAN.R-project.org/package=tidyverse

Wilkinson, G., & Rogers, C. (1973). Symbolic Description of Factorial Models for Analysis of Variance. *Journal of the Royal Statistical Society. Series C (Applied Statistics),* *22*(3), 392-399. doi:10.2307/2346786

