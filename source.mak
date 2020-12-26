.POSIX	:
# # # # # # # # # # # #
#     平台  规则      #
# # # # # # # # # # # #
# platform.conf and rules.mak dir
DCONF		?=	.
include $(DCONF)/platform.conf

# # # # # # # # # # # #
#     目录  文件      #
# # # # # # # # # # # #
# $(NAME).elf or lib$(NAME).a/.so
NAME		?=	
# .h dirs
DINC		?=	
# output .elf/.a/.so dirs
DOUT		?=	
# thirdparty .a/.so dirs
DLIB		?=	
# .c/.cc files
SRCS		?=	
# must link with libstdc++ if using c++, for gcc link instead of g++ link
LIBS		?=	

# # # # # # # # # # # #
#      编译选项       #
# # # # # # # # # # # #
CFLAGS		?=	
CXXFLAGS	?=	

# # # # # # # # # # # #
#      链接选项       #
# # # # # # # # # # # #
LDFLAGS		?=	

# # # # # # # # # # # #
#     通用  规则      #
# # # # # # # # # # # #
# default target for make cmd, can be lib/elf or your own
TYPE		?=	help
include $(DCONF)/rules.mak