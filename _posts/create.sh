#!/bin/sh
POSTNAME=`echo $*|sed 's/[ ]* [ ]*/-/g'`
DATE=`date "+%Y-%m-%d"`
DATETIME=`date "+%Y-%m-%d %H:%M:%S"`
FILENAME=$DATE-$POSTNAME.markdown

touch $FILENAME
echo '---' > $FILENAME
echo 'layout: post' >> $FILENAME
echo 'title:  ""' >> $FILENAME
echo 'date:   '$DATETIME >> $FILENAME
echo 'categories: ' >> $FILENAME
echo '---' >> $FILENAME

vi $FILENAME
