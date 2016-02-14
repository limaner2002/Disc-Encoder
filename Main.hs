{-# LANGUAGE OverloadedStrings #-}

import Options
import Options.Applicative (execParser)

import Prelude ()
import ClassyPrelude
import Data.List.Split (splitOn)
import System.Process

buildCommand :: Options -> [String]
buildCommand opts =
       baseOpts
    <> fileIn
    <> fileOut
    <> discTitle
    <> subs
    <> forcing
    <> crop
    <> start
    <> stop
    <> aspect
    where
      baseOpts = splitOn " " "-f mp4 --large-file -O -e x264 $width -b 5000 -E ca_aac -B 256 -2"
      fileIn = ["-i", input opts]
      fileOut = ["-o", output opts]
      discTitle = ["-t", show $ title opts]
      subs = case subtitle opts of
               Nothing -> mempty
               Just tracks -> map show tracks
      forcing = case forced opts of
                  False -> mempty
                  True -> ["-F"]
      crop = case noCrop opts of
               False -> mempty
               True -> ["--crop 0:0:0:0"]
      command = [show $ path opts]
      start = case startAt opts of
                  Nothing -> mempty
                  Just time -> ["--start-at", show time]
      stop = case stopAt opts of
               Nothing -> mempty
               Just time -> ["--stop-at", show time]
      aspect = case pixelAspect opts of
                 Nothing -> mempty
                 Just (width,height) -> ["--pixel-aspect", show width <> ":" <> show height]

main :: IO ()
main = do
  args <- execParser opts
  let cmd = buildCommand args
  _ <- createProcess (proc (path args) cmd)
  putStrLn "Done!"
