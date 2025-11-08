# Initialize site infrastructure offline

Sets up the necessary infrastructure for building a pkgdown site offline
by copying locally cached dependencies to the pkgdown cache directory.

## Usage

``` r
init_site(...)
```

## Arguments

- ...:

  Arguments passed to
  [`pkgdown::init_site()`](https://pkgdown.r-lib.org/reference/init_site.html).

## Value

Invisible `NULL`, called for side effect of initializing site resources.

## Examples

``` r
if (FALSE) { # \dontrun{
pkgdown.offline::init_site(override = list(destination = tempdir()))
} # }
```
