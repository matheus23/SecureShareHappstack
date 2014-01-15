module Paths_Webserver (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/philipp/.cabal/bin"
libdir     = "/home/philipp/.cabal/lib/x86_64-linux-ghc-7.6.3/Webserver-0.1.0.0"
datadir    = "/home/philipp/.cabal/share/x86_64-linux-ghc-7.6.3/Webserver-0.1.0.0"
libexecdir = "/home/philipp/.cabal/libexec"
sysconfdir = "/home/philipp/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Webserver_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Webserver_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "Webserver_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Webserver_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Webserver_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
