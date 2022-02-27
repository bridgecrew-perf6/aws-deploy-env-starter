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
all:   $(WORKDIR) $(WORKDIR)/tool-versions.txt $(WORKDIR)/aws-caller-identity.txt $(CFN_TEMPLATES) $(WORKDIR)/mock-invoke-url.txt
	curl -s $$(cat $(WORKDIR)/mock-invoke-url.txt)/greet/person
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

# deploy mock
$(WORKDIR)/mock-invoke-url.txt: create-apigateway.yaml
ifdef SHELL_DEBUG
	set -x
endif
	set -ue
	STACK_NAME=apigateway-stack
	aws cloudformation validate-template --template-body file://$< > /dev/null
	cfn-lint $<
	aws cloudformation create-stack --stack-name $${STACK_NAME} --template-body file://$<

	for CNT in {1..20} ; do
	  sleep 3
	  aws cloudformation describe-stack-events --stack-name $${STACK_NAME} --max-items 1 --output text --query "StackEvents[0].[LogicalResourceId, ResourceType, Timestamp, ResourceStatus]" | head -1
	  RESULT=$$(aws cloudformation describe-stacks --stack-name $${STACK_NAME} --output text --query "Stacks[0].StackStatus")

	  if [ $$RESULT == "CREATE_COMPLETE" ] ; then
	    break
	  fi
	done

	RESULT=$$(aws cloudformation describe-stacks --stack-name $${STACK_NAME} --output text --query "Stacks[0].StackStatus")

	if [ $$RESULT == "CREATE_COMPLETE" ] ; then
	  aws cloudformation describe-stacks --stack-name $${STACK_NAME} --query "Stacks[0].Outputs[?OutputKey=='ApiInvokeUrl'].OutputValue" --output text > $@
	else
	  exit 1
	fi

.PHONY: clean
clean:
	rm -rf $(WORKDIR)

$(WORKDIR)/%.yaml : %.tmpl params.json
	jinja2 --format json --strict -o $@ $< params.json
	cfn-lint $@
