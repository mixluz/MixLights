#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
include Makefile

# Environment
MKDIR=mkdir -p
RM=rm -f 
CP=cp 
# Macros
CND_CONF=default

ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/dali.X.${IMAGE_TYPE}.cof
else
IMAGE_TYPE=production
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/dali.X.${IMAGE_TYPE}.cof
endif
# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}
# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1472/timecnt.o ${OBJECTDIR}/_ext/1472/txdali.o ${OBJECTDIR}/_ext/1472/cmd2.o ${OBJECTDIR}/_ext/1472/main.o ${OBJECTDIR}/_ext/1472/reset.o ${OBJECTDIR}/_ext/1472/cmd3.o ${OBJECTDIR}/_ext/1472/delay.o ${OBJECTDIR}/_ext/1472/cmd1.o ${OBJECTDIR}/_ext/1472/writeee.o ${OBJECTDIR}/_ext/1472/rxdali.o ${OBJECTDIR}/_ext/1472/cmd5.o ${OBJECTDIR}/_ext/1472/cmd4.o ${OBJECTDIR}/_ext/1472/rs232.o ${OBJECTDIR}/_ext/1472/cmd6.o


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

# Path to java used to run MPLAB X when this makefile was created
MP_JAVA_PATH=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home/bin/
OS_ORIGINAL="Darwin"
OS_CURRENT="$(shell uname -s)"
############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# MP_CC is not defined
# MP_BC is not defined
MP_AS=/Applications/microchip/mplabx/mpasmx/mpasmx
MP_LD=/Applications/microchip/mplabx/mpasmx/mplink
MP_AR=/Applications/microchip/mplabx/mpasmx/mplib
# MP_BC is not defined
# MP_CC_DIR is not defined
# MP_BC_DIR is not defined
MP_AS_DIR=/Applications/microchip/mplabx/mpasmx
MP_LD_DIR=/Applications/microchip/mplabx/mpasmx
MP_AR_DIR=/Applications/microchip/mplabx/mpasmx
# MP_BC_DIR is not defined
.build-conf: ${BUILD_SUBPROJECTS}
ifneq ($(OS_CURRENT),$(OS_ORIGINAL))
	@echo "***** WARNING: This make file contains OS dependent code. The OS this makefile is being run is different from the OS it was created in."
endif
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/dali.X.${IMAGE_TYPE}.cof

MP_PROCESSOR_OPTION=16f628a
MP_LINKER_DEBUG_OPTION=
# ------------------------------------------------------------------------------------
# Rules for buildStep: createRevGrep
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
__revgrep__:   nbproject/Makefile-${CND_CONF}.mk
	@echo 'grep -q $$@' > __revgrep__
	@echo 'if [ "$$?" -ne "0" ]; then' >> __revgrep__
	@echo '  exit 0' >> __revgrep__
	@echo 'else' >> __revgrep__
	@echo '  exit 1' >> __revgrep__
	@echo 'fi' >> __revgrep__
	@chmod +x __revgrep__
