SHELL=/bin/sh
######################################################################
# GenOpt makefile to compile, document and run unit tests.
#
# MWetter@lbl.gov                                           2008-05-08
######################################################################

# List of source code files
SRC=`find genopt -name '*.java'`
# List of class files
CLAFIL=`find genopt -name '*.class'`
# List of run time files
RUNFIL=`find example \( -name 'OutputListing*' -or -name 'GenOpt.log' \
        -or -name 'eplusout.*' -or -name '*.eso' -or -name '*.audit' -or -name 'Output' \)`
RUNDIR=`find example \( -name 'Output' \)`

# List of directories with example files
EXADIR=$(shell find example/quad -maxdepth 1 \( -type d -not -name '.svn' \) )
# Root directory of GenOpt
ROODIR=$(shell pwd)


### Compiles the GenOpt source code and the JavaDoc 
all: doc jar

### Compiles the GenOpt source code
prog:
	javac -Xlint:unchecked $(SRC)

### Makes the jar file
jar: prog
	jar cfm genopt.jar Manifest.txt $(CLAFIL) genopt/img/* genopt/legal.txt
	jar -i genopt.jar 

### Deletes autogenerated files
clean:
	@if [ "$(CLAFIL)" != "" ]; then rm -v $(CLAFIL); fi
	@if [ "$(RUNFIL)" != "" ]; then rm -v $(RUNFIL); fi
	@if [ "$(RUNDIR)" != "" ]; then rm -r $(RUNDIR); fi

### generates JavaDoc html files
doc:
	rm -f jdoc/*.html jdoc/package-list
	rm -rf jdoc/genopt/*
	javadoc -breakiterator -private -author -version \
	-windowtitle "GenOpt Code Documentation" \
	-stylesheetfile jdoc/jstyle.css \
	-bottom "<DIV CLASS="FOOTER"> <P> <CENTER> <A HREF="index.html" \
	TARGET=_top>GenOpt</A> | <A HREF="http://simulationresearch.lbl.gov" \
	TARGET=_top>LBL SRG</A> | <A HREF="http://www.lbl.gov" \
	TARGET=_top>LBL</A> </CENTER> <HR WIDTH="100%"> \
	<BR> Contact: <A HREF="mailto:MWetter@lbl.gov">MWetter@lbl.gov</A> </DIV>" -d jdoc $(SRC)

### unit tests
unitTest:
	@for x in $(EXADIR); do \
	    cd $(ROODIR); \
	    echo "++++ $$x"; \
	    if [ -f $$x/optLinux.ini ]; then \
	       	java -ea -classpath genopt.jar genopt.GenOpt $$x/optLinux.ini; \
	        if [ "$$?" != "0" ]; then \
	            echo "*** Error: Unit test failed for $$x/optLinux.ini"; \
	            exit 1; fi; \
	    else \
	          echo "*** Nothing to run in $$x"; \
	    fi; \
	done; \
