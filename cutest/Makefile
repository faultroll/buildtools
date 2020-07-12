
DPRJ	:=	$(realpath .)
DRULE	:=	$(DPRJ)/rule

.PHONY : clean all
all :
	@make -j -s -C $(DRULE) -f cutest.mak install
clean :
	@make -j -s -C $(DRULE) -f cutest.mak clean

