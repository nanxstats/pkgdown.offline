# pkgdown.offline

pkgdown.offline provides support for offline builds of pkgdown websites,
especially for pkgdown versions \>= 2.1.0.

It works by bundling cached frontend dependencies from different pkgdown
versions and implementing drop-in replacements for key functions. This
allows you to build documentation websites in development workflows or
CI/CD pipelines without internet access.

## Installation

You can install pkgdown.offline from CRAN:

``` r
install.packages("pkgdown.offline")
```

Or try the development version from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("nanxstats/pkgdown.offline")
```

## Usage

Use
[`pkgdown.offline::build_site()`](https://nanx.me/pkgdown.offline/reference/build_site.md)
and
[`pkgdown.offline::init_site()`](https://nanx.me/pkgdown.offline/reference/init_site.md)
to replace the original
[`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)
or
[`pkgdown::init_site()`](https://pkgdown.r-lib.org/reference/init_site.html)
calls in your original development or CI/CD workflow.

## Disclaimer

pkgdown.offline is an independent third-party solution **not** endorsed
by, affiliated with, or supported by the authors of pkgdown. It is
developed solely as a community contribution to address a specific use
case and is **not** an official extension of the pkgdown project.

## Contributing

We welcome contributions to pkgdown.offline. Please read the
[Contributing
Guidelines](https://nanx.me/pkgdown.offline/CONTRIBUTING.html) first.

All interactions within pkgdown.offline repositories and issue trackers
should adhere to the [Contributor Code of
Conduct](https://nanx.me/pkgdown.offline/CODE_OF_CONDUCT.html).
