# Makefile for LaTeX package NGEd
# $Id$
#
# Copyright (C) 2009 Denis Kosygin <kosygin@courant.nyu.edu>
#
SHELL = /bin/sh
TEXINPUTS = ./texmf//:
TEX = tex
LATEX = latex
MAKEINDEX = makeindex

name = nge
sources = $(name).dtx
targets = $(name).ins readme.txt install.txt license.txt

.PHONY: all doc dvi pdf ps
all:
	$(LATEX) $(name).dtx
	$(MAKEINDEX) -s gind.ist $(name)
	$(MAKEINDEX) -s gglo.ist -o $(name).gls $(name).glo
	$(LATEX) $(name).dtx
	$(LATEX) $(name).dtx

.PHONY: clean texclean distclean
clean: texclean
	-$(RM) *~
texclean:
	-$(RM) *.log *.aux *.dvi *.toc texput.*
	-$(RM) *.ind *.idx *.ilg *.glo *.gls
distclean: texclean
	-$(RM) $(targets) $(name).pdf $(name).ps

### Maintainers' and developers' section
svnroot = https://subversive.cims.nyu.edu/mathclinical
svnbranch = kdv
svn_url = $(svnroot)/$(name)/branches/$(svnbranch)
checkoutdir = src
SVN = svn
SVN_EDITOR = "emacs -nw"
SVN2CL = bin/svn2cl.sh
SVN2CL_OPTS = --authors .svn2cl_authors

.PHONY: checkout changelog 
checkout:
	$(SVN) checkout $(svn_url) $(checkoutdir)
	@echo '\nsources from '$(svn_url)' \nare placed in '$(checkoutdir)

commit: cleanall
	$(SVN) commit
changelog:
	if [ -f ChangeLog ]; \
        then cp ChangeLog ChangeLog.bak; \
	     $(SVN2CL) $(SVN2CL_OPTS) -o ChangeLog.tmp \
             -r HEAD:\{`head -1 ChangeLog | awk '{print $$1}'`\} \
             && cat ChangeLog.tmp ChangeLog.bak >ChangeLog; \
        else echo '\nWarning: ChangeLog not found.\nPerform svn update.'; fi

.PHONY: maintainer-clean cleanall
maintainer-clean:
#	@echo 'This command is intended for maintainers to use;'
#	@echo 'it deletes files that may need special tools to rebuild.'
	-$(RM) ChangeLog.bak ChangeLog.tmp

cleanall: clean distclean maintainer-clean
test:
	echo $$TEXINPUTS
