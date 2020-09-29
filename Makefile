all: cran pkgdown readme

cran: build rd2pdf
	R CMD check --as-cran ../NonCompart_*.tar.gz ;\ 
	mv ../NonCompart_*.tar.gz releases/

install:
	cd .. ;\
	R CMD INSTALL --no-multiarch --with-keep.source NonCompart

roxygen: install
	Rscript -e "library(NonCompart);roxygen2::roxygenise()" 

build: roxygen
	Rscript -e "devtools::build()" 

rd2pdf:
	cd .. ;\
	rm NonCompart.pdf NonCompart/inst/doc/NonCompart.pdf ;\
	R CMD Rd2pdf NonCompart ;\
	cp NonCompart.pdf NonCompart/inst/doc/NonCompart.pdf

pkgdown: 
	rm -rf docs ;\
	Rscript -e "Sys.setlocale('LC_ALL', 'C'); pkgdown::build_site()" 

readme: 
	Rscript -e "rmarkdown::render('README.Rmd', output_format = 'github_document')"

