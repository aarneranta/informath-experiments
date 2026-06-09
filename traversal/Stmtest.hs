
data Tree = Tree String [Tree] deriving Show

type SEnv = (Int, [String])
initSEnv = (0, [])

current (i, s) = show i
next s (i, ss) = (i + 1, s:ss)

condition s = take 1 s == "X"

analyse :: SEnv -> Tree -> (SEnv, Tree)
analyse env t = case t of
  Tree s ts | condition s -> let (nenv, nts) = analyseTrees (next s env) ts in (nenv, Tree (current env) nts)
  Tree s ts               -> let (nenv, nts) = analyseTrees env          ts in (nenv, Tree s nts)
 where
  analyseTrees env ts = case ts of
    t:tt -> let (nenv, nt) = analyse env t
                (nnenv, ntt) = analyseTrees nenv tt
            in (nnenv, nt:ntt)
    _ -> (env, [])

-- Pretty-print a Tree with vertical/horizontal connector lines.
drawTree :: Tree -> String
drawTree t = unlines (draw t)
 where
  draw (Tree s ts) = s : drawForest ts
  drawForest ts = case ts of
    []     -> []
    [t]    -> shift "└─ " "   " (draw t)
    (t:tt) -> shift "├─ " "│  " (draw t) ++ drawForest tt
  shift first other = zipWith (++) (first : repeat other)

ex = Tree "Marc" [Tree "Xavier" [Tree "Xerxes" [], Tree "Anne" []], Tree "Jean" [], Tree "Xar" []]

-- 20 nodes at varying depths, 6 of which start with "X".
ex2 = Tree "Root"
  [ Tree "Xena"
      [ Tree "Alice" [Tree "Xerxes" [], Tree "Bob" []]
      , Tree "Xander" [Tree "Carol" []] ]
  , Tree "David"
      [ Tree "Eve" [], Tree "Xenon" [Tree "Frank" []] ]
  , Tree "Grace"
      [ Tree "Xiomara" [Tree "Heidi" [], Tree "Ivan" []]
      , Tree "Judy" [] ]
  , Tree "Xindu" [Tree "Karl" [], Tree "Leo" []]
  , Tree "Mallory" [] ]

main = do
  putStr $ drawTree ex
  putStrLn ""
  putStr $ drawTree $ snd $ analyse initSEnv ex
  putStrLn ""
  putStr $ drawTree ex2
  putStrLn ""
  putStr $ drawTree $ snd $ analyse initSEnv ex2

