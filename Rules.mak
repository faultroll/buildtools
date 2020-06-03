.POSIX	:
# # # # # # # # # # # #
#        命令行       #
# # # # # # # # # # # #
SHELL	:=	/bin/sh
MAKE	:=	make -j 
MV		:=	mv -f 
RM		:=	rm -f 
ECHO	:=	echo -e 
# FIND	:=	find . -maxdepth 1 -name 

# # # # # # # # # # # #
#        工具链       #
# # # # # # # # # # # #
PRFX	:=	$(CROSS_COMPILER)
CC		:=	$(PRFX)gcc
CXX		:=	$(PRFX)g++
LD		:=	$(PRFX)ld
AR		:=	$(PRFX)ar
RANLIB	:=	$(PRFX)ranlib
STRIP	:=	$(PRFX)strip
OBJDUMP	:=	$(PRFX)objdump
OBJCOPY	:=	$(PRFX)objcopy

# # # # # # # # # # # #
#      其他变量       #
# # # # # # # # # # # #
NULL			:=
SPACE			:=	$(NULL) # 
COMMA			:=	,
.DEFAULT_GOAL	:=	help
# Disable built-in rules and variables
MAKEFLAGS		+=	-r \
					--no-builtin-rules \
					--no-builtin-variables

# # # # # # # # # # # #
#      平台变量       #
# # # # # # # # # # # #
# Makefile需填充CFLAGS, CXXFLAGS, LDFLAGS
FLAGS_COMPILE_PLAT_C	:=	$(CFLAGS)
FLAGS_COMPILE_PLAT_CXX	:=	$(CXXFLAGS)
FLAGS_LINK_PLAT			:=	$(LDFLAGS)

# # # # # # # # # # # #
#     目录  文件      #
# # # # # # # # # # # #
# Makefile需填充NAME
ifndef NAME
    $(error name not defined!!!)
endif
LIBDY		:=	lib$(NAME).so
LIBST		:=	lib$(NAME).a
HEX			:=	$(NAME).hex
BIN			:=	$(NAME).bin
ASM			:=	$(NAME).asm
ELF			:=	$(NAME).elf
HOH			:=	$(NAME).h # header of header
PCH			:=	$(NAME).h.gch # pre-compiled header
# DINC, DLIB, DOUT, SRCS, LIBS需存在
DIR_INC		:=	$(realpath $(DINC))
DIR_LIB		:=	$(realpath $(DLIB))
DIR_OUT		:=	$(realpath $(DOUT))
SOURCES		:=	$(realpath $(SRCS))
LIBRARYS	:=	$(LIBS) # 不能用realpath，因为不是文件
ifndef DIR_INC
    $(warning includedir/DINC not defined/found!!!)
endif
ifndef DIR_LIB
    $(warning libdir/DLIB not defined/found!!!)
endif
ifndef DIR_OUT
    $(error DESTDIR/DOUT not defined/found!!!)
endif
ifndef SOURCES
    $(error source/SRCS not defined/found!!!)
endif
ifndef LIBRARYS
    $(warning library/LIBS not defined!!!)
endif
OBJECTS		:=	$(patsubst %.c,%.o,$(filter %.c, $(SOURCES))) \
				$(patsubst %.cpp,%.o,$(filter %.cpp, $(SOURCES)))
HEADERS		:=	$(filter %.h, $(SRCS)) # 不能用realpath，这样会变成绝对路径

# # # # # # # # # # # #
#      编译选项       #
# # # # # # # # # # # #
FLAGS_COMPILE_COMMON	:=	$(addprefix -I,$(DIR_INC))
FLAGS_COMPILE_COMMON	+=	-Os -Wall -Wextra -Winvalid-pch -D_POSIX_C_SOURCE=200809L \
							# -D_XOPEN_SOURCE=700 -D_XOPEN_SOURCE_EXTENDED
FLAGS_COMPILE_COMMON	+=	-fPIC \
							-ffunction-sections -fdata-sections
FLAGS_COMPILE_C			:=	-std=c11 -Wpedantic $(FLAGS_COMPILE_PLAT_C) 
FLAGS_COMPILE_CXX		:=	-std=c++11 -Weffc++ $(FLAGS_COMPILE_PLAT_CXX) 

# # # # # # # # # # # #
#      链接选项       #
# # # # # # # # # # # #
FLAGS_LINK_COMMON		:=	$(addprefix -L,$(DIR_LIB))
FLAGS_LINK_COMMON		+=	-Wl,--gc-sections -Wl,--as-needed
FLAGS_LINK_COMMON		+=	-rdynamic

# # # # # # # # # # # #
#        规则         #
# # # # # # # # # # # #
# .SO文件
$(LIBDY) : $(OBJECTS)
#	@$(CC) -shared $(FLAGS_LINK_COMMON) $(FLAGS_LINK_PLAT) -Wl,-Map=$(addsuffix .map,$@) $^ -o $@ $(LIBRARYS)
	@$(CC) -shared $(FLAGS_LINK_COMMON) $(FLAGS_LINK_PLAT) $^ -o $@ $(LIBRARYS)
#	@$(MV) $(addsuffix .map,$@) $(DIR_OUT)/
	$(info $(CC) -shared $(notdir $^) -o $(notdir $@))
