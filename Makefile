
.POSIX	:
DCONF	:=	./
include $(DCONF)/Platform.conf

###############################################################################
# require a better way, maybe .d 
all : lrbuf lmxml

lrbuf :	\
			$(DLRBUF)/out/librbuf.a
$(DLRBUF)/out/librbuf.a :	\
								$(DCUTEST)/out/CuTest.c
#	$(info $(DLRBUF))
	@make -j -s -C ./$(DLRBUF) -f Makefile all
$(DCUTEST)/out/CuTest.c :
#	$(info $(DCUTEST))
	@make -j -s -C ./$(DCUTEST) -f Makefile all

lmxml :	\
			$(DLMXML)/out/libmxml.a
$(DLMXML)/out/libmxml.a :	\
								
#	$(info $(DLMXML))
	@make -j -s -C ./$(DLMXML) -f Makefile all

###############################################################################
# require a better way
clean : 
	@make -j -s -C ./$(DLRBUF) -f Makefile clean
distclean : clean
	@make -j -s -C ./$(DLMXML) -f Makefile clean
	@make -j -s -C ./$(DCUTEST) -f Makefile clean

###############################################################################
.PHONY: clean distclean all
###############################################################################
