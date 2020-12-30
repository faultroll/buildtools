.POSIX :
# # # # # # # # # # # #
#     目录  文件      #
# # # # # # # # # # # #
# output dir
DOUT			?=	
# archive
PKGSRC			?=	
# uncompressed dir
PKGDST			?=	
# patches
FIXES			?=	

# # # # # # # # # # # #
#        工具链       #
# # # # # # # # # # # #
# eg. tar -xzf $(PKGSRC) -C $(PKGDST)
BUNCOMPRESS		?=	
# eg. \
	./configure --host=$(TARGET) \
		--prefix=$(DOUT) --exec-prefix=$(DOUT) \
		--enable-threads --enable-shared
BBUILDTOOL		?=	
# eg. make -j8 && make -j8 install
BTOOLCHAIN		?=	


# # # # # # # # # # # #
#     通用  规则      #
# # # # # # # # # # # #
# makerules dir
DRULES		?=	.
include $(DRULES)/shellutil.mk
include $(DRULES)/thirdparty.mk
