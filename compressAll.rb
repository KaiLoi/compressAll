#!/usr/bin/env ruby

########################################################################################
########################################################################################
## compressAll.rb : A simple program to take a directory and a file extension type then
## recurse throguh the directory and all subdirectiories bzip2ing all files it finds 
## that match the defined extension. Originally written to compress
## old CDRS.
## 
## Usage : compressAll.rb -d /directory/to/files/and/recurse -e txt
##
## Written by Sebastian Kai Frost : 02/08/2017

require 'optparse'
require 'find'

ARGV << '-h' if ARGV.empty?

## Start Methods ## 

## Method to get command line arguments, make sure they are correct and return them.
def parseOpts

  dir = nil
  ext = nil
  # run through and parse the command line options
  OptionParser.new do |opt|
    opt.on('-d', '--directory DIRECTORY') { |o| dir = o }
    opt.on('-e', '--extension EXTENSION') { |o| ext = o }
  end.parse!
  # if both required options aren't defiend tell the user so. 
  Kernel.abort("\n## Missing command line element -d ##\n\n") if !dir
  Kernel.abort("\n## Missing command line element -e ##\n\n") if !ext
  # lets just check as well to make sure they defiend a real dir.
  Kernel.abort("\n## Directory doesn't exist! Please try again ## \n\n") if !File.directory?(dir)
  return dir, ext

end

## Small method to prompt the user to make sure they really really want to do this. 
def getSure(dir, ext)

  print "\n## You have selected to recursivly compress all files under #{dir} with the extension #{ext}\n## Are you sure? (y/n):";
  sel = $stdin.gets.chomp
  if sel == "y"
    return 1
  elsif sel  == "n"
    return nil
    # return nothing to abort
  else 
    print "Unknown entry, aborting\n"
    return nil
  end

end

## Small method that rips through defined dirs and grabs list of files.
def getFiles(dir, ext)

  files = []
  print "-> Collecting list of files to compress.\n";
  Find.find(dir) do |path|
    files << path if path =~ /.*\.#{ext}$/
  end
  print "-> Done\n";
  return files

end

## Method to compress all files in the file and tell you
def compressFiles(files)
  
  print "-> Starting compression\n"
  files.each do |file|
    puts "--> Compressing file: #{file}"
    system("gzip #{file}")
  end
  print "-> Done!\n\n"

end

## End Methods ## 

## EXECUTION ## 

dir, ext = parseOpts
if getSure(dir, ext)
  allfiles = getFiles(dir, ext)
  compressFiles(allfiles)
else 
  print "Aborted\n";
end

## END OF LINE ##
