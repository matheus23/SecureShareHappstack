{-# LANGUAGE TypeFamilies, DeriveDataTypeable, TemplateHaskell #-}
module PasswordDB where

import Data.Acid

import Control.Monad.State (get, put)
import Control.Monad.Reader (ask)
import Data.SafeCopy
import qualified Data.Map as M (Map, lookup, insert, empty)

type Email = String
-- data UserInfo = UserInfo { passwordHash :: String }
type UserInfo = String
data Database = Database !(M.Map Email UserInfo)
type User = (Email, UserInfo)

-- $(deriveSafeCopy 0 'base ''UserInfo)
$(deriveSafeCopy 0 'base ''Database)

addUser :: User -> Update Database ()
addUser (email, info) = do
  Database users <- get
  put $ Database (M.insert email info users)

getUserInfo :: Email -> Query Database (Maybe UserInfo)
getUserInfo email = do
  Database users <- ask
  return $ M.lookup email users

$(makeAcidic ''Database ['addUser, 'getUserInfo])

openUserDB :: IO (AcidState Database)
openUserDB = openLocalStateFrom "users/" (Database M.empty)