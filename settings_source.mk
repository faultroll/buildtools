.POSIX :
# # # # # # # # # # # #
#     目录  文件      #
# # # # # # # # # # # #
DINC_$(SUBPRJ)		?=	
DISYS_$(SUBPRJ)		?=	
DLIB_$(SUBPRJ)		?=	
SRCS_$(SUBPRJ)		?=	
LIBS_$(SUBPRJ)		?=	-Wl,-Bstatic \
						 \
						-Wl,--start-group \
						 \
						-Wl,--end-group
LIBS_$(SUBPRJ)		+=	-Wl,-Bdynamic \
						 \
						-Wl,--start-group \
						 \
						-Wl,--end-group

# # # # # # # # # # # #
#      编译选项       #
# # # # # # # # # # # #
CFLAGS_$(SUBPRJ)	?=	
CXXFLAGS_$(SUBPRJ)	?=	

# # # # # # # # # # # #
#      链接选项       #
# # # # # # # # # # # #
LDFLAGS_$(SUBPRJ)	?=	

# # # # # # # # # # # #
#     通用  规则      #
# # # # # # # # # # # #
# makerules dir
DRULES		?=	.
include $(DRULES)/source.mk
