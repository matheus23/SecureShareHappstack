{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

module GeneratorUtil where

import Data.Char (toLower)
import Control.Monad (forM_)
import Text.Blaze.Html5 (Html, (!), toHtml, toValue)
import Text.Blaze.Html5.Attributes (href, type_, src, rel)
import qualified Text.Blaze.XHtml5 as H
import qualified Text.Blaze.XHtml5.Attributes as A


data TextInputType = Text | Password | Email deriving (Show)

type JsFile = String
type CssFile = String


formLineTemplate :: String -> String -> TextInputType -> Html
formLineTemplate inputDescription inputName inputType = 
  H.tr $ do
    H.td ! A.class_ "rightAlign" $ (toHtml inputDescription)
    H.td $ H.input ! A.type_ inputTypeAttribute ! A.name (toValue inputName) ! A.id (toValue inputName)
  where
    inputTypeAttribute = toValue $ map (toLower) (show inputType)

importTemplate :: [JsFile] -> [CssFile] -> Html
importTemplate jsFiles cssFiles = do
  forM_ cssFiles importCssFile
  forM_ jsFiles importJsFile
  where
    importJsFile jsFile = H.script ! src (toValue jsFile) $ ""
    importCssFile cssFile = H.link ! rel "stylesheet" ! type_ "text/css" ! href (toValue cssFile)

generateHeader :: String -> Html
generateHeader headerString = H.div ! A.id "header" $ H.i $ H.h1 ! A.id "banner" $ (toHtml headerString)

template :: Html -> Html -> Html
template headHtml bodyHtml = 
  H.html $ do
    H.head headHtml
    H.body bodyHtml

submitButton :: String -> Html
submitButton text = H.input ! A.type_ "submit" ! A.value (toValue text)

resetButton :: String -> Html
resetButton text = H.input ! A.type_ "reset" ! A.value (toValue text)