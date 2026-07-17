all: test

symboltable:
	RunInformath -keep-ok-entries EditedGod1.dkgf | grep -v BAD >OkGod1.dkgf

latex:
	grep -v step godbook.dk | head -40 | RunInformath -sampling=20 -symboltables=OkGod1.dkgf -to-latex-doc >g200.tex
	pdflatex g200.tex

test: symboltable latex


mg2dk:
	../TryMegalodon God1.mg | grep DEDUKTI >God1.dk

orig.dkgf:
	egrep -e "//LLM|//REA|/GOD1\:" God1.mg | cut -f2- -d' ' >OrigGod1.dkgf 

