.POSIX	:
# # # # # # # # # # # #
#     平台  规则      #
# # # # # # # # # # # #
DPRJ	:=	$(realpath ..)
DCONF	:=	$(DPRJ)/..
include $(DCONF)/Platform.conf

# # # # # # # # # # # #
#     目录  文件      #
# # # # # # # # # # # #
DSRC			:=	$(DPRJ)/src
DFIX			:=	$(DPRJ)/fix
DOUT			:=	$(DPRJ)/out
DTMP			:=	$(DPRJ)/tmp
PKGSRC			:=	$(DSRC)/cutest-1.5.zip
PKGDST			:=	$(DTMP)/cutest-1.5
FIXES			:=	

# # # # # # # # # # # #
#        工具链       #
# # # # # # # # # # # #
BFRONT			:=	
BBACK			:=	

# # # # # # # # # # # #
#        伪目标       #
# # # # # # # # # # # #
.PHONY : clean install
clean :
	@rm -rf $(DOUT)
install :
	@rm -rf $(PKGDST) && mkdir -p $(PKGDST) $(DOUT)
# 1. uncompress
	@unzip -qo $(PKGSRC) -d $(DTMP)
# 2. patch fixes
ifdef FIXES
	@ \
	cd $(PKGDST)/.. \
	&& \
	$(foreach fix,$(FIXES),patch -p1 < $(DFIX)/$(fix).patch; )
else
	@$(info no fix to patch)
endif
# 3. compile
	# nothing to do
# 4. format
	@ \
	cd $(PKGDST) \
	&& \
	mv  -f CuTest.h $(DOUT) && mv  -f CuTest.c $(DOUT) \
	&& \
	mv  -f make-tests.sh $(DOUT) && chmod +x $(DOUT)/make-tests.sh
	@rm -rf $(PKGDST)

