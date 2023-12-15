#!/bin/bash
set -eux;

#Static Vars
YOUTRACK_HOME=/opt/youtrack;
STATIC_DIR=$YOUTRACK_HOME/apps/youtrack/web/static/simplified;
CUSTOM_CSS=$YOUTRACK_HOME/conf/custom.css;

if [ -f $CUSTOM_CSS ];then
    #Get generated css
    cd $STATIC_DIR;
    STYLE_CSS=$(find ~+ -name 'styles.*.css');
    STYLE_LNK=$(basename "$STYLE_CSS");
    cp $STYLE_CSS $YOUTRACK_HOME/conf/;
    
    #Add custom css to styles
    cat $CUSTOM_CSS >> $YOUTRACK_HOME/conf/$STYLE_LNK;
    cp $YOUTRACK_HOME/conf/$STYLE_LNK $STATIC_DIR/;
    cd /;
    
fi;
    
chown -R jetbrains:jetbrains $YOUTRACK_HOME/logs $YOUTRACK_HOME/data $YOUTRACK_HOME/backups $YOUTRACK_HOME/temp /not-mapped-to-volume-dir $YOUTRACK_HOME/conf
    
#Switch user
su jetbrains -c '/run.sh "$@"';
