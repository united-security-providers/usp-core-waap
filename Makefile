HUGO_VERSION := 0.165.0
PAGEFIND_VERSION := 1.5.2

BIN := bin
HUGO := $(BIN)/hugo-$(HUGO_VERSION)
PAGEFIND := $(BIN)/pagefind-$(PAGEFIND_VERSION)

HUGO_BASE := https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)
HUGO_ASSET := hugo_extended_$(HUGO_VERSION)_linux-amd64.tar.gz
PAGEFIND_BASE := https://github.com/Pagefind/pagefind/releases/download/v$(PAGEFIND_VERSION)
PAGEFIND_ASSET := pagefind_extended-v$(PAGEFIND_VERSION)-x86_64-unknown-linux-musl.tar.gz

THEME := github.com/united-security-providers/usp-docs-hugo-theme
THEME_VERSION ?= latest

DEV_VERSION := latest
RELEASE_VERSION = $(firstword $(subst /, ,$(RELEASE)))
RELEASE_EXTRA = $(word 2,$(subst /, ,$(RELEASE)))

.PHONY: download-tools
download-tools: $(HUGO) $(PAGEFIND)

$(HUGO):
	@mkdir -p $(BIN)
	@echo "Fetching Hugo $(HUGO_VERSION) into $(BIN)/"
	@tmp=$$(mktemp -d) && trap 'rm -rf "$$tmp"' EXIT && \
	  curl -sSfL -o "$$tmp/asset" "$(HUGO_BASE)/$(HUGO_ASSET)" && \
	  curl -sSfL "$(HUGO_BASE)/hugo_$(HUGO_VERSION)_checksums.txt" \
	    | grep " $(HUGO_ASSET)$$" | sed 's|$(HUGO_ASSET)|asset|' > "$$tmp/sum" && \
	  (cd "$$tmp" && sha256sum -c sum > /dev/null) && \
	  tar -xzf "$$tmp/asset" -C "$$tmp" hugo && \
	  mv "$$tmp/hugo" "$@" && chmod +x "$@"

$(PAGEFIND):
	@mkdir -p $(BIN)
	@echo "Fetching Pagefind $(PAGEFIND_VERSION) into $(BIN)/"
	@tmp=$$(mktemp -d) && trap 'rm -rf "$$tmp"' EXIT && \
	  curl -sSfL -o "$$tmp/asset" "$(PAGEFIND_BASE)/$(PAGEFIND_ASSET)" && \
	  curl -sSfL "$(PAGEFIND_BASE)/$(PAGEFIND_ASSET).sha256" \
	    | sed 's|$(PAGEFIND_ASSET)|asset|' > "$$tmp/sum" && \
	  (cd "$$tmp" && sha256sum -c sum > /dev/null) && \
	  tar -xzf "$$tmp/asset" -C "$$tmp" pagefind_extended && \
	  mv "$$tmp/pagefind_extended" "$@" && chmod +x "$@"

.PHONY: build
build: download-tools
	$(HUGO) --gc --cleanDestinationDir
	rm -rf static/pagefind
	$(PAGEFIND) --site public \
	            --output-path static/pagefind \
	            --root-selector 'article.usp-prose'
	$(HUGO) --gc --cleanDestinationDir

.PHONY: serve
serve: build
	$(HUGO) server

.PHONY: update-theme
update-theme: $(HUGO)
	$(HUGO) mod get $(THEME)@$(THEME_VERSION)
	$(HUGO) mod tidy

.PHONY: prepare-release
prepare-release:
	@{ test -n "$(RELEASE_VERSION)" && test -z "$(RELEASE_EXTRA)"; } || \
	  { echo "Usage: make prepare-release RELEASE=<version>, for example RELEASE=2.2.x"; exit 1; }
	@test "$(RELEASE_VERSION)" != "$(DEV_VERSION)" || \
	  { echo "$(DEV_VERSION) is the documentation under development, not a release"; exit 1; }
	@test -d content/en/$(DEV_VERSION) || \
	  { echo "No such documentation: content/en/$(DEV_VERSION)"; exit 1; }
	@test ! -e content/en/$(RELEASE) || \
	  { echo "Already exists: content/en/$(RELEASE)"; exit 1; }
	@cp -r content/en/$(DEV_VERSION) content/en/$(RELEASE)
	@echo "Froze content/en/$(DEV_VERSION) as content/en/$(RELEASE)."

.PHONY: clean
clean:
	rm -rf public resources static/pagefind .hugo_build.lock

.PHONY: clean-tools
clean-tools:
	rm -rf $(BIN)
