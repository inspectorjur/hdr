#!/usr/bin/perl -w
##
##   Copyright (C) 2006 Mario Theodoridis, mario@schmut.com
##
##   This "Original Work" is free; you can modify it under the terms of the
##   AFL Academic Free License. This "Original Work" is distributed in the
##   hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
##   implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
##   See the AFL Academic Free License for more details. You should find a
##   copy of the AFL Academic Free License in the highest level directory of
##   this distribution; if not, you may obtain one at the Open Source
##   Initiative, http://www.opensource.org.
##

use strict;
use Getopt::Std;

my $hOpts = {};
my $isOk = getopts('i:o:', $hOpts);

my $inPath = $hOpts->{'i'};
my $outPath = $hOpts->{'o'};

if (!$isOk || !$inPath || !$outPath) {
    print <<EOF;

    Auto levels the colors of all images specified in the input file mask
    and saves them in the output directory creating the directory if needed.

    Usage $0 -i "Input Path" -o "Output Directory"

EOF

    exit;
}

if (-f $outPath) {
	print <<TXT;

    $outPath exists and is not a directory. Please specify a directrory or
    something that doesn't exist already, so i can create it.

TXT
	exit 1;
}

my $aList = getFileList($inPath);

mkdir ($outPath) unless (-d $outPath);

foreach my $inFile (@$aList) {
	my $pUrl = parseUrl($inFile);
	my $file = $pUrl->{'NAME'}.$pUrl->{'DOTEXT'};
	my $outFile = getNormalizedFsPath("$outPath/$file");
	if ( -f $outFile) {
		print ("Skipping existing file $outFile. Please remove it to have it redone.\n");
		next;
	}
	print "Moving $inFile to $outFile\n";
	`gimp -i -b '(script-fu-batch-level "$inFile" "$outFile")' -b '(gimp-quit 0)'`;
}


#
# Some utilities
#

# a list of files without directories
# getFileList( path )
sub getFileList
{
    my $path = shift;
    my $fileList = `ls -1p $path`;
    # get rid directory entries
    $fileList =~ s#^.*/$##m;
    my @files = split(/[\r\n]+/, $fileList);
    return \@files;
}

#
# Parses a url and returns an array of relevant pieces.
# @param $src      source path for the image
#
sub parseUrl # (  $src )
{
    my $src = shift;
    $src =~ /^(?:(\w+:\/\/)([^\/\?]+))?([^?#]*\/)*(.*?)(\.(.*?))?(\?.*?)?(#.*)?$/;
    return {
            'SRC'       => $src,
            'PROTO'     => $1,
            'HOST'      => $2,
            'PATH'      => $3,
            'NAME'      => $4,
            'DOTEXT'    => $5,
            'EXT'       => $6,
            'PARAMS'    => $7,
            'ANCHOR'    => $8,
            };
}

sub getNormalizedFsPath # ($path)
{
    my $path = shift;
    my $expr = '(/[^\/]*?/\.\./|/\./|(?<!:)//)';
    while ($path =~ m&$expr&g) {
        $path =~ s&$expr&/&g;
    }
    return $path;
}
