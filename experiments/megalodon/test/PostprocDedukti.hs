{-# LANGUAGE GADTs, KindSignatures, DataKinds #-}
{-# LANGUAGE LambdaCase #-}

-- check syntax errors in Dedukti judgements line by line
-- usage: runghc CheckDeduktiSyntax.hs <test/exx.dk | grep ERROR

module Main where

import Dedukti.ParDedukti
import Dedukti.PrintDedukti
import Dedukti.AbsDedukti

import Dedukti.ErrM

main = interact postprocDeduktiModule

postprocDeduktiModule :: String -> String
postprocDeduktiModule s = case pModule (myLexer s) of
  Ok (MJmts jmts) -> unlines (map (printTree . postproc) jmts)
  Bad s -> s


postproc :: Tree a -> Tree a
postproc t = case t of
  EApp (EApp (EIdent (QIdent "arr")) x) y -> EFun (HExp (postproc x)) (postproc y)
  EApp (EIdent (QIdent "Elem")) x -> postproc x
  EApp (EIdent (QIdent "pf")) x -> postproc x
  _ -> composOp postproc t


--main = interact (unlines . map parseDeduktiJmt . filter (not . null) . lines)

parseDeduktiJmt :: String -> String
parseDeduktiJmt s = do
  case pJmt (myLexer s) of
    Bad e -> "ERROR: " ++ s
    Ok mo -> "OK: " ++ s

