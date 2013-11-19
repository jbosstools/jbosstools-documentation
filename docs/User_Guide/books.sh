#!/bin/bash

#############################################################
#
#Script for building the User Guide
#Builds publican and maven versions
#
#To make JBDS book with publican: ./books.sh pubmake
#To make JBT book with maven: ./books.sh mvnmake
#
#############################################################



function pubmake {
	#clean last version
	echo '[INFO] Cleaning last version'	
	rm -rf User_Guide

	#get updated content spec
	echo '[INFO] Pulling latest content spec'
	csprocessor pull 22443 -o User_Guide.contentspec
	rm User_Guide.contentspec.backup
	
	#make publican version
	echo '[INFO] Making publican version'
	csprocessor build 22443 --flatten --hide-bug-links
	unzip User_Guide.zip
	rm User_Guide.zip	
	#sed -i 's/<firstname>.*<\/firstname>/<firstname>Red Hat<\/firstname>/' User_Guide/en-US/Author_Group.xml; sed -i 's/<surname>.*<\/surname>/<surname>Documentation Team<\/surname>/' User_Guide/en-US/Author_Group.xml
	
	#build publican version
	echo '[INFO] Building publican version'
	cd User_Guide
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
	rm -rf JBoss_Tools_User_Guide

	#get updated content spec
	echo '[INFO] Pulling latest content spec'
	csprocessor pull 22477 -o JBoss_Tools_User_Guide.contentspec
	rm JBoss_Tools_User_Guide.contentspec.backup
	
	#make publican version
	echo '[INFO] Making maven version'
	csprocessor build 22477 --flatten --format jDocBook --hide-bug-links
	unzip JBoss_Tools_User_Guide.zip
	rm JBoss_Tools_User_Guide.zip	
	#sed -i 's/<firstname>.*<\/firstname>/<firstname>Red Hat<\/firstname>/' JBoss_Tools_User_Guide/en-US/Author_Group.xml; sed -i 's/<surname>.*<\/surname>/<surname>Documentation Team<\/surname>/' JBoss_Tools_User_Guide/en-US/Author_Group.xml
	
	#build publican version
	echo '[INFO] Building maven version'
	cd JBoss_Tools_User_Guide
	mvn compile
	google-chrome target/docbook/publish/en-US/html_single/index.html
	cd ..		

	#give feeback
	echo '[INFO] ------------------------------------------------------------------------'
	echo '[INFO] Cleaning, making and building the maven version has FINISHED'
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
