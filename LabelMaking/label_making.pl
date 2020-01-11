#!/usr/bin/perl
#Owner: Samantha Sevilla
#Last Update: 1/10/20

######################################################################################
								##NOTES##
######################################################################################
#This code was created to generate labels for the production team

######################################################################################
								##Main Code##
######################################################################################
use warnings;
use strict;

print("\n******************************\n");
print("Ensure that you've updated the input file located: T:\\DCEG\\CGF\\DESL\\Label Printing\\UpdatedPrinting\\template.txt. If you hven't, then close and create the input file. \n");
print("******************************\n\n");

print("What is your template file name (IE template_011020):");
my $input_file=<STDIN>;
print("\n");


print("How many sub-label types are there (IE 43):");
my $sub_num = <STDIN>;
print("\n");

print("What would you like the output file to be named (IE test_output):");
my $output_file= <STDIN>;
print("\n");


#Testing
my $path="T:\\DCEG\\CGF\\DESL\\Label Printing\\UpdatedPrinting";
#my $sub_num=38;
#my $output_file="test_output";
#foreach my $line (@SubID){print "$line\n";}

chomp $input_file;
chomp $sub_num;
chomp $output_file;

#initalize 
my @file_data; my @Subject; my @SubID; my @Type;
my @col_1; my @col_2;

read_file($path, $input_file,\@file_data);
parse_file($sub_num,\@file_data, \@Subject, \@SubID, \@Type);
create_labels(@Subject, @SubID, @Type, \@col_1, \@col_2);
create_file($path, $output_file, @col_1, @col_2);

#Read in file
#Reads in Microbiome Manifest from LIMS, and parses for data
sub read_file {
	
	#Initialize Variables
	my ($path, $input_file, $file_data)=@_;
	my $full_path = "$path\\$input_file\.txt";
	
	unless (open(READ_FILE, $full_path)) {
		print "Cannot open file $full_path. Check file name and path are correct \n\n";
		exit;
	}
	
	#Read in the file, and close
	@file_data= <READ_FILE>;
	close READ_FILE;
}

sub parse_file{
	my ($sub_num,$file_data, $Subject, $SubID, $Type)=@_;
	my @file_read;
	
	#Create database with ("Y") or without ("N") study samples
	foreach my $line (@file_data) {
		push (@file_read, $line);
	}
	shift @file_read;

	#Create arrays with sample line data separated by tabs
	foreach (@file_read) {
		my @columns = split('\t',$_);
		if($columns[0] ne ""){
			push(@Subject, $columns[0]);
		} else {next;}
	}
	
	#Create arrays with sample line data separated by tabs
	for (my $i=0; $i<$sub_num; $i++){
		my @columns = split('\t',$file_read[$i]);
		chomp $columns[2];
		push(@SubID, $columns[2]);
		chomp $columns[3];
		push(@Type, $columns[3]);
	}
}

sub create_labels{
	my ($Subject, $SubID, $Type, $col_1, $col_2)=@_;

	foreach my $line (@Subject){
		
		for (my $i=0; $i<scalar(@SubID); $i++){
			
			my $Sub_SubID = "$line $SubID[$i]";
			push(@col_1,$Sub_SubID);
			push(@col_2,$Type[$i]);
		}
	}
}

sub create_file{
	
	my ($path, $output_file, $col_1, $col_2)=@_;
	my $n=0;
	
	#Print data to duplicate txt file
	my $full_path = "$path\\Output\\$output_file.txt";
	open (FILE, ">$full_path") or die;
		
	#Print data to manifest file
	my @headers = ("Label","Type");
	print FILE join ("\t", @headers), "\n";
	
	foreach my $line (@col_1) {
		my @temparray;

		push(@temparray, $col_1[$n]);
		push(@temparray, $col_2[$n]);
		print FILE join("\t",@temparray), "\n";
		$n++;
	}
	
	#Confirmations
	print("******************************\n");
	print "File was successfully created: Output\\$output_file\n";

}
