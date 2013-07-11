#!/bin/bash

#############################################################
#
#Script for building the Installation Guide
#Builds publican and maven versions
#
#To make books: ./books.sh make
#To clean books: ./books.sh clean
#
#############################################################

function make {

	#make publican version
	echo '[INFO] Making publican version'
	csprocessor build 13332
	unzip Installation_Guide.zip
	rm Installation_Guide.zip
	cp Revision_History.xml Installation_Guide/en-US/.	
	#echo 'Now edit Installation_Guide/en-US/Author.xml by hand'

	#make maven version
	echo '[INFO] Making maven version'
	csprocessor build 13882 --flatten
	unzip Red_Hat_JBoss_Developer_Studio_Installation_Guide.zip
	rm Red_Hat_JBoss_Developer_Studio_Installation_Guide.zip
	cp pom.xml Red_Hat_JBoss_Developer_Studio_Installation_Guide/.
	cp Revision_History.xml Red_Hat_JBoss_Developer_Studio_Installation_Guide/en-US/.
	cp -r Common_Content Red_Hat_JBoss_Developer_Studio_Installation_Guide/en-US/.
	rm Red_Hat_JBoss_Developer_Studio_Installation_Guide/publican.cfg
	sed -i '/<corpauthor>/,/<\/corpauthor>/{s/<corpauthor>//p;d}' Red_Hat_JBoss_Developer_Studio_Installation_Guide/en-US/Book_Info.xml

	#give feeback
	echo '[INFO] ------------------------------------------------------------------------'
	echo '[INFO] Making books has FINISHED'
	echo '[INFO] Now edit Installation_Guide/en-US/Author_Group.xml by hand'	
	echo '[INFO] ------------------------------------------------------------------------'	

}

function build {

	#build publican version
	echo '[INFO] Building publican version'
	cd Installation_Guide
	publican build
	google-chrome tmp/en-US/html-single/index.html
	cd ..
	
	#build mvn version
	echo '[INFO] Building maven version'
	cd Red_Hat_JBoss_Developer_Studio_Installation_Guide
	mvn compile
	google-chrome target/docbook/publish/en-US/html_single/index.html
	cd ..
	
	#give feeback
	echo '[INFO] ------------------------------------------------------------------------'
	echo '[INFO] Building books has FINISHED'
	echo '[INFO] ------------------------------------------------------------------------'	

}	


function clean {
	#clean publican version
	echo '[INFO] Cleaning publican version'	
	rm -rf Installation_Guide
	
	#clean maven version
	echo '[INFO] Cleaning maven version'	
	rm -rf Red_Hat_JBoss_Developer_Studio_Installation_Guide	

	#give feeback
	echo '[INFO] ------------------------------------------------------------------------'
	echo '[INFO] Clearing books has FINISHED'
	echo '[INFO] ------------------------------------------------------------------------'	
		
}	


function gitclean {
	#clean publican version
	echo '[INFO] Cleaning publican version'	
	rm -rf Installation_Guide	

	#give feeback
	echo '[INFO] ------------------------------------------------------------------------'
	echo '[INFO] Clearing books for GIT has FINISHED'
	echo '[INFO] ------------------------------------------------------------------------'	
		
}


#############################################################
#Main function
#############################################################

if [ $1 = "make" ]
then
	make
elif [ $1 = "build" ]
then
	echo '[INFO] Hope you have edited Migration_Guide/en-US/Author.xml first'
	build	
elif [ $1 = "clean" ]
then
	clean
elif [ $1 = "gitclean" ]
then
	gitclean
else
	echo '[INFO] Invalid command, choose from: make, build, clean, gitclean'	
fi
