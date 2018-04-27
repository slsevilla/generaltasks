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
### 1) Greps file in either a single directory, or multiple directories based off a file input, with directories listed.
####   Gives users the option to search for one specfic file type
### 2) Creates multiple copies of a single file, based on user input of the number of files.
### 3) Renames files based on user input
### 4) Renames folders in order, based on user input
### 5) Add a prefix to a previous file name
### 6) Renames directories, based off of user input file

######################################################################################
								##Main Code##
######################################################################################
#Initialize
my @names; my $n=1;

#Standard input from CML
print "What would you like to do?\n";
print "1) Grep all files in a directory or multiple directories\n";
print "2) Create copies of a file\n";
print "3) Rename files\n";
print "4) Rename folders (in order)\n";
print "5) Add a prefix to a previous file name\n";
print "6) Renames directory based on file input\n\n";

my $ans = <STDIN>; chomp $ans;

if ($ans==1){
	print "Do you want to:\n";
		print "  1) Grep the files in one directory?\n";
		print "  2) Grep the files in multiple directories (input file)\n\n";
		my $ans2 = <STDIN>; chomp $ans2;
	filename($ans2);
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
	} copyfile(\@names,$dir,$old,$num);
} elsif($ans==3){
	print "Which do you want?\n";
		print "  1) Only change 1 directory file\n";
		print "  2) Input a file to change multiple directory files\n\n";
	my $ans2 = <STDIN>; chomp $ans2;
	changenamefile($ans2);
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
#####################################################################
								##Subroutines##
######################################################################################
#This subroutine prints the files in given directory to the home screen
sub filename{
   my ($ans2)=@_;
   my @data;	
   
   if($ans2==1){
		print "Which directory do you want to grep\n?";
			my $dir = <STDIN>; chomp $dir;
			
		opendir(DIR, $dir) or die $!;
		while (my $file = readdir(DIR)) {
			print "$file\n";
		} closedir(DIR);
	} else{
		
		#Determine the location and name of the file
		print "What directory is your file in?\n";
			my $dir = <STDIN>; chomp $dir; 
			#my $dir = "T:\\DCEG\\CGF\\Laboratory\\Projects\\MR-0084\\NP0084-MB4\\Notes\\UpdatedDirectories"; ###Testing
		print "What is the name of the file?\n";
			my $file = <STDIN>; chomp $file;
			#my $file = "Inputfile_Grepfiles.txt"; ###Testing
		print "What type of file are you searching for?\n";
			my $search = <STDIN>; chomp $search;
			#my $search = ".gz"; ###Testing

		#Move to the location of the file
		$CWD = $dir;
		
		#Take in data, remove header row
		open(READ_FILE, $file) or die $!;
		@data = <READ_FILE>;
		shift(@data);

		#Open each directory and print the files based on input search
		for my $line (@data){
			chomp $line;
			$CWD = $line;
			
			opendir(DIR, $line) or die $!;
			while (my $file = readdir(DIR)) {
				if($file =~ /$search/){
					print "$file\n";
				} else{next;}
			}
			closedir(DIR);
		}
	}
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
	my ($ans2)=@_;
	my $newfile; my @saved;
	my @old_file; my @new_file;
	my $n=0; my @data; my @full_dir;
	
	if($ans2==1){
		#Determine the location and file information
		print "What is the full directory\n";
			my $dir = <STDIN>; chomp $dir;
		print "What do you want to search for in name?\n";
			my $search = <STDIN>; chomp $search;
		print "What do you want to replace in name?\n";
			my $replace = <STDIN>; chomp $replace;
			
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
	} else{
		#Determine the location and name of the file
		print "Where is your file?\n";
			my $dir = <STDIN>; chomp $dir; 
			#my $dir = "T:\\DCEG\\CGF\\Laboratory\\Projects\\MR-0084\\NP0084-MB4\\Notes\\UpdatedDirectories"; ###Testing
		print "What is the name of the file?\n";
			my $file = <STDIN>; chomp $file;
			#my $file = "Inputfile_Test.txt"; ###Testing
		
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
				push(@old_file, $columns[1]);
				push(@new_file, $columns[2]);
			} else {next;}
		}
		
		foreach(@full_dir){
			
			#Change working directory
			$CWD=$full_dir[$n];
			my $new = $new_file[$n]; chomp $new;
			my $old = $old_file[$n];
			
			print "This is $CWD\n";
			print "old file $old\n";
			print "new $new\n";
			#Edit the files
			rename ("$CWD\\$old", "$CWD\\$new/");
			$n++;
		}
	}
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