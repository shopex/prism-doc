sdk_repo := Java:shopex/prism-java \
			PHP:shopex/prism-php \
			C\#:shopex/prism-csharp \
			Go:shopex/prism-go \
			Python:shopex/prism-python \
			ios:shopex/prism-ios \
			Android:shopex/prism-android \
			NodeJS:shopex/prism-js

name = $(firstword $(subst :, ,$1))
url = $(or $(word 2,$(subst :, ,$1)),$(value 2))

all: sdk_doc
	mmi .
	mmi -json 1.developer
	mmi -json 2.api-provider
	mmi -json 3.admin
	mmi -json 4.technical

sdk_doc:
	@echo "Downloading SDK docs..."
	@for s in $(sdk_repo) ; do \
		((number=number+1)) ; \
		name=`echo $$s | sed -e 's/:.*//'` ;\
		project=`echo $$s | sed -e 's/.*://'` ;\
		url=https://raw.githubusercontent.com/$$project/master/README.md ;\
		filename=1.developer/3.sdk/$$number.`basename $$project`.md ;\
		echo $$name $$url;\
		echo "$$name" > $$filename ;\
		echo "==========" >> $$filename ;\
		echo "" >> $$filename ;\
		echo "项目主页: " https://github.com/$$project/ >> $$filename ;\
		echo "" >> $$filename ;\
		(curl -sS --resolve 103.245.222.133:443 $$url | tail -n +3 >> $$filename) \
	done

clean:
	find 1.developer/3.sdk/ -name "*.md" -not -name "README.md" -exec rm {} \;