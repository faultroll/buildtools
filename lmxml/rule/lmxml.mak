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
PKGSRC			:=	$(DSRC)/mxml-2.12.tar.gz
PKGDST			:=	$(DTMP)/mxml-2.12
FIXES			:=	

# # # # # # # # # # # #
#        工具链       #
# # # # # # # # # # # #
BFRONT			:=	./configure
BBACK			:=	make -j

# # # # # # # # # # # #
#        伪目标       #
# # # # # # # # # # # #
.PHONY : clean install
clean :
	@rm -rf $(DOUT)
install :
	@rm -rf $(PKGDST) && mkdir -p $(PKGDST) $(DOUT)
# 1. uncompress
	@tar -xzf $(PKGSRC) -C $(PKGDST)
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
	@ \
	cd $(PKGDST) \
	&& \
	$(BFRONT) --host=$(HOST) \
		--prefix=$(DOUT) --exec-prefix=$(DOUT) \
		--enable-threads --enable-shared
	# TODO make patches
#	@ \
	sed -i "/^ARFLAGS/c ARFLAGS=-crD" Makefile \
	sed -i "/^RANLIB/c RANLIB=${PRFX}ranlib -D" Makefile
	@ \
	cd $(PKGDST) \
	&& \
	$(BBACK) && $(BBACK) -i install # -i ignore warning
# 4. format
	@ \
	cd $(DOUT) \
	&& \
	rm  -rf $(DOUT)/bin && rm -rf $(DOUT)/share # delete unneeded
	@rm -rf $(PKGDST)

