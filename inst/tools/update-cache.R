# Requires internet, requires specific CRAN version of pkgdown installed
# Adaptive to each pkgdown CRAN version, from >= 2.1.0?

# pkgdown v2.1.2:

# remotes::install_github("r-lib/pkgdown")
pkgdown_version <- "2.1.2"

source_cache_dir <- tools::R_user_dir("pkgdown", which = "cache")
fs::dir_delete(source_cache_dir)

pkgdown:::external_dependencies()

target_cache_dir <- file.path("inst/cache/", pkgdown_version)

fs::dir_copy(source_cache_dir, target_cache_dir, overwrite = TRUE)
