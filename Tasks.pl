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
### 7) Removes carriage return from a text file (DOS to UNIX)
### 8) Moves files listed in text file to a new directory
### 9) Moves and renames files listed in a text file to a new directory

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
print "6) Renames directory based on file input\n";
print "7) Remove carriage returns in a text file\n";
print "8) Move files to a new directory \n\n";

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
} elsif($ans==7){
	print "Where is the directory?\n";
		my $dir = <STDIN>; chomp $dir; 
	print "\nWhat is the name of the file?\n";
		my $file = <STDIN>; chomp $file;
	cleanfile($dir,$file);
} elsif($ans==8){
	print "\nHave you updated the file C:\\Program Files\\Git\\Coding\\GeneralTasks\\Inputfile_ChangeDir.txt: ";
		my $ans = <STDIN>; chomp $ans;
	if ($ans=~'Y') {
		my $list_path = "C:\\Program Files\\Git\\Coding\\GeneralTasks\\Inputfile_ChangeDir.txt";
		movefiles($list_path);
	}
} elsif($ans==9){
	print "\nHave you updated the file C:\\Program Files\\Git\\Coding\\GeneralTasks\\Inputfile_ChangeDirandName.txt: ";
		my $ans = <STDIN>; chomp $ans;
	if ($ans=~'Y') {
		my $list_path = "C:\\Program Files\\Git\\Coding\\GeneralTasks\\Inputfile_ChangeDirandName.txt";
		movefiles($list_path);
	}
}

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
print "next?";
my $next = <STDIN>;
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
			#C:\\Program Files\\Git\\Coding\\GeneralTasks
		print "What is the name of the file?\n";
			my $file = <STDIN>; chomp $file;
			#my $file = "Inputfile_ChangeFile.txt"; ###Testing
		
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

sub cleanfile{
	
	#Initialize variable
	my ($dir, $file)=@_;
	my @storage;

	#Change directories
	$CWD=$dir;
	
	#Read in manifest file
	open(READ_FILE, $file);
	my @temp = <READ_FILE>;

	#Read through each line of the directory
	for my $line (@temp) {
		#Remove carriage return
		$line =~ s/\r|\n//g;

		#Store each files data
		push(@storage, $line);
	}
	
	#Name the new file
	my $new_file="cleaned_";
	$new_file .= $file;
		
	#Print the compiled log to a new file
	open (FILE, ">$new_file") or die;
		print (FILE @storage);
		close (FILE);
		
	print "\n***File conversion complete***\n";
}

sub movefiles{
	
	#Initialize Variables
	my ($list_path) =@_;
	my $a = 0; my $temp_cur_path; my $temp_dest_path;
	my @curfilepath; my @destfilepath; my @new_file;

	#Read in text file of files to move
	open(READ_FILE, $list_path);
	my @temp = <READ_FILE>;
	
	#Create directory path for each file, remove header line
	shift @temp;
	foreach (@temp) {
		my @columns = split('\t',$_);
		if(length $columns[1]>0){
			push(@curfilepath, $columns[0]);
			push(@destfilepath, $columns[1]);
			push(@new_file, $columns[2]);
		} else {next;}
	}

	#Move files to new folder
	#opendir (NDIR, $dest_path);
	foreach my $line(@curfilepath) {
			
		#Open directory with FastQ folders
		$temp_dest_path = $destfilepath[$a]; #print $destfilepath[$a];
		$line .= "\\\\";
		$line .= $new_file[$a];
		chomp $line;

		#Move current files into new destination folder
		move ($line, $temp_dest_path) or die "\nError with $line";
		#move("T:\\DCEG\\CGF\\TempFileSwap\\Sam\\QDNA\\PC16268.xls","T:\\DCEG\\CGF\\Laboratory\\Studies\\CGF\\sFEMB-001\\sFEMB-001-R-030\\Quant\\QDNA"); ##Testing
		print "\nFile moved: $new_file[$a]";
		$a++;
	}
	print "***Completed moving files***";
	
}

sub moveandrenamefiles{
	
	#Initialize Variables
	my ($list_path) =@_;
	my $n = 0; my $temp_cur_path; my $temp_dest_path;
	my @curfilepath; my @destfilepath; my @new_file; my @old_name;

	#Read in text file of files to move
	open(READ_FILE, $list_path);
	my @temp = <READ_FILE>;
	
	#Create directory path for each file, remove header line
	shift @temp;
	foreach (@temp) {
		my @columns = split('\t',$_);
		if(length $columns[1]>0){
			push(@curfilepath, $columns[0]);
			push(@old_name, $columns[1]);
			push(@destfilepath, $columns[2]);
			push(@new_file, $columns[3]);
		} else {next;}
	}

	#Move files to new folder
	#opendir (NDIR, $dest_path);
	foreach my $line(@curfilepath) {
		
		#Copy file in original destination, and rename
		copy ("$line\\$old_name[$n]", "$destfilepath[$n]\\$new_file[$n]" );
				
		#Create new destination path, with new file name
		#$temp_dest_path = $destfilepath[$a];
		#$line .= "\\\\";
		#$line .= $new_file[$a];
		#chomp $line;

		#Move current files into new destination folder
		#move ($line, $temp_dest_path) or die "\nError with $line";
		#move("T:\\DCEG\\CGF\\TempFileSwap\\Sam\\QDNA\\PC16268.xls","T:\\DCEG\\CGF\\Laboratory\\Studies\\CGF\\sFEMB-001\\sFEMB-001-R-030\\Quant\\QDNA"); ##Testing
		#print "\nFile moved: $new_file[$a]";
		$n++;
	}
	print "***Completed moving files***";
	
}

##################################################
				#Updates#
##################################################	
#12/4/18: Update test location for #2 (rename files)
#1/1/19: Update move file function #8 - functional
#7/20/19: Created move and rename function #9