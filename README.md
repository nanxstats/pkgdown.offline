# pkgdown.offline <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/nanxstats/pkgdown.offline/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nanxstats/pkgdown.offline/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

pkgdown.offline provides support for offline builds of pkgdown websites,
especially for pkgdown versions >= 2.1.0.

It works by bundling cached frontend dependencies from different pkgdown
versions and implementing drop-in replacements for key functions.
This allows you to build documentation websites in development workflows
or CI/CD pipelines without internet access.

## Installation

You can install the development version of pkgdown.offline from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("nanxstats/pkgdown.offline")
```

## Usage

Use `pkgdown.offline::build_site()` and `pkgdown.offline::init_site()`
to replace the original `pkgdown::build_site()` or `pkgdown::init_site()`
calls in your original development or CI/CD workflow.

## Disclaimer

pkgdown.offline is an independent third-party solution **not** endorsed by,
affiliated with, or supported by the authors of pkgdown.
It is developed solely as a community contribution to address a specific
use case and is **not** an official extension of the pkgdown project.

## Contributing

We welcome contributions to pkgdown.offline. Please read the
[Contributing Guidelines](https://nanx.me/pkgdown.offline/CONTRIBUTING.html) first.

All interactions within pkgdown.offline repositories and issue trackers
should adhere to the [Contributor Code of Conduct](https://nanx.me/pkgdown.offline/CODE_OF_CONDUCT.html).
