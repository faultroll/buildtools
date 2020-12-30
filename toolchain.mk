.POSIX	:
# # # # # # # # # # # #
#        工具链       #
# # # # # # # # # # # #
ifneq ($(HOST),$(TARGET))
    PRFX	:=	$(TARGET)-
else
    PRFX	:=	
endif
CC			:=	$(PRFX)gcc
CXX			:=	$(PRFX)g++
LD			:=	$(PRFX)ld
AR			:=	$(PRFX)ar
RANLIB		:=	$(PRFX)ranlib
STRIP		:=	$(PRFX)strip
# OBJDUMP		:=	$(PRFX)objdump
# OBJCOPY		:=	$(PRFX)objcopy

# # # # # # # # # # # #
#      其他变量       #
# # # # # # # # # # # #
# symbol
NULL	:=
SPACE	:=	$(NULL) # trick comment for space
COMMA	:=	,
# makefile inner
.DEFAULT_GOAL	:=	$(TYPE)
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
# HEX			:=	$(NAME).hex
# BIN			:=	$(NAME).bin
# ASM			:=	$(NAME).asm
ELF			:=	$(NAME).elf
# DINC, DISYS, DLIB, DOUT, SRCS, LIBS需存在
DIR_INC		:=	$(realpath $(DINC))
DIR_ISYS	:=	$(realpath $(DISYS))
DIR_LIB		:=	$(realpath $(DLIB))
DIR_OUT		:=	$(realpath $(DOUT))
SOURCES		:=	$(realpath $(SRCS))
LIBRARYS	:=	$(LIBS) # 不能用realpath，因为不是文件
LIBRARYS	+=	-Wl,-Bdynamic # must end with dynamic, for libgcc_s
ifndef DIR_INC
    $(warning <$(NAME)> includedir/DINC not defined/found!!!)
endif
ifndef DIR_ISYS
    $(warning <$(NAME)> sysincdir/DISYS not defined/found!!!)
endif
ifndef DIR_LIB
    $(warning <$(NAME)> libdir/DLIB not defined/found!!!)
endif
ifndef DIR_OUT
    $(error <$(NAME)> DESTDIR/DOUT not defined/found!!!)
endif
ifndef SOURCES
    $(error <$(NAME)> source/SRCS not defined/found!!!)
endif
ifndef LIBRARYS
    $(warning <$(NAME)> library/LIBS not defined!!!)
endif
OBJECTS		:=	$(patsubst %.c,%.o,$(filter %.c, $(SOURCES))) 
OBJECTS		+=	$(patsubst %.cc,%.o,$(filter %.cc, $(SOURCES))) \
				$(patsubst %.cpp,%.o,$(filter %.cpp, $(SOURCES))) 

# # # # # # # # # # # #
#      编译选项       #
# # # # # # # # # # # #
FLAGS_COMPILE_COMMON	:=	$(addprefix -isystem ,$(DIR_ISYS)) $(addprefix -I,$(DIR_INC))
FLAGS_COMPILE_COMMON	+=	-Os -Wall -Wextra -Winvalid-pch -D_POSIX_C_SOURCE=200809L \
							# -D_XOPEN_SOURCE=700 -D_XOPEN_SOURCE_EXTENDED
FLAGS_COMPILE_COMMON	+=	-ffunction-sections -fdata-sections
ifneq ($(TYPE),elf)
    FLAGS_COMPILE_COMMON	+=	-fPIC
else
    FLAGS_COMPILE_COMMON	+=	-fPIE
endif
FLAGS_COMPILE_C		:=	-std=c11 -Wpedantic $(FLAGS_COMPILE_PLAT_C) 
FLAGS_COMPILE_CXX	:=	-std=c++11 -Weffc++ -fpermissive $(FLAGS_COMPILE_PLAT_CXX) 

# # # # # # # # # # # #
#      链接选项       #
# # # # # # # # # # # #
FLAGS_LINK_COMMON		:=	$(addprefix -L,$(DIR_LIB))
FLAGS_LINK_COMMON		+=	-Wl,--gc-sections -Wl,--as-needed
FLAGS_LINK_COMMON		+=	-Wl,--export-dynamic

