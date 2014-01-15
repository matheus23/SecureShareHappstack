{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

module Main where

import Happstack.Lite
import Register

serverConf :: ServerConfig
serverConf = defaultServerConfig { port = 8080 }

main :: IO ()
main = serve (Just serverConf) pages

pages :: ServerPart Response
pages = msum [
    dir "static" $ serveDirectory DisableBrowsing [] "./public",
    dir "register" $ ok $ toResponse $ registerPage,
    defaultPage
  ]

defaultPage :: ServerPart Response
defaultPage = notFound $ toResponse ()