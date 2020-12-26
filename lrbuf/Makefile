
DRULE	:=	rule

.PHONY : clean all
all :
	@make -j8 -s -C $(DRULE) -f lrbuf.mak lib
	@make -j8 -s -C $(DRULE) -f demo.mak elf
	@make -j8 -s -C $(DRULE) -f test.mak test
	@make -j8 -s -C $(DRULE) -f test.mak elf
	@make -j8 -s -C $(DRULE) -f test.mak testclean
clean :
	@make -j8 -s -C $(DRULE) -f lrbuf.mak clean
	@make -j8 -s -C $(DRULE) -f demo.mak clean
	@make -j8 -s -C $(DRULE) -f test.mak clean

