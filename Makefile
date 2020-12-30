.POSIX :

# must set 1
DROOT	:=	$(realpath .)
DRULES	:=	$(DROOT)/makerule

# usr settings
DIST	:=	$(DROOT)/lrbuf/out
LRBUF	:=	lrbuf

# must set 2
HOST	:=	x86_64-linux-gnu
TARGET	:=	x86_64-linux-gnu
NAME	:=	lrbuf
TYPE	:=	lib
DOUT	:=	$(DIST)
PRJNAME	:=	LRBUF

include $(DRULES)/settings_source.mk
