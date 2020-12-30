.POSIX :
# # # # # # # # # # # #
#     目录  文件      #
# # # # # # # # # # # #
DCONF			:=	$(realpath ../../makerule)
DPRJ			:=	$(realpath ..)
DCUTEST			:=	$(realpath ../../cutest/out)
NAME			:=	test_lrbuf
DSRC			:=	$(DPRJ)/test
DINC			:=	$(shell find $(DPRJ)/inc -type d) \
					$(shell find $(DSRC) -type d)
DOUT			:=	$(DPRJ)/out
DLIB			:=	$(shell find $(DPRJ)/lib -type d) \
					$(DOUT)
SRCS_$(NAME)	:=	test.c main.c
SRCS			:=	$(foreach file,$(SRCS_$(NAME)),$(wildcard $(DSRC)/$(file)))
SRCS			+=	$(DCUTEST)/CuTest.c
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
CFLAGS		:=	-isystem $(DCUTEST)
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
.PHONY : test testclean
test : 
	@$(DCUTEST)/make-tests.sh $(DSRC)/test.c > $(DSRC)/main.c
testclean : 
	@rm $(DSRC)/main.o $(DSRC)/main.c
