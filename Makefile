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

CFN_TEMPLATES = $(WORKDIR)/create-s3.yaml

.PHONY: all
all:   $(WORKDIR) $(WORKDIR)/tool-versions.txt $(WORKDIR)/aws-caller-identity.txt $(CFN_TEMPLATES)
	echo success

$(WORKDIR):
	mkdir $@

# also making sure all the required tools are present
TOOLS := $(MAKE) aws  $(SHELL) $(SED) git jinja2 cfn-lint
$(WORKDIR)/tool-versions.txt:
ifdef SHELL_DEBUG
	set -x
endif
	set -ue
	echo -n > $@

	for TOOL in $(TOOLS) ; do 
		$$TOOL --version | head -1 >> $@
	done

	echo "Using tool versions:"
	echo "-------------------"
	cat $@
	echo

# ensure user has working awscli
$(WORKDIR)/aws-caller-identity.txt:
ifdef SHELL_DEBUG
	set -x
endif
	set -ue
	aws sts get-caller-identity > $@
	echo "awscli login:"
	echo "------------"
	cat $@
	echo

.PHONY: clean
clean:
	rm -rf $(WORKDIR)

$(WORKDIR)/%.yaml : %.tmpl params.json
	jinja2 --format json --strict -o $@ $< params.json
	cfn-lint $@
