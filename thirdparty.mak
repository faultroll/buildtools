.POSIX	:
# # # # # # # # # # # #
#     平台  规则      #
# # # # # # # # # # # #
# realpath
DCONF			?=	.
include $(DCONF)/platform.conf

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
#        伪目标       #
# # # # # # # # # # # #
.PHONY : install clean
install :
	@$(DIR_MK) $(PKGDST) $(DOUT)
# 1. uncompress
	@$(BUNCOMPRESS)
# 2. patch fixes
ifdef FIXES
	@ \
	cd $(PKGDST) \
	&& \
	$(foreach fix,$(FIXES),patch p1 -i $(fix); )
endif
# 3. compile
ifdef BBUILDTOOL
	@cd $(PKGDST) && $(BBUILDTOOL)
endif
ifdef BTOOLCHAIN
	@cd $(PKGDST) && $(BTOOLCHAIN)
endif
clean :
	@$(DIR_RM) $(PKGDST) $(DOUT)
