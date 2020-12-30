.POSIX :

ifndef PRJNAME
    $(error <$(NAME)> subprjs/PRJNAME not defined/found!!!)
endif

define SUBPRJ_SETTINGS
$(foreach prjname,$($(1)), \
	$(eval SUBPRJ		:=	$($(prjname))) \
	$(eval include		$(SUBPRJ)/SOURCE) \
	$(eval DINC_T		:=	$(addprefix $(SUBPRJ)/,$(DINC_$(SUBPRJ)))) \
	$(eval DISYS_T		:=	$(addprefix $(SUBPRJ)/,$(DISYS_$(SUBPRJ)))) \
	$(eval DLIB_T		:=	$(addprefix $(SUBPRJ)/,$(DLIB_$(SUBPRJ)))) \
	$(eval SRCS_T		:=	$(addprefix $(SUBPRJ)/,$(SRCS_$(SUBPRJ)))) \
	$(eval LIBS_T		:=	$(LIBS_$(SUBPRJ))) \
	$(eval CFLAGS_T		:=	$(CFLAGS_$(SUBPRJ))) \
	$(eval CXXFLAGS_T	:=	$(CXXFLAGS_$(SUBPRJ))) \
	$(eval LDFLAGS_T	:=	$(LDFLAGS_$(SUBPRJ))) \
)
endef
$(call SUBPRJ_SETTINGS,PRJNAME)

DINC		:=	$(DINC_T)
DISYS		:=	$(DISYS_T)
DLIB		:=	$(DLIB_T)
SRCS		:=	$(SRCS_T)
LIBS		:=	$(LIBS_T)
CFLAGS		:=	$(CFLAGS_T)
CXXFLAGS	:=	$(CXXFLAGS_T)
LDFLAGS		:=	$(LDFLAGS_T)
include $(DRULES)/settings_toolchain.mk
