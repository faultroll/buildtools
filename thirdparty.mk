.POSIX	:
# # # # # # # # # # # #
#        伪目标       #
# # # # # # # # # # # #
.PHONY : install clean
install :
	@$(DIR_MK) $(PKGDST) # $(DOUT)
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
	@$(DIR_RM) $(PKGDST) $(DOUT)/*
