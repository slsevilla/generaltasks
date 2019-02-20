#!/usr/bin/perl
#User: Samantha Chill
#Date: 2/16/18

use strict;
use warnings;
use Cwd;
use CPAN;

######################################################################################
								##NOTES##
######################################################################################
##This script is generating the text file needed for the LightCycler Autoloader

######################################################################################
								##Main Code##
######################################################################################
my @barcode_list = ();
my @prot_list =();
my @module_loc=(); my @module_name;
my $prot_num;

#Determine parameters
#Prompt user for number of plates
print "\nHow many plates do you want to run? ";
my $plate_num = <STDIN>; chomp $plate_num;

#If multiple plates, ask if multiple protocols, otherwise default to single
if($plate_num>1){
	#Prompt user for multiple protocols
	print "\nDo you have:\n";
	print "1) Single protocol\n";
	print "2) Multiple protocols\n";
	print "Choice: ";
	$prot_num = <STDIN>; chomp $prot_num;
	#$prot_num = 2; ###testing
} else {$prot_num = 1};
print "\n";

#Run subroutines
read_modules(\@module_loc, \@module_name);
plates_modules ($prot_num, $plate_num,\@module_loc, \@module_name, \@barcode_list, \@prot_list);
file($plate_num, \@barcode_list, \@prot_list);

#####################################################################
								##Subroutines##
######################################################################
#Reads in the module names and creates list for user to choose as well as directory paths
sub read_modules{
	#Initialize variables
	my ($module_loc, $module_name)=@_;
	my $file_module= "module_list.txt";
	
		#Open Module file
	open (MOD_FILE, "$file_module") or die;
	@module_loc= <MOD_FILE>;
	close MOD_FILE;

	#Removes carriage return
	chomp @module_loc;
	
	#Create Array for user to choose
	foreach my $line (@module_loc){
		my $temp = $line;
		$temp =~ s/,\/CGFBio\/Macros\///g;
		push(@module_name, $temp);
	}		

}
#Reads in barcodes and selection of modules from user
sub plates_modules{
	
	#Initialize variables
	my($prot_num, $plat_num, $module_loc, $module_name, $barcode_list, $pro_list)=@_;
	my $prot_name;	my $plate_counter;
	my $n=1;
	
	#If there is only one protocol to run
	if($prot_num==1){
		
		#Start counter
		$plate_counter = 0;

		#Create array of barcode numbers, iterating through number of plates
		until ($plate_counter==$plat_num){
			print "Scan barcode: ";
			my $barcode = <STDIN>; chomp $barcode;
			push(@barcode_list, $barcode);
			$plate_counter++;
		}
		
		#Formatting break
		print "\n";
		
		#Prompt user for protocol with variations for single or all plates
		if ($plat_num==1){
			print "\nWhich protocol would you like to run for $barcode_list[0]:\n";
			
		} else {print "\nWhich protocol would you like to run for all plates:\n";}
		
		#Print all module names, and "Choice"
		foreach my $line (@module_name){
			print "$n) $line \n";
			$n++;
		}
		print "Choice: ";
		
		#Save choice
		my $prot_choice = <STDIN>; chomp $prot_choice;
		#my $prot_choice =1; ###Testing
			
		#Create array of single protocol name
		#Note -1 because array starts at 0
		until ($plate_counter==0){
			push(@prot_list, $module_loc[$prot_choice-1]);
			$plate_counter=$plate_counter-1;
		}
		
	#If there are more protocols to run
	} else {
		#Start counter
		$plate_counter = 0;

		#Create array of barcode numbers, iterating through number of plates, also asking for the protocols to run
		until ($plate_counter==$plat_num){
			$n=1;
			print "\nScan barcode: ";
			my $barcode = <STDIN>; chomp $barcode;
			push(@barcode_list, $barcode);
			
			#Ask user which protocol to run for selected barcode, printing all names then "Choice"
			print "Which protocol would you like to run for $barcode_list[$plate_counter]:\n";
			foreach my $line (@module_name){
				print "$n) $line \n";
				$n++;
			}
			print "Choice: ";
			
			#Save choice, adding it to the array
			my $prot_choice = <STDIN>; chomp $prot_choice;
			#my $prot_choice =1; ###Testing
			push(@prot_list, $module_loc[$prot_choice-1]);
			$plate_counter++;
		}		
	}
}
#Generates either 1 or 2 test files, with information for LC runs, as well as archives older files, as needed
sub file{
	#Initialize variables
	my ($plate_num, $barcode_list, $prot_list)=@_;
	my $n=0; my @final_array;
	my @file_olddata; 
	my $file_oldname = "manifest.txt";
	
	#Get date information
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	
	#Create new file name with time stamp
	my $file_newname = "archived_manifest_2019";	$file_newname .= $mon;
	$file_newname .= $mday;	$file_newname .= "_"; $file_newname .= $hour; $file_newname .= $min; $file_newname .= ".txt";

	#Determine if a new work list needs to be created, or if the current list should be updated
	print "\nAre you:\n";
	print "1) Adding plates to the instrument (will update current work list)\n";
	print "2) Starting a new run (will archive previous worklist and start new list)?\n";
	print "Choice: ";
	my $status = <STDIN>; chomp $status;
	#my $status =1; ###Testing
	
	#Combine barcode list and protocol list
	until ($plate_num==0){
		my $temp_line = $barcode_list[$n] .= $prot_list[$n];
		push (@final_array,$temp_line);
		$n++; 
		$plate_num=$plate_num-1;
	}
	
	#Open current manifest and save data
	open (READ_FILE, "$file_oldname") or die;
	@file_olddata= <READ_FILE>;
	close READ_FILE;
	
	#If user wants to update current work list
	if($status==1){
		#Removes carriage return
		chomp @file_olddata;
		
		#Print new lines of data to old data file
		foreach my $line (@final_array) {
			push (@file_olddata, $line);
		}
		
		#Reopen file for output, save combined output
		open (FILE, ">$file_oldname");
		foreach my $line (@file_olddata){
			print FILE join("\t",$line), "\n";
		}
	#If old file should be archived, and new file created
	} else{
		
		#Save old data to a new file name with time stamp
		open(NEW_FILE, ">$file_newname") or die;
		foreach my $line (@file_olddata){
			print NEW_FILE join("\t",$line), "\n";
		}
		
		#Print new data only to file
		open(FILE, ">$file_oldname") or die;
		foreach my $line (@final_array){
			print FILE join("\t",$line), "\n";
		}
	}
}

######################################################################
## TRACKING ##
######################################################################
#2/16/19 - code created and uploaded to GIT
#2/19/19 - code updates to read in module list from text file, prompt user for module name after each barcode entry
