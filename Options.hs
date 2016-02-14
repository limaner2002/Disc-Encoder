module Options where

import Prelude ()
import ClassyPrelude hiding ((<>))

import Options.Applicative

data Options = Options
    { input :: FilePath
    , output :: FilePath
    , title :: Int
    , subtitle :: Maybe [Int]
    , forced :: Bool
    , noCrop :: Bool
    , path :: FilePath
    , startAt :: Maybe Int
    , stopAt :: Maybe Int
    , pixelAspect :: Maybe (Int, Int)
    } deriving Show

parseArgs :: Parser Options
parseArgs =
    Options
      <$> (strOption $ long "input"
                     <> short 'i'
                     <> help "The path to the input source"
          )
      <*> (strOption $ long "output"
                     <> short 'o'
                     <> help "The path to the resulting output file"
          )
      <*> (option auto $ long "title"
                      <> short 't'
                      <> help "The title number to process"
          )
      <*> (optional $ option auto $ long "subs"
                        <> short 's'
                        <> help "Only display subtitles from the selected stream <string> if\
                                \ the subtitle has the forced flag set. The values in\
                                \ \"string\" are indexes into the subtitle list\
                                \ specified with '--subtitle'.\
                                \ Separated by commas for more than one subtitle track.\
                                \ Example: \"1,2,3\" for multiple tracks."
          )
      <*> (flag False True $ long "forced" <> short 'f')
      <*> (flag False True $ long "no-crop" <> short 'n')
      <*> (option auto $ value "/Applications/HandBrakeCLI"
                      <> long "command"
                      <> short 'c'
                      <> help "The path to the version of handbrake to use"
          )
      <*> (optional $ option auto $ long "start-at"
                                 <> help "Start encoding at a given frame, duration (in seconds), or pts (on a 90kHz clock)"
          )
      <*> (optional $ option auto $ long "stop-at"
                                 <> help "Stop encoding at a given frame, duration (in seconds), or pts (on a 90kHz clock)"
          )
      <*> (optional $ option auto $ long "pixel-aspect" <> short 'a')

opts :: ParserInfo Options
-- opts = info (parseArgs <**> helper) idm
opts = info (helper <*> parseArgs) $ mconcat [
         fullDesc
       , header "The Handbrake wrapper"
       , progDesc "Wraps the options for Handbrake CLI"
       , footer "Report bugs to myself :-)"
       ]

