
DCONF	:=	../
include $(DCONF)/Platform.conf

.PHONY : clean all
all : 
	@./build.sh "$(CROSS_COMPILER)" "make -j"
clean : 
	@rm ./out -rf
