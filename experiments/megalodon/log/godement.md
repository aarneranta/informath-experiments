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

RunInformath -symboltables=empty.dkgf God1.dk | wc
    7267  338497 2142610


Extract LLM-generated symbol table

grep "//LLM" God1.mg | sed -r 's/^\/\/LLM //' >God1.dkgf

Analyse this symbol table

RunInformath -try-symboltable God1.dkgf | grep OK | wc
      81    1079    6308

RunInformath -try-symboltable God1.dkgf | grep BAD | wc
     431   11155   75782

RunInformath -unknown-words God1.dkgf | grep -v "\t1$" | wc
      74     148     634

Manual edits in the beginning (logical constants etc)

diff OrigGod1.dkgf God1.dkgf | grep "> " | wc
       8     115     536

RunInformath -try-symboltable God1.dkgf | grep BAD | wc
     426   11027   75021

Test the OK part of the symbol table

RunInformath -keep-ok-entries God1.dkgf | grep -v BAD >OkGod1.dkgf

RunInformath -symboltables=OkGod1.dkgf God1.dk