# .A文件
$(LIBST) : $(OBJECTS)
	@$(AR) -crD $@ $^ # -D: reproducible build
	@$(RANLIB) -D $@
	$(info $(AR) -crD $(notdir $@) $(notdir $^))
# HEX文件
$(HEX) : %.hex : %.bin
	@$(OBJCOPY) -I binary -O ihex $^ $@
	$(info @$(OBJCOPY) -I binary -O ihex $(notdir $^) $(notdir $@))
# BIN文件
$(BIN) : %.bin : %.elf
	@$(OBJCOPY) -O binary $^ $@
	$(info $(OBJCOPY) -O binary $(notdir $^) $(notdir $@))
# ASM文件
$(ASM) : %.asm : %.elf
	@$(OBJDUMP) -d $^ > $@
	$(info $(OBJDUMP) -d $(notdir $^) > $(notdir $@))
# ELF文件
$(ELF) : $(OBJECTS)
#	@$(CC) $(FLAGS_LINK_COMMON) $(FLAGS_LINK_PLAT) -Wl,-Map=$(addsuffix .map,$@) $^ -o $@ $(LIBRARYS)
	@$(CC) $(FLAGS_LINK_COMMON) $(FLAGS_LINK_PLAT) $^ -o $@ $(LIBRARYS)
	@$(STRIP) $@
#	@$(MV) $(addsuffix .map,$@) $(DIR_OUT)/
	$(info $(CC) $(notdir $^) -o $(notdir $@))
	$(info $(STRIP) $(notdir $@))
# PCH文件
$(PCH) : %.h.gch : %.h
	@$(CC) $(FLAGS_COMPILE_COMMON) $(FLAGS_COMPILE_C) -c $< -o $@
	$(info $(CC) -c $(notdir $<) -o $(notdir $@))
$(HOH) : $(HEADERS)
	@$(ECHO) "#ifndef __HI_$(NAME)_H__" > $@
	@$(ECHO) "#define __HI_$(NAME)_H__" >> $@
	@$(ECHO) "" >> $@
	@$(foreach file,$^,$(ECHO) $(addsuffix \" ,$(addprefix \#include\",$(file))) >> $@;)
	@$(ECHO) "" >> $@
	@$(ECHO) "#endif" >> $@
# OBJ文件
%.o : %.c
	@$(CC) $(FLAGS_COMPILE_COMMON) $(FLAGS_COMPILE_C) -c $< -o $@
	$(info $(CC) -c $(notdir $<) -o $(notdir $@))
%.o : %.cpp
	@$(CXX) $(FLAGS_COMPILE_COMMON) $(FLAGS_COMPILE_CXX) -c $< -o $@
	$(info $(CXX) -c $(notdir $<) -o $(notdir $@))

# # # # # # # # # # # #
#        伪目标       #
# # # # # # # # # # # #
.PHONY : clean lib elf bin all gch help info
clean :
	@$(RM) $(OBJECTS)
	@$(RM) $(DIR_OUT)/*
	$(info $(RM) $(notdir $(OBJECTS)))
	$(info $(RM) $(notdir $(wildcard $(DIR_OUT)/*)))
lib : $(LIBDY) $(LIBST)
	@$(MV) $(LIBDY) $(LIBST) $(DIR_OUT)/
	@$(ECHO) "\e[0;32;1m--<$^> compiled--\e[0;36;1m\e[0m"
elf : $(ELF)
#	@$(MV) $(ASM) $(DIR_OUT)/
#	@$(FIND) "$(ELF)" -exec $(MV) {} "$(DIR_OUT)" \;
	@$(MV) $^ $(DIR_OUT)/
	@$(ECHO) "\e[0;32;1m--<$^> compiled--\e[0;36;1m\e[0m"
bin : $(HEX) $(BIN) $(ASM)
#	@$(MV) $(HEX) $(BIN) $(DIR_OUT)/
#	@$(FIND) "$(ELF)" -exec $(MV) {} "$(DIR_OUT)" \;
	@$(MV) $^ $(DIR_OUT)/
	@$(ECHO) "\e[0;32;1m--<$^> compiled--\e[0;36;1m\e[0m"
all : elf lib
	@$(ECHO) "\e[0;32;1m--<$^> compiled--\e[0;36;1m\e[0m"
gch : $(PCH) $(HOH)
	@$(MV) $(PCH) $(HOH) $(DIR_OUT)/
	@$(ECHO) "\e[0;32;1m--<$^> compiled--\e[0;36;1m\e[0m"
help :
	@$(ECHO) "\e[0;33;1m ######################################################## \e[0;36;1m\e[0m"
	@$(ECHO) "\e[0;33;1m lib : $(LIBDY) $(LIBST) \e[0;36;1m\e[0m"
	@$(ECHO) "\e[0;33;1m elf : $(ASM) $(ELF) \e[0;36;1m\e[0m"
	@$(ECHO) "\e[0;33;1m bin : $(HEX) $(BIN) $(ELF) \e[0;36;1m\e[0m"
	@$(ECHO) "\e[0;33;1m all : bin elf lib \e[0;36;1m\e[0m"
	@$(ECHO) "\e[0;33;1m gch : $(PCH) $(HOH) \e[0;36;1m\e[0m"
	@$(ECHO) "\e[0;33;1m ######################################################## \e[0;36;1m\e[0m"

