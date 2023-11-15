
LUA_GIT     = lua/lua
LUA_SRC     = $(CURDIR)/lua-5.4.6
LUA_SRC_URL = https://www.lua.org/ftp/lua-5.4.6.tar.gz

RTTR_GIT    = rttrorg/rttr
RTTR_DIR    = $(CURDIR)/rttr
RTTR_INST   = $(RTTR_DIR)/build/install
RTTR_PATCH  = $(CURDIR)/rttr-build.patch

RTTR_GIT_API =  "https://api.github.com/repos/$(RTTR_GIT)/releases/latest"
RTTR_DL_URL  := $(shell curl --request GET --url $(RTTR_GIT_API) 2>/dev/null | \
	jq -er ".assets[] | select(.name | test(\".tar.gz\")) | .browser_download_url")

BUILDDIR     =  $(CURDIR)/build

.PHONY: run all build
all:
	@

run: build
	$(BUILDDIR)/src/LuaTutorial

build: $(BUILDDIR)
	@make -C $(BUILDDIR)
$(BUILDDIR): lua rttr
	@cmake -B $(BUILDDIR) -DCMAKE_PREFIX_PATH=$(RTTR_INST)

.PHONY: install $(RTTR_DIR)/build $(BUILDDIR)
install: lua rttr

lua: $(LUA_SRC)/CMakeLists.txt  ## Build lua lib
$(LUA_SRC):
	@wget $(LUA_SRC_URL) && tar xvf lua-5.4.6.tar.gz
$(LUA_SRC)/CMakeLists.txt: $(LUA_SRC)
	@cp $(CURDIR)/lua-5.3.4/CMakeLists.txt $@

rttr: $(RTTR_INST)
$(RTTR_INST): $(RTTR_DIR)/build
	@cd $(RTTR_DIR)/build && make install
$(RTTR_DIR)/build: $(RTTR_DIR) ## Build rttr
	@cd $(RTTR_DIR) && cmake -B $(RTTR_DIR)/build            \
		-DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=off  \
		-DBUILD_UNIT_TESTS=off -DBUILD_DOCUMENTATION=off \
		-DBUILD_STATIC=on

$(RTTR_DIR):         ## Clone and patch rttr
	@git clone "https://github.com/$(RTTR_GIT)" $(RTTR_DIR)
	@cd $(RTTR_DIR) && git apply $(RTTR_PATCH)
# @echo "Downloading rttr from $(RTTR_DL_URL)"
# @wget $(RTTR_DL_URL)
# @tar xvf $(CURDIR)/rttr*

.PHONY: rttr_latest_release
rttr_latest_release: ## Find latest RTTR release
	curl --request GET --url $(RTTR_GIT_API) | jq -r '.tag_name'

.PHONY: clean distclean
clean:
	$(RM) -r *~ *.core *.o *.out *.exe 

distclean: clean
	$(RM) -rf $$(git ls-files --others --ignored --exclude-standard)
