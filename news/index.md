# Changelog

## pkgdown.offline 0.1.2

### pkgdown version support

- Adds support for pkgdown version 2.2.0
  ([\#30](https://github.com/nanxstats/pkgdown.offline/issues/30)).

## pkgdown.offline 0.1.1

CRAN release: 2025-05-25

### pkgdown version support

- Adds support for pkgdown version 2.1.3
  ([\#28](https://github.com/nanxstats/pkgdown.offline/issues/28)).

## pkgdown.offline 0.1.0

CRAN release: 2025-05-09

### New features

- Implements key functions that replace pkgdown counterparts:
  - [`build_site()`](https://nanx.me/pkgdown.offline/reference/build_site.md) -
    Builds complete pkgdown websites offline.
  - [`init_site()`](https://nanx.me/pkgdown.offline/reference/init_site.md) -
    Initializes site infrastructure offline.
- Implements
  [`clear_cache()`](https://nanx.me/pkgdown.offline/reference/clear_cache.md)
  to remove cached pkgdown frontend dependencies.

### pkgdown version support

- Supports pkgdown versions 2.1.0, 2.1.1, and 2.1.2 with
  version-specific implementations.
- Supports pkgdown versions \< 2.1.0 with conventional offline build
  method.

### Tooling

- Bundles optimized and deduplicated dependencies from supported pkgdown
  versions.
- Provides fallbacks for internet-dependent functions in pkgdown \>=
  2.1.0.
- Includes utilities for developers to update dependencies for future
  pkgdown versions.
