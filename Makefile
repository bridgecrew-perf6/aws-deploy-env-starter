ifneq (,)
This makefile requires GNU Make.
endif

.NOTPARALLEL:
.SILENT:
.ONESHELL:
.DELETE_ON_ERROR:

ifdef MAKE_SHELL
SHELL = $(MAKE_SHELL)
endif

ifdef MAKE_SED
SED = $(MAKE_SED)
else
SED = sed
endif

ifndef TMPDIR
TMPDIR = /tmp
endif

WORKDIR = $(TMPDIR)/aws-deploy-env

ifdef SHELL_DEBUG
	$(warning make features: $(.FEATURES))
endif

.PHONY: all
all:   $(WORKDIR) $(WORKDIR)/tool-versions.txt $(WORKDIR)/aws-caller-identity.txt
	echo success

$(WORKDIR):
	mkdir $@

# also making sure all the required tools are present
TOOLS := $(MAKE) aws  $(SHELL) $(SED) git
$(WORKDIR)/tool-versions.txt: Makefile
ifdef SHELL_DEBUG
	set -x
endif
	set -ue -o pipefail
	echo -n > $@

	for TOOL in $(TOOLS) ; do 
		$$TOOL --version | head -1 >> $@
	done

	echo "Using tool versions:"
	echo "-------------------"
	cat $@
	echo

# ensure user has working awscli
$(WORKDIR)/aws-caller-identity.txt: Makefile
ifdef SHELL_DEBUG
	set -x
endif
	set -ue -o pipefail
	aws sts get-caller-identity > $@
	echo "awscli login:"
	echo "------------"
	cat $@
	echo

.PHONY: clean
clean:
	rm -rf $(WORKDIR)
