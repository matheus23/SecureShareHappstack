{-# LANGUAGE OverloadedStrings, ScopedTypeVariables, TypeFamilies, DeriveDataTypeable, TemplateHaskell #-}

module Register where

import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.XHtml5 as H
import qualified Text.Blaze.XHtml5.Attributes as A
import Happstack.Lite
import Data.SafeCopy
import Data.Acid
import Data.Text.Lazy (unpack)

import GeneratorUtil
import Messages
import PasswordDB

viewRegisterPage :: [Message] -> Html
viewRegisterPage msgs = template headHtml bodyHtml
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
            formLineTemplate "Repeat Password:" "password_repeat" Password
            H.tr $ do
              H.td ""
              H.td $ do
                submitButton "Register"
                resetButton "Reset"
      (generateMessages msgs)

registerPage :: ServerPart Response
registerPage = msum [ ok $ toResponse $ (viewRegisterPage []), processRegisterPage ]

processRegisterPage :: ServerPart Response
processRegisterPage = do
  method POST
  emailText <- lookText "email"
  passwordText <- lookText "password"
  let email = unpack emailText
  let password = unpack passwordText
  database <- openUserDB
  update database (AddUser (email, password))
  ok $ toResponse $ viewRegisterPage [Message Okay ("Added user with email: " ++ email ++ " to database.")]