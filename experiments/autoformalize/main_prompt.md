# Instructions for lexicon building in autoformalization

When formalizing a text, return two kinds of code as by-product:
- a Dedukti file `myconstants.dk` containing the type signatures of all new constants you introduce
- an Informath symbol table file `myconstants.dkgf` containing lexical annotations of all those constants


Examples:
- .dk: `dist : Nat -> Nat -> Prop.`
- .dkgf: `dist : "X is distinct from Y" | "X and Y are distinct" | $#1 \neq #2$


## More information in other files:

- build_lexicon.md: explain the task in more detail
- baseconstants.dk: examples of Dedukti constants
- verbalconstants.dkgf: symbol table for baseconstants.dk
- words.tsv: English words available for symbol tables



