#!/bin/bash

#############################################################
#
#Script for building the Installation Guide
#Builds publican and maven versions
#
#To make books with publican: ./books.sh pubmake
#To make books with maven: ./books.sh mvnmake
#
#############################################################


function pubmake {
	#clean last version
	echo '[INFO] Cleaning last version'	
	rm -rf Release_Notes_7.1.0

	#get updated content spec
	echo '[INFO] Pulling latest content spec'
	csprocessor pull 22485 -o Release_Notes.contentspec
	rm Release_Notes.contentspec.backup
	
	#make publican version
	echo '[INFO] Making publican version'
	csprocessor build 22485 --flatten
	unzip Release_Notes_7.1.0.zip
	rm Release_Notes_7.1.0.zip	
	#sed -i 's/<firstname>.*<\/firstname>/<firstname>Red Hat<\/firstname>/' Release_Notes_7.1.0/en-US/Author_Group.xml; sed -i 's/<surname>.*<\/surname>/<surname>Documentation Team<\/surname>/' Release_Notes_7.1.0/en-US/Author_Group.xml
	
	#build publican version
	echo '[INFO] Building publican version'
	cd Release_Notes_7.1.0
	publican build
	google-chrome tmp/en-US/html-single/index.html
	cd ..		

	#give feeback
	echo '[INFO] ------------------------------------------------------------------------'
	echo '[INFO] Cleaning, making and building the publican version has FINISHED'
	echo '[INFO] ------------------------------------------------------------------------'	
		
}


function mvnmake {
	#clean last version
	echo '[INFO] Cleaning last version'		
	rm -rf Release_Notes_7.1.0

	#get updated content spec
	echo '[INFO] Pulling latest content spec'
	csprocessor pull 22485 -o Release_Notes.contentspec
	rm Release_Notes.contentspec.backup
	
	#make maven version
	echo '[INFO] Making maven version'
	csprocessor build 22485 --flatten --format jDocBook --hide-bug-links
	unzip Release_Notes_7.1.0.zip
	rm Release_Notes_7.1.0.zip
	#sed -i 's/<firstname>.*<\/firstname>/<firstname>Red Hat<\/firstname>/' Release_Notes_7.1.0/en-US/Author_Group.xml; sed -i 's/<surname>.*<\/surname>/<surname>Documentation Team<\/surname>/' Release_Notes_7.1.0/en-US/Author_Group.xml
	
	#build mvn version
	echo '[INFO] Building maven version'
	cd Release_Notes_7.1.0
	mvn compile
	google-chrome target/docbook/publish/en-US/html_single/index.html
	cd ..	

	#give feeback
	echo '[INFO] ------------------------------------------------------------------------'
	echo '[INFO] Cleaning, making and building the publican version has FINISHED'
	echo '[INFO] ------------------------------------------------------------------------'	
		
}


#############################################################
#Main function
#############################################################

if [ $1 = "pubmake" ]
then
	pubmake
elif [ $1 = "mvnmake" ]
then
	mvnmake
else
	echo '[INFO] Invalid command, choose from: pubmake, mvnmake'
fi
