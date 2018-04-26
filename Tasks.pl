#!/usr/bin/perl
#User: Samantha Sevilla

use strict;
use warnings;
use Cwd;
use CPAN;
use File::chdir;
use File::Copy;
use File::Find;
######################################################################################
								##NOTES##
######################################################################################
##This script is for commonly used tasks



######################################################################################
								##Main Code##
######################################################################################
#Initialize
my @names; my $n=1;

#Standard input from CML
print "What would you like to do?\n";
print "1) Grep all files in directory?\n";
print "2) Create copies of a file\n";
print "3) Rename files\n";
print "4) Rename folders (in order)\n";
print "5) Add a prefix to a previous file name\n";
print "6) Renames directory based on file input\n\n";

my $ans = <STDIN>; chomp $ans;

if ($ans==1){
	print "What is the full directory:";
		my $dir = <STDIN>; chomp $dir;

	filename($dir);
} elsif($ans==2){
	my @names;
	print "What is the full directory:";
		my $dir = <STDIN>; chomp $dir;
	print "What is the old file name:";
		my $old = <STDIN>; chomp $old;
	print "How many files do you want to create:";
		my $num= <STDIN>; chomp $num;
	until ($n>$num){
		print "What is the new file name:";
		my $tempname=<STDIN>; chomp $tempname;
		push (@names, $tempname);
		$n++;
	}
	copyfile(\@names,$dir,$old,$num);
} elsif($ans==3){
	print "What is the full directory\n";
		my $dir = <STDIN>; chomp $dir;
	print "What do you want to search for in name?\n";
		my $search = <STDIN>; chomp $search;
	print "What do you want to replace in name?\n";
		my $replace = <STDIN>; chomp $replace;
	changenamefile($dir, $search, $replace);
} elsif($ans==4){
	print "What is the full directory\n";
		my $dir = <STDIN>; chomp $dir;
	print "What do you want the folder name to be?\n";
		my $name = <STDIN>; chomp $name;
	print "How many folders to create\n";
		my $number = <STDIN>; chomp $number;
	createnewfolders($dir, $name, $number);
} elsif($ans==5){
	print "What is the full directory\n";
		my $dir = <STDIN>; chomp $dir;
	print "What prefix do you want to add?\n";
		my $prefix = <STDIN>; chomp $prefix;
	addprefix($dir, $prefix);
} elsif($ans==6){
	print "Where is your file?\n";
		my $dir = <STDIN>; chomp $dir; 
	print "What is the name of the file?\n";
		my $file = <STDIN>; chomp $file;
	renamedirect($dir,$file);
}
#####################################################################
								##Subroutines##
######################################################################################
#This subroutine prints the files in given directory to the home screen
sub filename{
   my ($dir)=@_;

    opendir(DIR, $dir) or die $!;
    while (my $file = readdir(DIR)) {
		print "$file\n";
	}
    closedir(DIR);
}

sub copyfile{
	my ($names, $dir, $old, $num)=@_;
	my $n=0;
	
	opendir(DIR, $dir) or die $!;
	
	foreach my $file(@$names){
		my $new_name=$$names[$n];
		print "name done $new_name\n";
		# perl file copy with the die operator
		copy($old, $new_name) or die "The copy operation failed: $!";
		$n++;
	}
	closedir(DIR);
}

sub changenamefile{
	my ($dir, $search, $replace)=@_;
	my $newfile;
    my @saved;
	
	opendir(DIR, $dir) or die $!;
    while (my $file = readdir(DIR)) {
		push (@saved, $file);
	}
	
	foreach my $file (@saved) {
		$newfile=$file;
		$newfile =~ s/$search/$replace/g;
		rename ("$dir\\$file", "$dir\\$newfile/");
	}
    closedir(DIR);
}

sub createnewfolders{
	my ($dir, $name, $number)=@_;
	my $n=1; my $fullpath;
	
	until($n>$number){
		$fullpath = $dir;
		$fullpath .= "\\";
		$fullpath .= $name;
		$fullpath .= $n;
		mkdir($fullpath);
		$n++;
	}
}

sub addprefix{
my ($dir, $prefix)=@_;
	my $newfile;
    my @saved;
	
	opendir(DIR, $dir) or die $!;
    while (my $file = readdir(DIR)) {
		push (@saved, $file);
	}
	
	foreach my $file (@saved) {
		$newfile=$prefix;
		$newfile.=$file;
		rename ("$dir\\$file", "$dir\\$newfile/");
	}
    closedir(DIR);
}

sub renamedirect{
	my ($dir, $file)=@_;
	my @data; 
	my @full_dir; my @old_fold; my @new_fold;
	my $n=0;

	$CWD = $dir;
	open(READ_FILE, $file) or die $!;
	
	#Take in data, remove header row
	@data = <READ_FILE>;
	shift(@data);

	#Sort through new and old directories
	foreach (@data) {
		my @columns = split('\t',$_);
		if(length $columns[1]>0){
			push(@full_dir, $columns[0]);
			push(@old_fold, $columns[1]);
			push(@new_fold, $columns[2]);
		} else {next;}
	}
	
	foreach(@full_dir){
		
		#Change working directory
		$CWD=$full_dir[$n]; 
		
		#Edit the directories
		my $current = "Sample_"; $current .= $old_fold[$n]; chomp $current;
		my $replace = "Sample_"; $replace .= $new_fold[$n]; chomp  $replace;
		rename ("$current", "$replace/");
		$n++;
	}
}