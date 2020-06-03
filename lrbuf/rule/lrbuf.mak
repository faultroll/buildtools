.POSIX	:
# # # # # # # # # # # #
#     平台  规则      #
# # # # # # # # # # # #
DCONF	:=	../../
include $(DCONF)/Platform.conf

# # # # # # # # # # # #
#     目录  文件      #
# # # # # # # # # # # #
NAME			:=	rbuf
DSRC			:=	../src
DINC			:=	$(shell find ../inc -type d) \
					$(shell find $(DSRC) -type d)
DOUT			:=	../out
DLIB			:=	$(shell find ../lib -type d)
SRCS_$(NAME)	:=	lrbuf.c
SRCS			:=	$(foreach file,$(SRCS_$(NAME)),$(wildcard $(DSRC)/$(file)))
LIBS			:=	-Wl,-Bstatic \
					 \
					-Wl,--start-group \
					 \
					-Wl,--end-group
# must end with dynamic, for libgcc_s
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

include $(DCONF)/Rules.mak
