# More on natural language types


### Syntactic and lexical categories

A majority of Dedukti expressions are function applications (of the form `f x1 ... xn`), which are rendered in a category determined by the symbol table mapping of the function `f`. The resulting informalizations belong to one of the following **syntactic categories** in GF:
```
category   name              linguistic type     example
—-------------------------------------------------------------------------
Exp        expression        NP (noun phrase)    the empty set
Kind       kind              CN (commoun noun)   integer
Prop       proposition       S (sentence)        2 is even
Proof      proof             Text                by Theorem 1, x is prime                 
Term       symbolic term     TermPrec            x + 2
Formula    symbolic formula  TermPrec            x > 2
```
The most intuitive way to adapt Informath to your Dedukti files is by using **example-based symbol table entries**.
The things you need to know are

- the intended **target type** of your Dedukti constant:
  - if its value type in Dedukti is `Prop`, it is `Prop`
  - if its value type in Dedukti is `Set`, it is `Kind`
  - if its value type in Dedukti is `Elem` for some set, it is `Exp`
- its **arity**, i.e. the number of argument it takes (after possibly dropping some initial arguments not to be shown in informal text)

Given this information, you can use the following formats to write symbol table entries:
```
Prop, arity 1:  
    "X is <Adj>" 
  | "X <Verb>s" 
  | "X is a <Noun>"
Prop, arity 2:  
    "X is <Adj> <Prep> Y" 
  | "X and Y are <Adj> 
  | "X <Verb>s <Prep> Y" 
  | "X is a <Noun> <Prep> Y"
  | "X and Y <Verb>" 
  | "X and Y are <Noun>s"
Prop, arity 3: 
    "X is <Adj> <Prep> Y <Prep> Z"

Kind, arity 0: 
    "<Noun>"
Kind, 1 Kind argument (type constructor): 
    "<Noun> <Prep> As"
Kind, 1 Exp argument (dependent type):
  | "<Noun> <Prep> X" 
Kind, 2 Kind arguments: 
    "<Noun> <Prep> As <Prep> Bs" 
Kind, 2 Exp arguments: 
  | "<Noun> <Prep> X <Prep> Y" 
  | "<Noun> <Prep> X and Y"

Exp, arity 0: 
    "the <Noun>"
Exp, arity 1: 
    "the <Noun> <Prep> X"
Exp, arity 2: 
    "the <Noun> <Prep> X <Prep> Y"

Exp, higher order argument x => X (Ident x bound in Exp X): 
    "the <Noun> X of $x$"
Exp, arguments A, x => X (A is a Kind that x ranges over): 
    "the <Noun> of X where $x$ is an A"
Exp, arguments X, Y, x => Z (X and Y are bounds; e.g. sum, integral): 
    "the <Noun> of Z where $x$ ranges from X to Y"
```
For the variables `X`, `Y`, etc, use variable names `#1`, `#2`, etc, which refer to argument positions in the Dedukti expression.


