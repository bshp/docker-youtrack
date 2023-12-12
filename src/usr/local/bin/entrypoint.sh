#!/bin/bash
set -eux;

STATIC_DIR=/opt/youtrack/apps/youtrack/web/static/simplified;
CUSTOM_CSS=/opt/youtrack/conf/custom.css;

cd $STATIC_DIR;

STYLE_CSS=$(find ~+ -name 'styles.*.css');
STYLE_LNK=$(basename "$STYLE_CSS");

mv $STYLE_CSS /opt/youtrack/conf/;
cat $CUSTOM_CSS >> /opt/youtrack/conf/$STYLE_LNK;
ln -s /opt/youtrack/conf/$STYLE_LNK $STATIC_DIR/$STYLE_LNK;
cd /;
su jetbrains;
/run.sh "$@" 
