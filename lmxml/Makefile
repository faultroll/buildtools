
DPRJ	:=	$(realpath .)
DRULE	:=	$(DPRJ)/rule

.PHONY : clean all
all :
	@make -j -s -C ./$(DRULE) -f lmxml.mak install
clean :
	@make -j -s -C ./$(DRULE) -f lmxml.mak clean

