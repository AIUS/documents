module Lib
  ( run
  , convertMeta
  , extractDocument
  )
where

import           System.Directory.Tree          ( readDirectoryWith
                                                , DirTree(..)
                                                , AnchoredDirTree((:/))
                                                , flattenDir
                                                , zipPaths
                                                )
import           Text.Pandoc
import           Text.Pandoc.Extensions         ( getDefaultExtensions )
import           Text.Pandoc.Readers            ( readMarkdown )
import           Text.Pandoc.Writers            ( writePlain )
import           Text.Pandoc.Builder
import           Text.Blaze.Html                ( Html
                                                , toHtml
                                                )
import           Data.List
import           Data.Maybe
import qualified Data.Map                      as M
import qualified Data.Text                     as T
import qualified Data.Text.IO                  as TIO

filterMarkdown :: DirTree a -> Bool
filterMarkdown (File n _) = ".md" `isSuffixOf` n
filterMarkdown _          = False

opts :: ReaderOptions
opts = def { readerExtensions = getDefaultExtensions "markdown" }

data Document = Document { path :: FilePath
                         , title :: Maybe Html
                         , subtitle :: Maybe Html
                         , date :: Maybe Html
                         , authors :: [Html]
                         , tags :: [Html]
                         , pandoc :: Pandoc
                         }

extractDocument :: PandocMonad m => FilePath -> Pandoc -> m Document
extractDocument path (Pandoc meta a) = do
  title    <- extractMeta "title" meta
  subtitle <- extractMeta "subtitle" meta
  date     <- extractMeta "date" meta
  authors  <- extractMetaList "author" meta
  tags     <- extractMetaList "tags" meta
  return $ Document path title subtitle date authors tags (Pandoc meta a)

convertMeta :: PandocMonad m => MetaValue -> m (Maybe Html)
convertMeta (MetaString  s) = return $ Just $ toHtml s
convertMeta (MetaInlines i) = do
  res <- inlinesToString $ fromList i
  return $ Just res
convertMeta (MetaBlocks b) = do
  res <- blocksToString $ fromList b
  return $ Just res
convertMeta _ = return Nothing

extractMetaList :: PandocMonad m => String -> Meta -> m [Html]
extractMetaList key (Meta m) = case M.lookup key m of
  Just (MetaList l) -> do
    list <- mapM convertMeta l
    return $ catMaybes list
  Just m -> do
    meta <- convertMeta m
    return $ maybeToList meta
  _ -> return []

extractMeta :: PandocMonad m => String -> Meta -> m (Maybe Html)
extractMeta key (Meta m) = case M.lookup key m of
  Just m  -> convertMeta m
  Nothing -> return Nothing

pandocToString :: PandocMonad m => Pandoc -> m Html
pandocToString p = do
  res <- writeHtml5 def p
  return res

blocksToString :: PandocMonad m => Blocks -> m Html
blocksToString b = pandocToString $ doc b

inlinesToString :: PandocMonad m => Inlines -> m Html
inlinesToString i = blocksToString $ plain i


run :: IO ()
run = do
  tree <- readDirectoryWith readFile "."
  let files = filter filterMarkdown $ flattenDir $ zipPaths tree
  pandocs <- mapM
    (\(File _ (path, c)) -> runIO $ do
      doc <- (readMarkdown opts $ T.pack c)
      extractDocument path doc
    )
    files
  docs <- handleError $ sequence pandocs
  mapM_ (print . pandoc) docs
