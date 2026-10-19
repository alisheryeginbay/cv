# Builds the sample CV to preview template changes. Publishing lives in the cv-content repo.
# Fonts are vendored in fonts/ so local and CI builds render identically.
TYPST_FLAGS := --font-path fonts --ignore-system-fonts
OUT := example.pdf

.PHONY: all watch clean

all: $(OUT)

$(OUT): example.typ example.yaml template.typ $(wildcard fonts/*/*.otf)
	typst compile $(TYPST_FLAGS) example.typ $(OUT)

watch:
	typst watch $(TYPST_FLAGS) example.typ $(OUT)

clean:
	rm -f $(OUT)
