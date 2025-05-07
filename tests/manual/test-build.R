# Test if offline build works

pkgdown_version <- available.packages(repos = "https://cloud.r-project.org/")["pkgdown", "Version"]
pkgdown.offline:::install_pkgdown(pkgdown_version)

pkg_path <- "zzz.build"
usethis::create_package(pkg_path)

# Switch off internet connection. In the opened project, run
usethis::use_pkgdown()
usethis::use_logo(file.path(R.home(), "doc", "html", "Rlogo.svg"))

pkgdown.offline::clear_cache()
pkgdown.offline::build_site()

rstudioapi::executeCommand("quitSession")

# In the pkgdown.offline project, clean up
pkgdown.offline:::dir_delete(pkg_path)
