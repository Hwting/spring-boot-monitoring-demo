#!/bin/bash

sh ${CATALINA_HOME}/bin/startup.sh
tail -f ${CATALINA_HOME}/logs/catalina.out
