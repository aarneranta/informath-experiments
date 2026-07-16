all: test

symboltable:
	RunInformath -keep-ok-entries EditedGod1.dkgf | grep -v BAD >OkGod1.dkgf

latex:
	grep -v TODO God1.dk | head -100 | RunInformath -symboltables=OkGod1.dkgf -to-latex-doc >g100.tex
	pdflatex g100.tex

test: symboltable latex


mg2dk:
	../TryMegalodon God1.mg | grep DEDUKTI >God1.dk

