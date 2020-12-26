.POSIX	:
# # # # # # # # # # # #
#     目录  文件      #
# # # # # # # # # # # #
DCONF			:=	$(realpath ../../makefile)
DPRJ			:=	$(realpath ..)
NAME			:=	rbuf
DSRC			:=	$(DPRJ)/src
DINC			:=	$(shell find $(DPRJ)/inc -type d) \
					$(shell find $(DSRC) -type d)
DOUT			:=	$(DPRJ)/out
DLIB			:=	$(shell find $(DPRJ)/lib -type d)
SRCS_$(NAME)	:=	lrbuf.c
SRCS			:=	$(foreach file,$(SRCS_$(NAME)),$(wildcard $(DSRC)/$(file)))
LIBS			:=	-Wl,-Bstatic \
					 \
					-Wl,--start-group \
					 \
					-Wl,--end-group
LIBS			+=	-Wl,-Bdynamic \
					 \
					-Wl,--start-group \
					 \
					-Wl,--end-group

# # # # # # # # # # # #
#      编译选项       #
# # # # # # # # # # # #
# 以下平台无关
CFLAGS		:=	
CXXFLAGS	:=	
# 以下平台相关
CFLAGS		+=	
CXXFLAGS	+=	

# # # # # # # # # # # #
#      链接选项       #
# # # # # # # # # # # #
# 以下平台无关
LDFLAGS		:=	
# 以下平台相关
LDFLAGS		+=	

# # # # # # # # # # # #
#     通用  规则      #
# # # # # # # # # # # #
TYPE		:=	lib
MAKE_CMD	:=	make -j8 -s -C $(DCONF) -f source.mak \
					DCONF=$(DCONF) TYPE=$(TYPE) \
					NAME=$(NAME) DINC=$(DINC) DOUT=$(DOUT) \
					DLIB=$(DLIB) SRCS=$(SRCS) LIBS=$(LIBS) \
					CFLAGS=$(CFLAGS) CXXFLAGS=$(CXXFLAGS) LDFLAGS=$(LDFLAGS)

.PHONY : clean all
all :
	@$(MAKE_CMD) all
clean :
	@$(MAKE_CMD) clean
