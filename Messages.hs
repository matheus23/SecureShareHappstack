{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

module Messages where

import Control.Monad (forM_)
import Text.Blaze.Html5 (Html, AttributeValue, (!), toValue, toHtml)
import qualified Text.Blaze.XHtml5 as H
import qualified Text.Blaze.XHtml5.Attributes as A

data MessageType = Okay | Warning | Error
data Message = Message {
  messageType :: MessageType,
  message :: String
}

iconBasePath = "/static/img/"

iconPath :: MessageType -> String
iconPath Okay    = iconBasePath ++ "accept.png"
iconPath Warning = iconBasePath ++ "warning.png"
iconPath Error   = iconBasePath ++ "error.png"

iconPathClass :: MessageType -> AttributeValue
iconPathClass = toValue . iconPath

messageClass :: MessageType -> AttributeValue
messageClass Okay = "infobox okay"
messageClass Warning = "infobox warnung"
messageClass Error = "infobox fehler"

generateMessage :: Message -> Html
generateMessage msg =
  H.div ! A.class_ (messageClass msgType) $
    H.table $
      H.tr $ do
        H.td ! A.class_ "verticalMid" $
          H.img ! A.src (iconPathClass msgType) ! A.width "16" ! A.height "16"
        H.td ! A.class_ "verticalMid" $
          toHtml (message msg)
  where
    msgType = messageType msg

generateMessageBody :: Html -> Html
generateMessageBody inner = H.div ! A.id "messageList" $ inner

generateMessages :: [Message] -> Html
generateMessages msgs = generateMessageBody $ forM_ msgs generateMessage