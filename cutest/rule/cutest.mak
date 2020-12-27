.POSIX	:
# # # # # # # # # # # #
#     目录  文件      #
# # # # # # # # # # # #
DCONF			:=	$(realpath ../../makerule)
DPRJ			:=	$(realpath ..)
DOUT			:=	$(DPRJ)/out
PKGSRC			:=	$(DPRJ)/src/cutest-1.5.zip
PKGDST			:=	$(DOUT)/cutest-1.5
FIXES			:=	

# # # # # # # # # # # #
#        工具链       #
# # # # # # # # # # # #
BUNCOMPRESS		:=	unzip -qo $(PKGSRC) -d $(DOUT)
BBUILDTOOL		:=	mv -f CuTest.h $(DOUT) && mv -f CuTest.c $(DOUT) \
					&& \
					mv -f make-tests.sh $(DOUT) && chmod +x $(DOUT)/make-tests.sh
BTOOLCHAIN		:=	

# # # # # # # # # # # #
#        伪目标       #
# # # # # # # # # # # #
include $(DCONF)/thirdparty.mak
