# Test if offline initialization works

path <- "zzz.init"
pkgdown.offline:::install_pkgdown("2.1.2")
usethis::create_package(path)

# Switch off internet connection. In the opened project, run
usethis::use_pkgdown()
pkgdown.offline::clear_cache()
pkgdown.offline::init_site()

# In the pkgdown.offline project, clean up
pkgdown.offline:::dir_delete(path)
