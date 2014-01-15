{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

module Register where

import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.XHtml5 as H
import qualified Text.Blaze.XHtml5.Attributes as A

import GeneratorUtil

registerPage :: Html
registerPage = template headHtml bodyHtml
  where
    headHtml = do
      H.title "Register"
      importTemplate [] ["/static/css/style.css"]
    bodyHtml = do
      generateHeader "SecureShare"
      H.div ! A.style "text-align: center" $ H.h1 "Register Account"
      H.div ! A.style "text-align: center" $
        H.form ! A.style "display: inline-block" $
          H.table $ do
            formLineTemplate "Name:" "name" Text
            formLineTemplate "Email:" "email" Email
            formLineTemplate "Password:" "password" Password
            formLineTemplate "Repeat Password:" "password" Password
            H.tr $ do
              H.td ""
              H.td $ do
                submitButton "Register"
                resetButton "Reset"

