output = l

all: l.sh lsformat.awk
	@echo "Merging $^ into $(output)"
	bash build.sh $(output)
test:
	@echo "todo: testing"
