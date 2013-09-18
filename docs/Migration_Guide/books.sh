#!/bin/bash

#############################################################
#
#Script for building the Migration Guide
#Builds publican and maven versions
#
#To make books with publican: ./books.sh pubmake
#To make books with maven: ./books.sh mvnmake
#
#############################################################


function pubmake {
	#clean last version
	echo '[INFO] Cleaning last version'	
	rm -rf Migration_Guide

	#get updated content spec
	echo '[INFO] Pulling latest content spec'
	csprocessor pull 22436 -o Migration_Guide.contentspec
	rm Migration_Guide.contentspec.backup
	
	#make publican version
	echo '[INFO] Making publican version'
	csprocessor build 22436 --flatten
	unzip Migration_Guide.zip
	rm Migration_Guide.zip	
	sed -i 's/<firstname>.*<\/firstname>/<firstname>Red Hat<\/firstname>/' Migration_Guide/en-US/Author_Group.xml; sed -i 's/<surname>.*<\/surname>/<surname>Documentation Team<\/surname>/' Migration_Guide/en-US/Author_Group.xml
	
	#build publican version
	echo '[INFO] Building publican version'
	cd Migration_Guide
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
	rm -rf Migration_Guide

	#get updated content spec
	echo '[INFO] Pulling latest content spec'
	csprocessor pull 22436 -o Migration_Guide.contentspec
	rm Migration_Guide.contentspec.backup
	
	#make maven version
	echo '[INFO] Making maven version'
	csprocessor build 22436 --flatten --format jDocBook
	unzip Migration_Guide.zip
	rm Migration_Guide.zip
	sed -i 's/<firstname>.*<\/firstname>/<firstname>Red Hat<\/firstname>/' Migration_Guide/en-US/Author_Group.xml; sed -i 's/<surname>.*<\/surname>/<surname>Documentation Team<\/surname>/' Migration_Guide/en-US/Author_Group.xml
	
	#build mvn version
	echo '[INFO] Building maven version'
	cd Migration_Guide
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
