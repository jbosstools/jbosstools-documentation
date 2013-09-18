#!/bin/bash

#############################################################
#
#Script for building the Getting Started Guide
#Builds publican and maven versions
#
#To make books with publican: ./books.sh pubmake
#To make books with maven: ./books.sh mvnmake
#
#############################################################


function pubmake {
	#clean last version
	echo '[INFO] Cleaning last version'	
	rm -rf Getting_Started_Guide

	#get updated content spec
	echo '[INFO] Pulling latest content spec'
	csprocessor pull 22437 -o Getting_Started_Guide.contentspec
	rm Getting_Started_Guide.contentspec.backup
	
	#make publican version
	echo '[INFO] Making publican version'
	csprocessor build 22437 --flatten
	unzip Getting_Started_Guide.zip
	rm Getting_Started_Guide.zip	
	sed -i 's/<firstname>.*<\/firstname>/<firstname>Red Hat<\/firstname>/' Getting_Started_Guide/en-US/Author_Group.xml; sed -i 's/<surname>.*<\/surname>/<surname>Documentation Team<\/surname>/' Getting_Started_Guide/en-US/Author_Group.xml
	
	#build publican version
	echo '[INFO] Building publican version'
	cd Getting_Started_Guide
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
	rm -rf Getting_Started_Guide

	#get updated content spec
	echo '[INFO] Pulling latest content spec'
	csprocessor pull 22437 -o Getting_Started_Guide.contentspec
	rm Getting_Started_Guide.contentspec.backup
	
	#make maven version
	echo '[INFO] Making maven version'
	csprocessor build 22437 --flatten --format jDocBook
	unzip Getting_Started_Guide.zip
	rm Getting_Started_Guide.zip
	sed -i 's/<firstname>.*<\/firstname>/<firstname>Red Hat<\/firstname>/' Getting_Started_Guide/en-US/Author_Group.xml; sed -i 's/<surname>.*<\/surname>/<surname>Documentation Team<\/surname>/' Getting_Started_Guide/en-US/Author_Group.xml
	
	#build mvn version
	echo '[INFO] Building maven version'
	cd Getting_Started_Guide
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
