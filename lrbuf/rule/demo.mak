.POSIX :
# # # # # # # # # # # #
#     目录  文件      #
# # # # # # # # # # # #
DCONF			:=	$(realpath ../../makerule)
DPRJ			:=	$(realpath ..)
NAME			:=	demo_lrbuf
DSRC			:=	$(DPRJ)/demo
DINC			:=	$(shell find $(DPRJ)/inc -type d) \
					$(shell find $(DSRC) -type d)
DOUT			:=	$(DPRJ)/out
DLIB			:=	$(shell find $(DPRJ)/lib -type d) \
					$(DOUT)
SRCS_$(NAME)	:=	main.c
SRCS			:=	$(foreach file,$(SRCS_$(NAME)),$(wildcard $(DSRC)/$(file)))
LIBS			:=	-Wl,-Bstatic \
					 \
					-Wl,--start-group \
					-lrbuf \
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
TYPE		:=	elf
include $(DCONF)/source.mak
