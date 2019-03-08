{-# LANGUAGE PackageImports #-}

module Main where

import qualified "documents" Lib

main :: IO ()
main = Lib.run
