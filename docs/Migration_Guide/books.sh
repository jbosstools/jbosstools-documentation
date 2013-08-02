#!/bin/bash

#############################################################
#
#Script for building the Migration Guide
#Builds publican and maven versions
#
#To make books: ./books.sh make
#To clean books: ./books.sh clean
#
#############################################################

function make {

	#make publican version
	echo '[INFO] Making publican version'
	csprocessor build 13414
	unzip Migration_Guide.zip
	rm Migration_Guide.zip
	#cp Revision_History.xml Migration_Guide/en-US/.	
	sed -i 's/<firstname>.*<\/firstname>/<firstname>Red Hat<\/firstname>/' Migration_Guide/en-US/Author_Group.xml; sed -i 's/<surname>.*<\/surname>/<surname>Documentation Team<\/surname>/' Migration_Guide/en-US/Author_Group.xml

	#make maven version
	echo '[INFO] Making maven version'
	csprocessor build 13889 --flatten
	unzip Red_Hat_JBoss_Developer_Studio_Migration_Guide.zip
	rm Red_Hat_JBoss_Developer_Studio_Migration_Guide.zip
	cp pom.xml Red_Hat_JBoss_Developer_Studio_Migration_Guide/.
	#cp Revision_History.xml Red_Hat_JBoss_Developer_Studio_Migration_Guide/en-US/.
	cp -r Common_Content Red_Hat_JBoss_Developer_Studio_Migration_Guide/en-US/.
	rm Red_Hat_JBoss_Developer_Studio_Migration_Guide/publican.cfg
	sed -i '/<corpauthor>/,/<\/corpauthor>/{s/<corpauthor>//p;d}' Red_Hat_JBoss_Developer_Studio_Migration_Guide/en-US/Book_Info.xml

	#give feeback
	echo '[INFO] ------------------------------------------------------------------------'
	echo '[INFO] Making books has FINISHED'
	echo '[INFO] ------------------------------------------------------------------------'	

}

function build {

	#build publican version
	echo '[INFO] Building publican version'
	cd Migration_Guide
	publican build
	google-chrome tmp/en-US/html-single/index.html
	cd ..
	
	#build mvn version
	echo '[INFO] Building maven version'
	cd Red_Hat_JBoss_Developer_Studio_Migration_Guide
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
	rm -rf Migration_Guide
	
	#clean maven version
	echo '[INFO] Cleaning maven version'	
	rm -rf Red_Hat_JBoss_Developer_Studio_Migration_Guide	

	#give feeback
	echo '[INFO] ------------------------------------------------------------------------'
	echo '[INFO] Clearing books has FINISHED'
	echo '[INFO] ------------------------------------------------------------------------'	
		
}	


function gitclean {
	#clean publican version
	echo '[INFO] Cleaning publican version'	
	rm -rf Migration_Guide	

	#give feeback
	echo '[INFO] ------------------------------------------------------------------------'
	echo '[INFO] Clearing books for GIT has FINISHED'
	echo '[INFO] ------------------------------------------------------------------------'	
		
}


function puball {
	#clean publican version
	echo '[INFO] Cleaning publican version'	
	rm -rf Migration_Guide
	
	#make publican version
	echo '[INFO] Making publican version'
	csprocessor build 13414
	unzip Migration_Guide.zip
	rm Migration_Guide.zip
	#cp Revision_History.xml Migration_Guide/en-US/.	
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

#############################################################
#Main function
#############################################################

if [ $1 = "make" ]
then
	make
elif [ $1 = "build" ]
then
	build	
elif [ $1 = "clean" ]
then
	clean
elif [ $1 = "gitclean" ]
then
	gitclean
elif [ $1 = "puball" ]
then
	puball	
else
	echo '[INFO] Invalid command, choose from: make, build, clean, gitclean, puball'	
fi