else
__revgrep__:   nbproject/Makefile-${CND_CONF}.mk
	@echo 'grep -q $$@' > __revgrep__
	@echo 'if [ "$$?" -ne "0" ]; then' >> __revgrep__
	@echo '  exit 0' >> __revgrep__
	@echo 'else' >> __revgrep__
	@echo '  exit 1' >> __revgrep__
	@echo 'fi' >> __revgrep__
	@chmod +x __revgrep__
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
.PHONY: ${OBJECTDIR}/_ext/1472/timecnt.o
${OBJECTDIR}/_ext/1472/timecnt.o: ../timecnt.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/timecnt.lst" -e"${OBJECTDIR}/_ext/1472/timecnt.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/timecnt.o" ../timecnt.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/timecnt.lst" -e"${OBJECTDIR}/_ext/1472/timecnt.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/timecnt.o" ../timecnt.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/timecnt.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/timecnt.err
.PHONY: ${OBJECTDIR}/_ext/1472/txdali.o
${OBJECTDIR}/_ext/1472/txdali.o: ../txdali.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/txdali.lst" -e"${OBJECTDIR}/_ext/1472/txdali.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/txdali.o" ../txdali.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/txdali.lst" -e"${OBJECTDIR}/_ext/1472/txdali.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/txdali.o" ../txdali.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/txdali.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/txdali.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd2.o
${OBJECTDIR}/_ext/1472/cmd2.o: ../cmd2.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd2.lst" -e"${OBJECTDIR}/_ext/1472/cmd2.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd2.o" ../cmd2.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd2.lst" -e"${OBJECTDIR}/_ext/1472/cmd2.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd2.o" ../cmd2.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd2.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd2.err
.PHONY: ${OBJECTDIR}/_ext/1472/main.o
${OBJECTDIR}/_ext/1472/main.o: ../main.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/main.lst" -e"${OBJECTDIR}/_ext/1472/main.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/main.o" ../main.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/main.lst" -e"${OBJECTDIR}/_ext/1472/main.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/main.o" ../main.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/main.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/main.err
.PHONY: ${OBJECTDIR}/_ext/1472/reset.o
${OBJECTDIR}/_ext/1472/reset.o: ../reset.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/reset.lst" -e"${OBJECTDIR}/_ext/1472/reset.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/reset.o" ../reset.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/reset.lst" -e"${OBJECTDIR}/_ext/1472/reset.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/reset.o" ../reset.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/reset.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/reset.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd3.o
${OBJECTDIR}/_ext/1472/cmd3.o: ../cmd3.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd3.lst" -e"${OBJECTDIR}/_ext/1472/cmd3.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd3.o" ../cmd3.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd3.lst" -e"${OBJECTDIR}/_ext/1472/cmd3.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd3.o" ../cmd3.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd3.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd3.err
.PHONY: ${OBJECTDIR}/_ext/1472/delay.o
${OBJECTDIR}/_ext/1472/delay.o: ../delay.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/delay.lst" -e"${OBJECTDIR}/_ext/1472/delay.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/delay.o" ../delay.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/delay.lst" -e"${OBJECTDIR}/_ext/1472/delay.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/delay.o" ../delay.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/delay.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/delay.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd1.o
${OBJECTDIR}/_ext/1472/cmd1.o: ../cmd1.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd1.lst" -e"${OBJECTDIR}/_ext/1472/cmd1.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd1.o" ../cmd1.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd1.lst" -e"${OBJECTDIR}/_ext/1472/cmd1.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd1.o" ../cmd1.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd1.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd1.err
.PHONY: ${OBJECTDIR}/_ext/1472/writeee.o
${OBJECTDIR}/_ext/1472/writeee.o: ../writeee.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/writeee.lst" -e"${OBJECTDIR}/_ext/1472/writeee.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/writeee.o" ../writeee.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/writeee.lst" -e"${OBJECTDIR}/_ext/1472/writeee.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/writeee.o" ../writeee.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/writeee.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/writeee.err
.PHONY: ${OBJECTDIR}/_ext/1472/rxdali.o
${OBJECTDIR}/_ext/1472/rxdali.o: ../rxdali.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/rxdali.lst" -e"${OBJECTDIR}/_ext/1472/rxdali.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/rxdali.o" ../rxdali.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/rxdali.lst" -e"${OBJECTDIR}/_ext/1472/rxdali.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/rxdali.o" ../rxdali.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/rxdali.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/rxdali.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd5.o
${OBJECTDIR}/_ext/1472/cmd5.o: ../cmd5.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd5.lst" -e"${OBJECTDIR}/_ext/1472/cmd5.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd5.o" ../cmd5.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd5.lst" -e"${OBJECTDIR}/_ext/1472/cmd5.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd5.o" ../cmd5.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd5.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd5.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd4.o
${OBJECTDIR}/_ext/1472/cmd4.o: ../cmd4.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd4.lst" -e"${OBJECTDIR}/_ext/1472/cmd4.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd4.o" ../cmd4.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd4.lst" -e"${OBJECTDIR}/_ext/1472/cmd4.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd4.o" ../cmd4.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd4.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd4.err
.PHONY: ${OBJECTDIR}/_ext/1472/rs232.o
${OBJECTDIR}/_ext/1472/rs232.o: ../rs232.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/rs232.lst" -e"${OBJECTDIR}/_ext/1472/rs232.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/rs232.o" ../rs232.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/rs232.lst" -e"${OBJECTDIR}/_ext/1472/rs232.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/rs232.o" ../rs232.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/rs232.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/rs232.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd6.o
${OBJECTDIR}/_ext/1472/cmd6.o: ../cmd6.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd6.lst" -e"${OBJECTDIR}/_ext/1472/cmd6.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd6.o" ../cmd6.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_PK3=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd6.lst" -e"${OBJECTDIR}/_ext/1472/cmd6.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd6.o" ../cmd6.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd6.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd6.err
else
.PHONY: ${OBJECTDIR}/_ext/1472/timecnt.o
${OBJECTDIR}/_ext/1472/timecnt.o: ../timecnt.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/timecnt.lst" -e"${OBJECTDIR}/_ext/1472/timecnt.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/timecnt.o" ../timecnt.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/timecnt.lst" -e"${OBJECTDIR}/_ext/1472/timecnt.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/timecnt.o" ../timecnt.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/timecnt.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/timecnt.err
.PHONY: ${OBJECTDIR}/_ext/1472/txdali.o
${OBJECTDIR}/_ext/1472/txdali.o: ../txdali.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/txdali.lst" -e"${OBJECTDIR}/_ext/1472/txdali.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/txdali.o" ../txdali.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/txdali.lst" -e"${OBJECTDIR}/_ext/1472/txdali.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/txdali.o" ../txdali.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/txdali.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/txdali.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd2.o
${OBJECTDIR}/_ext/1472/cmd2.o: ../cmd2.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd2.lst" -e"${OBJECTDIR}/_ext/1472/cmd2.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd2.o" ../cmd2.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd2.lst" -e"${OBJECTDIR}/_ext/1472/cmd2.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd2.o" ../cmd2.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd2.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd2.err
.PHONY: ${OBJECTDIR}/_ext/1472/main.o
${OBJECTDIR}/_ext/1472/main.o: ../main.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/main.lst" -e"${OBJECTDIR}/_ext/1472/main.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/main.o" ../main.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/main.lst" -e"${OBJECTDIR}/_ext/1472/main.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/main.o" ../main.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/main.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/main.err
.PHONY: ${OBJECTDIR}/_ext/1472/reset.o
${OBJECTDIR}/_ext/1472/reset.o: ../reset.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/reset.lst" -e"${OBJECTDIR}/_ext/1472/reset.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/reset.o" ../reset.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/reset.lst" -e"${OBJECTDIR}/_ext/1472/reset.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/reset.o" ../reset.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/reset.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/reset.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd3.o
${OBJECTDIR}/_ext/1472/cmd3.o: ../cmd3.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd3.lst" -e"${OBJECTDIR}/_ext/1472/cmd3.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd3.o" ../cmd3.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd3.lst" -e"${OBJECTDIR}/_ext/1472/cmd3.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd3.o" ../cmd3.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd3.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd3.err
.PHONY: ${OBJECTDIR}/_ext/1472/delay.o
${OBJECTDIR}/_ext/1472/delay.o: ../delay.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/delay.lst" -e"${OBJECTDIR}/_ext/1472/delay.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/delay.o" ../delay.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/delay.lst" -e"${OBJECTDIR}/_ext/1472/delay.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/delay.o" ../delay.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/delay.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/delay.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd1.o
${OBJECTDIR}/_ext/1472/cmd1.o: ../cmd1.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd1.lst" -e"${OBJECTDIR}/_ext/1472/cmd1.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd1.o" ../cmd1.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd1.lst" -e"${OBJECTDIR}/_ext/1472/cmd1.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd1.o" ../cmd1.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd1.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd1.err
.PHONY: ${OBJECTDIR}/_ext/1472/writeee.o
${OBJECTDIR}/_ext/1472/writeee.o: ../writeee.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/writeee.lst" -e"${OBJECTDIR}/_ext/1472/writeee.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/writeee.o" ../writeee.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/writeee.lst" -e"${OBJECTDIR}/_ext/1472/writeee.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/writeee.o" ../writeee.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/writeee.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/writeee.err
.PHONY: ${OBJECTDIR}/_ext/1472/rxdali.o
${OBJECTDIR}/_ext/1472/rxdali.o: ../rxdali.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/rxdali.lst" -e"${OBJECTDIR}/_ext/1472/rxdali.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/rxdali.o" ../rxdali.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/rxdali.lst" -e"${OBJECTDIR}/_ext/1472/rxdali.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/rxdali.o" ../rxdali.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/rxdali.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/rxdali.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd5.o
${OBJECTDIR}/_ext/1472/cmd5.o: ../cmd5.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd5.lst" -e"${OBJECTDIR}/_ext/1472/cmd5.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd5.o" ../cmd5.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd5.lst" -e"${OBJECTDIR}/_ext/1472/cmd5.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd5.o" ../cmd5.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd5.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd5.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd4.o
${OBJECTDIR}/_ext/1472/cmd4.o: ../cmd4.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd4.lst" -e"${OBJECTDIR}/_ext/1472/cmd4.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd4.o" ../cmd4.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd4.lst" -e"${OBJECTDIR}/_ext/1472/cmd4.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd4.o" ../cmd4.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd4.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd4.err
.PHONY: ${OBJECTDIR}/_ext/1472/rs232.o
${OBJECTDIR}/_ext/1472/rs232.o: ../rs232.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/rs232.lst" -e"${OBJECTDIR}/_ext/1472/rs232.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/rs232.o" ../rs232.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/rs232.lst" -e"${OBJECTDIR}/_ext/1472/rs232.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/rs232.o" ../rs232.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/rs232.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/rs232.err
.PHONY: ${OBJECTDIR}/_ext/1472/cmd6.o
${OBJECTDIR}/_ext/1472/cmd6.o: ../cmd6.asm __revgrep__ nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} ${OBJECTDIR}/_ext/1472 
ifneq (,$(findstring MINGW32,$(OS_CURRENT))) 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION)  -l"${OBJECTDIR}/_ext/1472/cmd6.lst" -e"${OBJECTDIR}/_ext/1472/cmd6.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd6.o" ../cmd6.asm 
else 
	-${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l"${OBJECTDIR}/_ext/1472/cmd6.lst" -e"${OBJECTDIR}/_ext/1472/cmd6.err" $(ASM_OPTIONS) -o"${OBJECTDIR}/_ext/1472/cmd6.o" ../cmd6.asm 
endif 
	@cat  "${OBJECTDIR}/_ext/1472/cmd6.err" | sed -e 's/\x0D$$//' -e 's/\(^Warning\|^Error\|^Message\)\(\[[0-9]*\]\) *\(.*\) \([0-9]*\) : \(.*$$\)/\3:\4: \1\2: \5/g'
	@./__revgrep__ "^Error" ${OBJECTDIR}/_ext/1472/cmd6.err
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/dali.X.${IMAGE_TYPE}.cof: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w -x -l".." -z__MPLAB_BUILD=1  -z__MPLAB_DEBUG=1 -z__MPLAB_DEBUGGER_PK3=1 $(MP_LINKER_DEBUG_OPTION) -odist/${CND_CONF}/${IMAGE_TYPE}/dali.X.${IMAGE_TYPE}.cof ${OBJECTFILES}     
else
dist/${CND_CONF}/${IMAGE_TYPE}/dali.X.${IMAGE_TYPE}.cof: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_LD} $(MP_EXTRA_LD_PRE)   -p$(MP_PROCESSOR_OPTION)  -w  -l".." -z__MPLAB_BUILD=1  -odist/${CND_CONF}/${IMAGE_TYPE}/dali.X.${IMAGE_TYPE}.cof ${OBJECTFILES}     
endif


# Subprojects
.build-subprojects:

# Clean Targets
.clean-conf:
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

include .dep.inc
