
LATEX = pdflatex
LATEXFLAGS = -interaction=nonstopmode -halt-on-error
BIBTEX = bibtex

NAME = paper
TEXFILE = $(NAME).tex
BIBFILE = sample-base.bib

.PHONY: all clean

all: $(NAME).pdf

# 1st pdflatex: produces .aux with citation keys
# bibtex: resolves citations -> .bbl
# 2nd pdflatex: inserts bibliography, resolves refs
# 3rd pdflatex: stabilizes page numbers / cross-references
$(NAME).pdf: $(TEXFILE) $(BIBFILE)
	@$(LATEX) $(LATEXFLAGS) $(TEXFILE)
	@$(BIBTEX) $(NAME)
	@$(LATEX) $(LATEXFLAGS) $(TEXFILE)
	@$(LATEX) $(LATEXFLAGS) $(TEXFILE)

clean:
	rm -f $(NAME).aux $(NAME).bbl $(NAME).blg $(NAME).log $(NAME).out $(NAME).toc $(NAME).pdf comment.cut
