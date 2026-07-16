# testing autoformalized megalodon

Extract Megalodon code

grep -v "//" God1.mg  >JustGod1.mg


Test Dedukti extraction

../TryMegalodon JustGod1.mg | grep FAIL | wc         
    6900  302276 1708271
../TryMegalodon JustGod1.mg | grep SUCC | wc
    7267  144488  824225

Just keep the successful extract

../TryMegalodon JustGod1.mg | grep DEDUKTI >God1.dk


Try RunInformath with detault symbol table: failure

RunInformath God1.dk | wc
RunInformath: no Prop EApp (EFun CoreIfProp) (EApp (EApp (EFun AnnotateProp) (EApp (EFun StrIdent) (ELit (LStr "z")))) (EApp (EFun IdentProp) (EApp (EFun StrIdent) (ELit (LStr "z")))))
    228    5924   34008

Try RunInformath with empty symbol table: success

touch empty.dkgf

RunInformath -symboltables=empty.dkgf God1.dk | wc1
    7267  338497 2142610


Extract LLM-generated symbol table

egrep -e "//LLM|//REA|/GOD1\:" God1.mg | cut -f2- -d' ' >OrigGod1.dkgf 

Analyse this symbol table

RunInformath -try-symboltable OrigGod1.dkgf | grep OK | wc
     129    1785   10594
RunInformath -try-symboltable OrigGod1.dkgf | grep BAD | wc
     855   24142  159200

RunInformath -try-symboltable OrigGod1.dkgf | grep OK | wc
      81    1079    6308

RunInformath -try-symboltable OrigGod1.dkgf | grep BAD | wc
     431   11155   75782

RunInformath -unknown-words OrigGod1.dkgf | grep -v "\t1$" | wc
     112     224    1028

Extract the OK part of the symbol table

RunInformath -keep-ok-entries God1.dkgf | grep -v BAD >OkGod1.dkgf

Manual edits in the beginning (logical constants etc)

diff OrigGod1.dkgf OkGod1.dkgf | grep "> " | wc
    10      82     461


Test informalization with it

RunInformath -symboltables=OkGod1.dkgf God1.dk


grep -v TODO God1.dk | head -100 | RunInformath -symboltables=OkGod1.dkgf -to-latex-doc >g100.tex

grep -v TODO God1.dk | head -100 | RunInformath -symboltables=OkGod1.dkgf -to-latex-doc -to-lang=Cze >g100.tex


Analyse frequencies of identifiers

RunInformath -idents God1.dk | more
set     12163
forall  6089
step    5689
K       3939


Analyse frequencies of identifiers not in the accepted symbol table

RunInformath -unknown-idents -symboltables=OkGod1.dkgf God1.dk | more
step    5689
K       3939
SIdent  2055
add     1932
mul     1742


Second round: edit directly in the partly bad EditedGod1.dkgf and do

diff OrigGod1.dkgf EditedGod1.dkgf

RunInformath -keep-ok-entries EditedGod1.dkgf | grep -v BAD >OkGod1.dkgf


