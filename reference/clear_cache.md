# Clear pkgdown cache if any

Removes all files from the pkgdown cache directory if it exists. This is
useful when troubleshooting or when you want to force a fresh caching of
pkgdown external dependencies.

## Usage

``` r
clear_cache()
```

## Value

Invisible `NULL`, called for side effect of clearing the cache.

## Examples

``` r
if (FALSE) { # \dontrun{
pkgdown.offline::clear_cache()
} # }
```
