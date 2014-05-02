#!/bin/bash

# this script is used to convert docbook files to asciidoc.
# prereqs: pandoc, texlive, texlive-xetex-bin -- see http://johnmacfarlane.net/pandoc/installing.html for details

usage ()
{
	echo "Usage: $0 -i infile -o outfile -WORKSPACE /some/folder/in/which/to/work"
	echo "Example: $0 -i /home/nboldt/tru/jbosstools-documentation/docs/User_Guide/JBoss_Tools_User_Guide/en-US/chap-OpenShift_Tools.xml -o /tmp/openshift"
	echo "Example: $0 -d /home/nboldt/tru/jbosstools-documentation/docs/User_Guide/JBoss_Tools_User_Guide/en-US"
	exit 1;
}

if [[ $# -lt 1 ]]; then
	usage;
fi

#defaults
WORKSPACE=`pwd`
INFILE=""
OUTFILE=""

# read commandline args
while [[ "$#" -gt 0 ]]; do
	case $1 in
		'-WORKSPACE') WORKSPACE="$2"; shift 1;;		
		'-i') INFILE="$2"; shift 1;;
		'-o') OUTFILE="$2"; OUTFILE=${OUTFILE%*.adoc}; shift 1;; # trim .adoc suffix, we'll add it on later
		'-d') INDIR="$2"; shift 1;;
	esac
	shift 1
done

# processed defauls
if [[ ! $OUTFILE ]]; then OUTFILE=${INFILE/.xml/.adoc}; fi

convert ()
{
	INF=$1
	OUTF=$2
	echo "Convert $INF to ${OUTF##*/}.adoc"
	iconv -t utf-8 ${INF} | pandoc -f docbook -t asciidoc -o ${OUTF}.adoc  --toc --chapters --atx-headers | iconv -f utf-8
	iconv -t utf-8 ${INF} | pandoc -f docbook  -o ${OUTF}.pdf --latex-engine=xelatex
}
# and now, do some work...
cd ${WORKSPACE}

if [[ $INDIR ]]; then # process directory for .xml files to convert
	pushd ${INDIR} >/dev/null
	for f in `find $INDIR -maxdepth 1 -mindepth 1 -type f -iname "*.xml"`; do
		convert $f ${f%*.xml}
	done
	popd >/dev/null
elif [[ $INFILE ]]; then # process a single file
	pushd ${INFILE%/*} >/dev/null
	convert $INFILE ${OUTFILE}
	popd >/dev/null
else
	usage
fi
