#!/bin/bash
set -eux;

STATIC_DIR=${YOUTRACK_HOME}/apps/youtrack/web/static/simplified;
CUSTOM_CSS=${YOUTRACK_HOME}/conf/custom.css;
    
if [ -f $CUSTOM_CSS ];then
    #Get generated css
    cd $STATIC_DIR;
    STYLE_CSS=$(find ~+ -name 'styles.*.css');
    STYLE_LNK=$(basename "$STYLE_CSS");
    cp $STYLE_CSS ${YOUTRACK_HOME}/conf/;
    
    #Add custom css to styles
    cat $CUSTOM_CSS >> ${YOUTRACK_HOME}/conf/$STYLE_LNK;
    cp ${YOUTRACK_HOME}/conf/$STYLE_LNK $STATIC_DIR/;
    cd /;
    
fi;
    
#Run
su jetbrains -c "${YOUTRACK_HOME}/bin/youtrack.sh run $@";
