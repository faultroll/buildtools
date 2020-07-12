
DPRJ	:=	$(realpath .)
DRULE	:=	$(DPRJ)/rule

.PHONY : clean all
all :
	@make -j -s -C $(DRULE) -f lrbuf.mak lib
	@make -j -s -C $(DRULE) -f demo.mak elf
	@make -j -s -C $(DRULE) -f test.mak test
	@make -j -s -C $(DRULE) -f test.mak elf
	@make -j -s -C $(DRULE) -f test.mak testclean
clean :
	@make -j -s -C $(DRULE) -f lrbuf.mak clean
	@make -j -s -C $(DRULE) -f demo.mak clean
	@make -j -s -C $(DRULE) -f test.mak clean

