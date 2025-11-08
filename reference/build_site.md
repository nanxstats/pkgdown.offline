# Build a complete pkgdown website offline

Builds a pkgdown website without requiring internet connection by using
cached dependencies. Detects the installed pkgdown version and applies
the appropriate offline build strategy.

## Usage

``` r
build_site(...)
```

## Arguments

- ...:

  Arguments passed to
  [`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html).

## Value

Invisible `NULL`, called for side effect of building the website.

## Examples

``` r
if (FALSE) { # \dontrun{
pkgdown.offline::build_site(override = list(destination = tempdir()))
} # }
```
