ifneq (,)
This makefile requires GNU Make.
endif

.NOTPARALLEL:
.SILENT:
.ONESHELL: 

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

.PHONY: all
all:  $(WORKDIR)/tool-versions.txt 
	echo success

$(WORKDIR):
	mkdir $@

TOOLS := $(MAKE) aws  $(SHELL) $(SED) git
$(WORKDIR)/tool-versions.txt: Makefile $(WORKDIR)
	set -ue -o pipefail
	echo -n > $@

	for TOOL in $(TOOLS) ; do 
		$$TOOL --version | head -1 >> $@
	done

	echo "Using tool versions:"
	echo "-------------------"
	cat $@
	echo

clean:
	rm -rf $(WORKDIR)
