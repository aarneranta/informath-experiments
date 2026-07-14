# Instructions for lexicon building in autoformalization

When formalizing a text, return two kinds of code as by-product:
- a Dedukti file `myconstants.dk` containing the type signatures of all new constants you introduce
- an Informath symbol table file `myconstants.dkgf` containing lexical annotations of all those constants


Examples:
- myconstants.dk: `dist : Nat -> Nat -> Prop.`
- myconstants.dkgf: `dist : "#1 is distinct from #2" | "#1 and #2 are distinct" | $#1 \neq #2$`

## Feedback from Informath

You need to have the RunInformath binary available. Then you should run the following after every update:
```
$ RunInformath -base=myconstants.dk myconstants.dkgf
```
to test the soundness of the symbol table.
Also run
```
$ RunInformath -symboltables=myconstants.dkgf -variations myconstants.dk
```
to see the results of informalization.
These should be compared with the original text in some way.
Could you for instance rank them according to their closeness to the original text?



## More information in other files:

- build_lexicon.md: explain the task in more detail
- baseconstants.dk: examples of Dedukti constants
- profileconstants.dkgf: symbol table for baseconstants.dk
- words.tsv: English words available for symbol tables



