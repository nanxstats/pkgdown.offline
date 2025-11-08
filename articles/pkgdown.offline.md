# Use pkgdown.offline

pkgdown.offline supports offline builds of pkgdown websites. It
implements identically named functions to mask the original site
initialization and site building functions for convenient drop-in
replacements in your environment-constrained development or CI/CD
workflows that cannot access the internet.

## Try it out locally

To test the offline build workflow, first clear the pkgdown external
frontend dependencies cache that might exist in your environment:

``` r
pkgdown.offline::clear_cache()
```

Create a new package. For example:

``` r
usethis::create_package(file.path(tempdir(), "pkg"))
```

**Switch off internet connection**. In the new project, run:

``` r
usethis::use_pkgdown()
pkgdown.offline::build_site()
```

## Use in production environments

In practice, you can replace
[`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)
calls with
[`pkgdown.offline::build_site()`](https://nanx.me/pkgdown.offline/reference/build_site.md)
in your wrapper function or CI/CD workflow to achieve offline builds.
Similarly, you can use
[`pkgdown.offline::init_site()`](https://nanx.me/pkgdown.offline/reference/init_site.md)
if a
[`pkgdown::init_site()`](https://pkgdown.r-lib.org/reference/init_site.html)
step was involved in your workflow.
