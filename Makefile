
LATEX = pdflatex
LATEXFLAGS = -interaction=nonstopmode -halt-on-error
BIBTEX = bibtex

NAME = paper
TEXFILE = $(NAME).tex
BIBFILE = bib.bib

.PHONY: all clean

all: $(NAME).pdf

data/summary.csv:
	$(MAKE) -C data summary

data/summary-runtime.csv:
	$(MAKE) -C data summary

$(NAME).pdf: $(TEXFILE) $(BIBFILE) data/summary.csv
	@$(LATEX) $(LATEXFLAGS) $(TEXFILE)
	@$(BIBTEX) $(NAME)
	@$(LATEX) $(LATEXFLAGS) $(TEXFILE)
	@$(LATEX) $(LATEXFLAGS) $(TEXFILE)

clean:
	rm -f $(NAME).aux $(NAME).bbl $(NAME).blg $(NAME).log $(NAME).out $(NAME).toc $(NAME).pdf comment.cut
