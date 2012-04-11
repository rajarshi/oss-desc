all: paper.pdf
	@echo "********* Latex Summary *********"
	@grep -i error paper.log || true
	@grep -i warning paper.log || true

update: paper.pdf

paper.bbl: paper.bib
	pdflatex paper || true
	bibtex paper || true

paper.pdf: paper.tex paper.bbl
	pdflatex paper.tex
	pdflatex paper.tex
	pdflatex paper.tex

distclean: clean

clean:
	rm -f *.bbl *.aux paper.pdf *.blg *.log *.ps *.fff *.lof *.lot *.ttt *.dvi *~ *.Rout *-blx.bib
