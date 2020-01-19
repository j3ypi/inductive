<!-- badges: start -->

[![Build Status](https://travis-ci.org/j3ypi/inductive.svg?branch=master)](https://travis-ci.org/j3ypi/inductive) [![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) [![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/inductive)](https://cran.r-project.org/package=inductive)

<!-- badges: end -->

# inductive

A pipe-friendly and consistent framework for frequentist statistics in R. 



**Table of contents**

**[Installation](#installation)** <br>**[Philosophy](#philosophy)** <br>**[Examples](#examples)** <br>**[Roadmap](#roadmap)** <br>**[Reference](#reference)** <br>

## Installation

Since the package isn’t released on CRAN yet, it has to be downloaded from Github directly.

```R
remotes::install_github("j3ypi/inductive")
```

Anyone who conducts some kind of statistical tests in R will further or later notice inevitably, that while doing their job just fine, the build in R function for hypothesis tests lack of consistency. Furthermore, the uprising of the packages within the `tidyverse` and those compatible with it (like this package) really shine a light on the inconvenient way the build in R functions work with the pipe the `magrittr` packages provides. Of course, this is not an accusation because a lot of time has passes since the release of the build-in `stats` package. While it is indeed possible to combine those to with a placeholder (`.`) it is neither convenient nor easy so grasp for beginners.

The naming of the functions is inconsistent, too – Some contain the estimate, some the name of the test, some only a part of the name, some an acronym etc. While these functions adopt the naming for familiarity reasons, the functions in this package do all have a prefix (`sta_*`) so that one is able to select the function needed from the suggestions within RStudio, instead of looking it up on the internet each time you haven’t used it for a while. Last but not least, the output printed out from the functions within base R do not provide the possibility for further calculation with the results.  While the `broom` package does offer a solution to this, it’s column naming is too generic for beginners and returns a `tibble` which is practical for a first glance but not for the exact values which a scientist or students needs to report.

So while some might think the `inductive` package is yet another statistic package which gets the same job done as well-established packages, you shouldn’t forget how you started. R is a great way to introduce students or scientists who have no idea of programming languages or computers – apart from turning them on – to the world of programming and data analysis which is a key skill in all empirical sciences and many other areas. 

## Philosophy 

This package is build on the principle that you should learn the theory once and than apply it to every other scenario. Meaning, if you understand the usage of one statistical test within this package, you won’t have a problem with any other function from the `inductive` package. Behind the scenes it is not about reinventing the wheel but standing on the shoulder of giants instead. Nonetheless, dependencies will be reduced as much as it makes sense over time. 

The core concept is the formula syntax first introduced by Wilkinson & Rogers (1973), which is best explained on an ordinary regression model. One the left hand side of the formula is the dependent variable and on the right hand side are all the independent variables with potential influence on the dependent variable. Lets pretend one would like to investigate the influence of gender and age on the average manifestation of extroversion – one of the big five personality traits. The formula would look like this:

`Extroversion ~ Age + Gender`

The `lme4` package first introduced an extension of this formula syntax by integrating random effects within bracket. For a simple repeated measure, one would write 

`Extroversion ~ Age + Gender + (1 | Person)`. 

This package adapts those to mechanism and expands them to tests, where only two vectors are compared to each other. Suppose you want to conduct Student’s t-test between extroversion and neuroticism (another personality trait). Up until now, you would have to pass those to variables as vectors. In the `inductive` package one could write 

```{r}
big_five %>%
   sta_t(Extraversion ~ Neuroticism)
```

to get the same result, while keeping the syntax clean and consistent. Internally, it behaves like `x ~ y`. As you might have noticed

Prefix and adapted documentation

Only what you asked for and not a thousand tables more.

Printing and obj argument (generic print method adapted for stats class, rounded numbers, advantage if objects are large)

Example F-test with formula and pipe

```{r}
big_five %>%
```

Example F-test for every personality trait

## Examples

```{r}
big_five %>%
	nest()
```

## Roadmap

If you consider contributing please get in touch. 

**Upcoming**

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

**Eventually**

- [ ] Generalized linear model: `sta_glm()`
- [ ] Baseline logit model and proportional odds model: `sta_vglm()`

## Reference

Bache, S.M. and Wickham, H. (2014). magrittr: A Forward-Pipe Operator for R. R package version 1.5. https://CRAN.R-project.org/package=magrittr

Robinson, D. and Hayes, A. (2019). broom: Convert Statistical Analysis Objects into Tidy Tibbles. R package version 0.5.2. https://CRAN.R-project.org/package=broom

Wickham, H. (2017). tidyverse: Easily Install and Load the 'Tidyverse'. R package version 1.2.1. https://CRAN.R-project.org/package=tidyverse

Wilkinson, G., & Rogers, C. (1973). Symbolic Description of Factorial Models for Analysis of Variance. *Journal of the Royal Statistical Society. Series C (Applied Statistics),* *22*(3), 392-399. doi:10.2307/2346786

