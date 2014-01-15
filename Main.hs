{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

module Main where

import Control.Monad (forM_)
import Control.Applicative ((<$>), optional)
import Data.Maybe (fromMaybe)
import Data.Text (Text)
import Data.Text.Lazy (unpack)
import Happstack.Lite
import Text.Blaze.Html5 (Html, (!), a, p, toHtml, toValue)
import Text.Blaze.Html5.Attributes (href, type_, src, rel)
import qualified Text.Blaze.XHtml5 as H
import qualified Text.Blaze.XHtml5.Attributes as A


type JsFile = String
type CssFile = String

banner :: String
banner = "SecureShare"

serverConf :: ServerConfig
serverConf = defaultServerConfig { port = 8080 }

main :: IO ()
main = serve (Just serverConf) pages

pages :: ServerPart Response
pages = msum [
    dir "static" $ serveDirectory DisableBrowsing [] "./public",
    dir "register" $ register,
    homePage
  ]

register :: ServerPart Response
register = ok $ template headHtml bodyHtml
  where
    headHtml = do
      H.title "Register"
      importTemplate [] ["/static/css/style.css"]
    bodyHtml = do
      generateHeader banner
      p "helloooo"

importTemplate :: [JsFile] -> [CssFile] -> Html
importTemplate jsFiles cssFiles = do
  forM_ cssFiles importCssFile
  forM_ jsFiles importJsFile
  where
    importJsFile jsFile = H.script ! src (toValue jsFile) $ ""
    importCssFile cssFile = H.link ! rel "stylesheet" ! type_ "text/css" ! href (toValue cssFile)

generateHeader :: String -> Html
generateHeader headerString = H.div ! A.id "header" $ H.h1 ! A.id "banner" $ (toHtml headerString)

template :: Html -> Html -> Response
template headHtml bodyHtml = toResponse $
  H.html $ do
    H.head headHtml
    H.body bodyHtml

homePage :: ServerPart Response
homePage = ok $
  template (H.title "Homepage") $ do
    H.h1 "Hello!"
    H.p "Writing applications with happstack-lite is fast and simple!"
    H.p "Check out these killer apps."
    H.p $ a ! href "/echo/secret%20message"  $ "echo"
    H.p $ a ! href "/query?foo=bar" $ "query parameters"
    H.p $ a ! href "/form"          $ "form processing"
    H.p $ a ! href "/fortune"       $ "(fortune) cookies"
    H.p $ a ! href "/files"         $ "file serving"
    H.p $ a ! href "/upload"        $ "file uploads"