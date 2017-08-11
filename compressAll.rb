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

## Globals ##
$OPTIONS = Hash.new
$FILES = Array.new

## start Methods ## 

def parseOpts

  # run through and parse the command line options
  $OPTIONS = {}
  OptionParser.new do |opt|
    opt.on('-d', '--directory DIRECTORY') { |o| $OPTIONS[:dir] = o }
    opt.on('-e', '--extension EXTENSION') { |o| $OPTIONS[:ext] = o }
  end.parse!
  # if both required options aren't defiend tell the user so. 
  Kernel.abort("\n## Missing command line element -d ##\n\n") if $OPTIONS[:dir].nil?
  Kernel.abort("\n## Missing command line element -e ##\n\n") if $OPTIONS[:ext].nil?
  # lets just check as well to make sure they defiend a real dir.
  Kernel.abort("\n## Directory doesn't exist! Please try again ## \n\n") if !File.directory?($OPTIONS[:dir])

end

## Small method to prompt the user to make sure they really really want to do this. 
def getSure

  print "\n## You have selected to recursivly compress all files under #{$OPTIONS[:dir]} with the extension #{$OPTIONS[:ext]}\n## Are you sure? (y/n):";
  sel = $stdin.gets.chomp
  if sel == "y"
    return 1
  elsif sel  == "n"
    return 0
    # return nothing to abort
  else 
    print "Unknown entry, aborting\n"
    return 0
  end

end

## Small method that rips through defined dirs and grabs list of files.
def getFiles

  print "-> Collecting list of files to compress.\n";
  Find.find($OPTIONS[:dir]) do |path|
    $FILES << path if path =~ /.*\.#{$OPTIONS[:ext]}$/
  end
  print "-> Done\n";

end

## Method to compress all files in the file and tell you
def compressFiles
  print "-> Starting compression\n"
  $FILES.each do |file|
    puts "--> Compressing file: #{file}"
    # ick! System. BUt is pretty quick. 
    system("gzip #{file}")
  end
  print "-> Done!\n\n"

  ## if we want to do it properly then it would be like this.. but %$^&$ no bzip2 support nativly. 
  #orig = 'hurrah.txt'
  #Zlib::GzipWriter.open('hurrah.txt.gz') do |gz|
  #gz.mtime = File.mtime(orig)
  #gz.orig_name = orig
  #gz.write IO.binread(orig)
  #end

end

## End Methods ## 

## execution ## 

parseOpts
if getSure == 1
  getFiles
  compressFiles
else 
  print "Aborted\n";
end


## End of line ##
