# Building a lexicon when autoformalizing


Formalizing a text means translating it to a formal language.
In this process, mathematical terms are translated to constants in the formal language.
We will show the natural language term and its translation separated by `==>`, in the following format
```
  <natural language> ==> <formal language> : <type>
```
Each constant of formal language has a **type**, which is shown separated by `:`.
The type can be a **function type**, which has **argument types** and a **value type**, all separated by `->`.

Using this format, the following translation might happen in arithmetic:
```
  natural number ==> Nat : Type
  zero ==> Zero : Nat
  successor ==> Succ : Nat -> Nat
  sum ==> plus : Nat -> Nat -> Nat
  even ==> Even : Nat -> Prop
  equal ==> Eq : Nat -> Nat -> Prop
  divisible ==> Div : Nat -> Nat -> Prop
```
The mappings from natural language terms to formal constants together form a **lexicon**, which can be applied when translating the same term the next time.
An exception is when the term is **overloaded**, which means that it has different possible formalizations, usually of different types.
Using the types that are correct in the formal language helps **resolve** the overloading.

Now, natural language also has types.
They are called **parts of speech**, such as adjective, noun, and verb.
In addition, natural language terms can take arguments, similarly to function types in the formalism.
We denote this by adding number suffixes to the names of the categories.
Separating the type from the term by `:` also on the natural language side, we enrich the above examples as follows:
```
  natural number : Noun ==> Nat : Type
  zero : Name ==> Zero : Nat
  successor : Fun1 ==> Succ : Nat -> Nat
  sum : FunC ==> plus : Nat -> Nat -> Nat
  even : Adj1 ==> Even : Nat -> Prop
  equal : Adj2 ==> Eq : Nat -> Nat -> Prop
  divisible : Adj2 ==> Div : Nat -> Nat -> Prop
```
Notice that the number suffix of each natural language type is the same as the number of arguments of the formal language constant.
No suffix means no arguments.
FunC means a **collective function**, which can take two or more arguments.

Some more things need to be obeyed when building a lexicon.
One is the match between parts of speech and the value types of formal constants.
There is the following correspondence denoted by `<==>`:
```
 Adj <==> Prop
 Noun <==> Type
 Name <==> Nat
 Fun <==> Nat
```
Another thing is the way in which natural language terms are applied to their arguments.
The arguments can be subjects or objects or prepositional phrases.
We can denote this by using variables `#1`, `#2`, etc, in examples that show the use of each term, similarly to variables in LaTeX macros.
Collective functions FunC use "and" between arguments.
Thus:
```
  natural number : Noun ==> Nat : Type
  the zero : Name ==> Zero : Nat
  the successor of #1 : Fun1 ==> Succ : Nat -> Nat
  the sum of #1 and #2 : Fun2 ==> plus : Nat -> Nat -> Nat
  #1 is even : Adj1 ==> Even : Nat -> Prop
  #1 is equal to #2 : Adj2 ==> Eq : Nat -> Nat -> Prop
  #1 is divisible by #2 : Adj2 ==> Div : Nat -> Nat -> Prop
```
When you give a natural language expression together with is arguments, it is possible to infer the exact natural language type from it by using a parser.

In addition to natural language, mathematical text can contain symbolic expressions.
We assume them to be written in LaTeX in the math environment, enclosed in dollar signes `$` or a math environment such as '\[` ... '\]`.

LaTeX expressions can be mapped to formal language in a way similar to natural language.
Some terms do not have standard LaTeX variant, but some do:
```
  \mathbb{N} ==> Nat : Type
  0 ==> Zero : Nat
  #1 + #2 ==> plus : Nat -> Nat -> Nat
  #1 = #2 ==> Eq : Nat -> Nat -> Prop
  #2 \mid #1 ==> Div : Nat -> Nat -> Prop
```

## The lexicon format

Putting this all together, we can now show the precise format of the lexicon.
It uses formal constants as keys.
They are separated from their values with `:`.
Each key must have at least one value, but it can have many, separated by `|`.
Among the values, natural language terms are enclosed in quotes `"`.
LaTeX symbol values are enclosed in dollars `$`.
Each key-values pair must be one line.

Here is an example, showing the above example in the precise format:
```
  Nat : "natural number" | $\mathbb{N}$
  Zero : "the zero" | $0$
  Succ : "the successor of X"
  sum : "the sum of #1 and #2" | $#1 + #2$
  Even : "#1 is even" 
  Eq : "#1 is equal to #2" | "#1 and #2 are equal" | $#1 = #2$
  Div : "#1 is divisible by #2" | "#2 divides #1" | $#2 \mid #1$
```


## Checking the lexicon

The lexicon is written in a file with suffix `.dkgf`.
It can be checked with respect to a Dedukti file, suffix `.dk`.
The command used for this is
```
RunInformath -base=<formalfile>.dk <lexiconfile>.dkgf
```
The checking may issue errors of the form
```
  cannot parse example: "digt"
```
This means that some natural language word is not in the grammar.
In that case, it is possible to add the word to the grammar and try again.

The checking can also issue warnings:
```
## MISSING IN TABLE: cons
```
means that the formal constant `cons` is not in the lexicon.
This is not fatal: it just means that there is no informal expression available.
```
## MISMATCHING TYPES: positive ("Prop",1) <> AdjPrepAdj2 positive_Adj to_Prep (["Exp","Kind","Prop"],2)
```
This means that the one-place function `positive` has been assigned a two-place adjective.
This error is likely to cause failures at run-time and should be fixed.
However, when the same error happens with LaTeX symbols, they are not fatal.
```
## MISMATCHING TYPES: sqrt ("Exp",1) <> '\\sqrtMACRO' (["Exp","Formula","Kind","Proof","ProofExp","Prop","Term","Unit"],0)
```
So don't care of the errors at the moment.