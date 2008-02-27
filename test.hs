import qualified Text.XML.Expat.IO as EIO
import Text.XML.Expat.Stream
import qualified Text.XML.Expat.Tree as ETree
import Data.Tree

main_eio doc = do
  parser <- EIO.newParser Nothing
  EIO.setStartElementHandler parser startElement
  EIO.parse parser doc True
  putStrLn "ok"
  where
  startElement name attrs = putStrLn $ show name ++ " " ++ show attrs

main_stream doc = do
  let handlers = defaultHandlers {startElementHandler=Just startElement}
  case parse Nothing handlers doc [] of
    Left ()    -> putStrLn "parse error"
    Right tags -> print tags
  where
  startElement tag attrs st = st ++ [tag]

main_tree doc = do
  let etree = ETree.parse Nothing doc
  --let dtree = toDTree etree
  --putStrLn (drawTree dtree)
  etree `seq` putStrLn "ok"
  where
  toDTree (ETree.Element name attrs kids) =
    Node ("<" ++ name ++ " " ++ show attrs ++ ">") (map toDTree kids)
  toDTree (ETree.Text str) = Node (show str) []

main = do
  let doc = "<foo baz='bah'><bar/><text>some &amp; text</text></foo>"
  xml <- readFile "test.xml"
  main_eio xml