# # # # # # # # # # # #
#        伪目标       #
# # # # # # # # # # # #
.PHONY : help all clean elf lib 
help :
	@$(INFO) "$(KYEL)########################################################$(KNRM)"
	@$(INFO) "$(KYEL)lib : $(LIBDY) $(LIBST)$(KNRM)"
	@$(INFO) "$(KYEL)elf : $(ELF)$(KNRM)"
#	@$(INFO) "$(KYEL)bin : $(HEX) $(BIN) $(ASM)$(KNRM)"
	@$(INFO) "$(KYEL)########################################################$(KNRM)"
all : $(TYPE)
	@$(INFO) "$(KGRN)--rule <$(TYPE)> compiled--$(KNRM)"
clean :
	@$(FILE_RM) $(OBJECTS) $(DIR_OUT)/*
	$(info $(FILE_RM) $(notdir $(OBJECTS)) $(notdir $(wildcard $(DIR_OUT)/*)))
	@$(INFO) "$(KGRN)--rule <$(TYPE)> cleaned--$(KNRM)"
elf : $(ELF)
	@$(FILE_MV) $^ $(DIR_OUT)/
	@$(INFO) "$(KGRN)--<$^> compiled--$(KNRM)"
lib : $(LIBDY) $(LIBST)
	@$(FILE_MV) $^ $(DIR_OUT)/
	@$(INFO) "$(KGRN)--<$^> compiled--$(KNRM)"
# bin : $(HEX) $(BIN) $(ASM)
# 	@$(FILE_MV) $^ $(DIR_OUT)/
# 	@$(INFO) "$(KGRN)--<$^> compiled--$(KNRM)"

# # # # # # # # # # # #
#        规则         #
# # # # # # # # # # # #
# .SO文件
$(LIBDY) : $(OBJECTS)
	@$(CC) -shared $(FLAGS_LINK_COMMON) $(FLAGS_LINK_PLAT) $^ -o $@ $(LIBRARYS)
	@$(STRIP) --strip-all $@
	$(info $(CC) -shared $(notdir $^) -o $(notdir $@))
# .A文件
$(LIBST) : $(OBJECTS)
	@$(AR) -crD $@ $^ # -D: reproducible build
	@$(RANLIB) -D $@
	@$(STRIP) --strip-unneeded $@
	$(info $(AR) -crD $(notdir $@) $(notdir $^))
# # HEX文件
# $(HEX) : %.hex : %.bin
# 	@$(OBJCOPY) -I binary -O ihex $^ $@
# 	$(info @$(OBJCOPY) -I binary -O ihex $(notdir $^) $(notdir $@))
# # BIN文件
# $(BIN) : %.bin : %.elf
# 	@$(OBJCOPY) -O binary $^ $@
# 	$(info $(OBJCOPY) -O binary $(notdir $^) $(notdir $@))
# # ASM文件
# $(ASM) : %.asm : %.elf
# 	@$(OBJDUMP) -d $^ > $@
# 	$(info $(OBJDUMP) -d $(notdir $^) > $(notdir $@))
# ELF文件
$(ELF) : $(OBJECTS)
	@$(CC) $(FLAGS_LINK_COMMON) $(FLAGS_LINK_PLAT) $^ -o $@ $(LIBRARYS)
	@$(STRIP) --strip-all $@
	$(info $(CC) $(notdir $^) -o $(notdir $@))
# OBJ文件
%.o : %.c
	@$(CC) $(FLAGS_COMPILE_COMMON) $(FLAGS_COMPILE_C) -c $< -o $@
	$(info $(CC) -c $(notdir $<) -o $(notdir $@))
%.o : %.cc
	@$(CXX) $(FLAGS_COMPILE_COMMON) $(FLAGS_COMPILE_CXX) -c $< -o $@
	$(info $(CXX) -c $(notdir $<) -o $(notdir $@))
%.o : %.cpp
	@$(CXX) $(FLAGS_COMPILE_COMMON) $(FLAGS_COMPILE_CXX) -c $< -o $@
	$(info $(CXX) -c $(notdir $<) -o $(notdir $@))
