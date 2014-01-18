{-# LANGUAGE OverloadedStrings, ScopedTypeVariables, TypeFamilies, DeriveDataTypeable, TemplateHaskell #-}

module Register where

import Control.Monad.IO.Class (liftIO)
import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.XHtml5 as H
import qualified Text.Blaze.XHtml5.Attributes as A
import Happstack.Lite
import Data.Acid
import Data.Text.Lazy (unpack)

import GeneratorUtil
import Messages
import PasswordDB

showRegisterPage :: [Message] -> Html
showRegisterPage msgs = template headHtml bodyHtml
  where
    headHtml = do
      H.title "Register"
      importTemplate [] ["/static/css/style.css"]
    bodyHtml = do
      generateHeader "SecureShare"
      H.div ! A.style "text-align: center" $ H.h1 "Register Account"
      H.div ! A.style "text-align: center" $
        H.form ! A.action "/register/process" ! A.method "GET" ! A.style "display: inline-block" $
          H.table $ do
            formLineTemplateTr "Name:" "name" Text
            formLineTemplateTr "Email:" "email" Email
            formLineTemplateTr "Password:" "password" Password
            formLineTemplateTr "Repeat Password:" "password_repeat" Password
            H.tr $ do
              H.td ""
              H.td $ do
                submitButton "Register"
                resetButton "Reset"
      (generateMessages msgs)

registerPage :: ServerPart Response
registerPage = msum [ dir "view" $ viewRegisterPage, dir "process" $ processRegisterPage ]

viewRegisterPage :: ServerPart Response
viewRegisterPage = do
  method GET
  ok $ toResponse $ showRegisterPage []

processRegisterPage :: ServerPart Response
processRegisterPage = do
  emailText <- lookText "email"
  passwordText <- lookText "password"
  let email = unpack emailText
  let password = unpack passwordText
  liftIO $ databaseAdd email password
  ok $ toResponse $ showRegisterPage [Message Okay ("Added user with email: " ++ email ++ " to database.")]

databaseAdd :: Email -> UserInfo -> IO ()
databaseAdd email password = do
  putStrLn $ "Adding user: " ++ email ++ " with password: " ++ password
  database <- openUserDB
  update database (AddUser (email, password))
  closeAcidState database