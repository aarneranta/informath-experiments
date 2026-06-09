-- State-monad versions of analyse. The monad STM is parameterised over
-- the state type s, so the two variants below can share it:
--   * analyseT :: Tree -> STM SEnv Tree   -- tree is the result, env is the state
--   * analyseS :: STM SState ()           -- tree lives *in* the state

data Tree = Tree String [Tree] deriving (Show, Eq)

type SEnv = (Int, [String])
initSEnv = (0, [])

current (i, s) = show i
next s (i, ss) = (i + 1, s:ss)

condition s = take 1 s == "X"

-- A state monad polymorphic in the state s: a function s -> (a, s).
newtype STM s a = STM { runSTM :: s -> (a, s) }

instance Functor (STM s) where
  fmap f (STM g) = STM $ \s -> let (a, s') = g s in (f a, s')

instance Applicative (STM s) where
  pure a = STM $ \s -> (a, s)
  STM f <*> STM g = STM $ \s ->
    let (h, s')  = f s
        (a, s'') = g s'
    in (h a, s'')

instance Monad (STM s) where
  return = pure
  STM g >>= f = STM $ \s -> let (a, s') = g s in runSTM (f a) s'

get :: STM s s
get = STM $ \s -> (s, s)

put :: s -> STM s ()
put s = STM $ \_ -> ((), s)

evalSTM :: STM s a -> s -> a
evalSTM m s = fst (runSTM m s)

execSTM :: STM s a -> s -> s
execSTM m s = snd (runSTM m s)


-- Variant 1: the tree is the RESULT, the SEnv is the state. -----------------

analyseT :: Tree -> STM SEnv Tree
analyseT (Tree s ts)
  | condition s = do
      env <- get
      put (next s env)
      ts' <- mapM analyseT ts
      return (Tree (current env) ts')
  | otherwise = do
      ts' <- mapM analyseT ts
      return (Tree s ts')

analysedT :: Tree -> Tree
analysedT t = evalSTM (analyseT t) initSEnv


-- Variant 2: the tree lives IN the state, analyse returns (). ---------------
-- The state pairs the SEnv with the tree currently in focus. The traversal
-- mutates that single tree cell in place: to recurse into a child we drop the
-- child into the cell, run analyseS, then read the transformed child back.

type SState = (SEnv, Tree)

getEnv :: STM SState SEnv
getEnv = do (env, _) <- get; return env

putEnv :: SEnv -> STM SState ()
putEnv env = do (_, t) <- get; put (env, t)

getTree :: STM SState Tree
getTree = do (_, t) <- get; return t

putTree :: Tree -> STM SState ()
putTree t = do (env, _) <- get; put (env, t)

analyseS :: STM SState ()
analyseS = do
  Tree s ts <- getTree
  lab <- if condition s
           then do env <- getEnv
                   putEnv (next s env)
                   return (current env)
           else return s
  ts' <- mapM focus ts
  putTree (Tree lab ts')
 where
  -- The "focus dance". The state holds only ONE tree cell, so it has no
  -- notion of "which subtree am I at". To analyse a child we therefore:
  --   1. putTree c  -- move the child into the single tree cell
  --   2. analyseS   -- transform whatever is in the cell (returns ()),
  --                 --   threading the SEnv counter/stack as a side effect
  --   3. getTree    -- read the transformed child back out of the cell
  -- mapM focus then sequences this over the siblings, so the SEnv flows
  -- left-to-right while each child is swapped through the cell in turn.
  -- This save/recurse/restore is exactly the plumbing that the STM Tree
  -- variant avoids by letting the subtree simply BE the return value.
  focus c = do putTree c
               analyseS
               getTree

analysedS :: Tree -> Tree
analysedS t = let (_, t') = execSTM analyseS (initSEnv, t) in t'


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

report :: Tree -> IO ()
report t = do
  putStrLn "-- original"
  putStr $ drawTree t
  putStrLn ""
  putStrLn "-- analysed (STM Tree)"
  putStr $ drawTree $ analysedT t
  putStrLn ""
  putStrLn "-- analysed (STM (), tree in state)"
  putStr $ drawTree $ analysedS t
  putStrLn $ "-- both variants agree: " ++ show (analysedT t == analysedS t)
  putStrLn ""

main = do
  report ex
  report ex2
