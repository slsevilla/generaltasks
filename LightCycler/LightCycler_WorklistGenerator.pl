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
plates ($plate_num, \@barcode_list);
protocol ($prot_num, $plate_num, \@barcode_list, \@prot_list);
file($plate_num, \@barcode_list, \@prot_list);

#####################################################################
								##Subroutines##
######################################################################
#Generates array of barcodes to be run
sub plates{
	my ($plate_num, $barcode_list)=@_;
	my $n=1;
	
	#Create array of barcode numbers, iterating through number of plates
	until ($plate_num==0){
		print "Scan barcode #$n: ";
		my $barcode = <STDIN>; chomp $barcode;
		push(@barcode_list, $barcode);
		$plate_num=$plate_num-1;
		$n++;
	}
	print "\n";
}	

#Generates array of protocols for all plates
sub protocol{
	#Initialize variables
	my($prot_num, $plat_num, $barcode_list, $pro_list)=@_;
	my $prot_name;
	my $plate_counter = $plate_num;
	my $n=0;
	
	#If there is only one protocol to run
	if($prot_num==1){
		#Prompt user for protocol
		if ($plat_num==1){
			print "\nWhich protocol would you like to run for $barcode_list[0]:\n";
		} else {print "\nWhich protocol would you like to run for all plates:\n";}
			print "1) AmpliSeq Library Quant\n";
			print "2) Illumina Exome Library Quant\n";
			print "3) AmpliSeq Exome Library Quant\n";
			print "4) Quantifiler\n";
			print "5) Telo\n";
			print "6) 36B4\n";
			print "7) 2Q Copy Number SOP\n";
			print "8) 4Q Copy Number SOP\n";
			print "9) Y Chromosome SOP\n";
			print "10) mtDNA - ND1\n";
			print "11) mtDNA - ND5\n";
			print "12) mtDNA - HB8\n";
			print "Choice: ";
		
		#Save choice
		my $prot_choice = <STDIN>; chomp $prot_choice;
		#my $prot_choice =1; ###Testing
		
		#Create lightcycler naming scheme to match file location
		if($prot_choice==1){
			$prot_name=",/CGFBio/Macros/AP - AmpliSeq Library Quant";
		} elsif($prot_choice==2){
			$prot_name=",/CGFBio/Macros/HE - Illumina Exmo Library Quant";
		} elsif($prot_choice==3){
			$prot_name=",/CGFBio/Macros/PE - AmpliSeq Exome Library Quant";
		} elsif($prot_choice==4){
			$prot_name=",/CGFBio/Macros/Quantifiler";
		} elsif($prot_choice==5){
			$prot_name=",/CGFBio/Macros/Telo";
		} elsif($prot_choice==6){
			$prot_name=",/CGFBio/Macros/36B4";
		} elsif($prot_choice==7){
			$prot_name=",/CGFBio/Macros/2Q Copy Number SOP";
		} elsif($prot_choice==8){
			$prot_name=",/CGFBio/Macros/4Q Copy Number SOP";
		} elsif($prot_choice==9){
			$prot_name=",/CGFBio/Macros/Y Chromosome SOP";
		} elsif($prot_choice==10){
			$prot_name=",/CGFBio/Macros/mtDNA - ND1";
		} elsif($prot_choice==11){
			$prot_name=",/CGFBio/Macros/mtDNA - ND5";
		} elsif($prot_choice==12){
			$prot_name=",/CGFBio/Macros/mtDNA - HB8";
		} elsif($prot_choice==13){
			$prot_name=",/CGFBio/Macros/Macro HudsonDemo";
		}
		
		#Create array of single protocol name
		until ($plate_counter==0){
			push(@prot_list, $prot_name);
			$plate_counter=$plate_counter-1;
		}
	#If multiple protocols have been selected, iteration until number of plates has been reaches
	} else{
		until ($plate_counter==0){
			#Prompt user for protocol
			print "\nWhich protocol would you like to run for $barcode_list[$n]:\n";
			print "1) AmpliSeq Library Quant\n";
			print "2) Illumina Exome Library Quant\n";
			print "3) AmpliSeq Exome Library Quant\n";
			print "4) Quantifiler\n";
			print "5) Telo\n";
			print "6) 36B4\n";
			print "7) 2Q Copy Number SOP\n";
			print "8) 4Q Copy Number SOP\n";
			print "9) Y Chromosome SOP\n";
			print "10) mtDNA - ND1\n";
			print "11) mtDNA - ND5\n";
			print "12) mtDNA - HB8\n";
			print "Choice: ";
			#Save choice
			my $prot_choice = <STDIN>; chomp $prot_choice;
			
			#Create lightcycler naming scheme
			if($prot_choice==1){
				$prot_name=",/CGFBio/Macros/AP - AmpliSeq Library Quant";
			} elsif($prot_choice==2){
				$prot_name=",/CGFBio/Macros/HE - Illumina Exmo Library Quant";
			} elsif($prot_choice==3){
				$prot_name=",/CGFBio/Macros/PE - AmpliSeq Exome Library Quant";
			} elsif($prot_choice==4){
				$prot_name=",/CGFBio/Macros/Quantifiler";
			} elsif($prot_choice==5){
				$prot_name=",/CGFBio/Macros/Telo";
			} elsif($prot_choice==6){
				$prot_name=",/CGFBio/Macros/36B4";
			} elsif($prot_choice==7){
				$prot_name=",/CGFBio/Macros/2Q Copy Number SOP";
			} elsif($prot_choice==8){
				$prot_name=",/CGFBio/Macros/4Q Copy Number SOP";
			} elsif($prot_choice==9){
				$prot_name=",/CGFBio/Macros/Y Chromosome SOP";
			} elsif($prot_choice==10){
				$prot_name=",/CGFBio/Macros/mtDNA - ND1";
			} elsif($prot_choice==11){
				$prot_name=",/CGFBio/Macros/mtDNA - ND5";
			} elsif($prot_choice==12){
				$prot_name=",/CGFBio/Macros/mtDNA - HB8";
			} elsif($prot_choice==13){
				$prot_name=",/CGFBio/Macros/Macro HudsonDemo";
			}
			
			#Create array of all protocol names
			push(@prot_list, $prot_name);
			$plate_counter=$plate_counter-1;
			$n++;
			print "\n";
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
	#my $status =2; ###Testing
	
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
#2/16/18 - code created and uploaded to GIT
