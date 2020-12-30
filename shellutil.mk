.POSIX	:
# # # # # # # # # # # #
#        命令行       #
# # # # # # # # # # # #
BASH	:=	/bin/bash
ifneq ($(BASH),$(wildcard $(BASH)))
    $(error $(BASH) not found!!!)
endif
SHELL	:=	$(BASH)
# file oper
FILE_MK	:=	touch
FILE_RM	:=	rm -f
FILE_MV	:=	mv -f
FILE_CP	:=	cp -f
# dir oper
DIR_MK	:=	mkdir -p
DIR_RM	:=	rm -rf
DIR_MV	:=	mv -f
DIR_CP	:=	cp -rf
# info
INFO	:=	echo -e
KNRM	:=	\e[0m
KRED	:=	\e[1;31m
KGRN	:=	\e[1;32m
KYEL	:=	\e[1;33m
KBLU	:=	\e[1;34m
KMAG	:=	\e[1;35m
KCYN	:=	\e[1;36m
KWHT	:=	\e[1;37m
