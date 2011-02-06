PEXPORTS=pexports
PDCURSES_DIR=pdcurses
PDCURSESW32_DIR=pdcurses-win32a
PDCURSESDLL=$(PDCURSES_DIR)/pdcurses.dll
PDCURSESDEF=$(PDCURSES_DIR)/pdcurses.def
PDCURSESLIB=$(PDCURSES_DIR)/pdcurses.lib
PDCURSESW32DLL=$(PDCURSESW32_DIR)/pdcurses.dll
PDCURSESW32DEF=$(PDCURSESW32_DIR)/pdcurses.def
PDCURSESW32LIB=$(PDCURSESW32_DIR)/pdcurses.lib
SED=sed
DLLTOOL=dlltool
RM=rm
CP=cp
MKDIR=mkdir
GEN_DIR=gen
BUILD=build
PDCURSES_BUILD=$(PDCURSES_DIR)/build
PDCURSESW32_BUILD=$(PDCURSESW32_DIR)/build
DIST=dist
PDCURSES_DIST=$(PDCURSES_DIR)/dist
PDCURSESW32_DIST=$(PDCURSESW32_DIR)/dist
SETUP_TEMPLATE=setup.py_template
MANIFEST=MANIFEST.in

all: gen pdcurses-setup.py pdcurses-win32a-setup.py

$(PDCURSESW32_DIR):
	$(MKDIR) $(PDCURSEW32_DIR)

$(PDCURSESW_DIR):
	$(MKDIR) $(PDCURSEW_DIR)

$(PDCURSESDEF):
	$(PEXPORTS) $(PDCURSESDLL) | $(SED) -e "s/^_//g" > $(PDCURSESDEF)

$(PDCURSESLIB): $(PDCURSESDEF)
	$(DLLTOOL) --dllname $(PDCURSESDLL) --def $(PDCURSESDEF) --output-lib $(PDCURSESLIB)

$(PDCURSESW32DEF):
	$(PEXPORTS) $(PDCURSESW32DLL) | $(SED) -e "s/^_//g" > $(PDCURSESW32DEF)

$(PDCURSESW32LIB): $(PDCURSESW32DEF)
	$(DLLTOOL) --dllname $(PDCURSESW32DLL) --def $(PDCURSESW32DEF) --output-lib $(PDCURSESW32LIB)

pdcurses-setup.py: $(PDCURSES_DIR)
	$(SED) -e s/PDCURSES_FLAV// $(SETUP_TEMPLATE) > $(PDCURSES_DIR)/setup.py

pdcurses-win32a-setup.py: $(PDCURSESW32_DIR)
	$(SED) -e s/PDCURSES_FLAV/-win32a/ $(SETUP_TEMPLATE) > $(PDCURSESW32_DIR)/setup.py

defs: $(PDCURSESDEF) $(PDCURSESW32DEF)

libs: $(PDCURSESLIB) $(PDCURSESW32LIB)

gen: defs libs
	$(CP) *.h *.c $(MANIFEST) $(PDCURSESW32_DIR)
	$(CP) *.h *.c $(MANIFEST) $(PDCURSES_DIR)

gen-save: defs libs
	$(CP) $(PDCURSESDEF) $(PDCURSESLIB) $(GEN_DIR)
	$(CP) $(PDCURSESW32DEF) $(GEN_DIR)/pdcurses-win32.def
	$(CP) $(PDCURSESW32LIB) $(GEN_DIR)/pdcurses-win32.lib

clean:
	$(RM) -f $(PDCURSESDEF) $(PDCURSESLIB)
	$(RM) -f $(PDCURSESW32DEF) $(PDCURSESW32LIB)
	$(RM) -rf $(BUILD) $(PDCURSES_BUILD) $(PDCURSESW32_BUILD)
	$(RM) -rf $(DIST) $(PDCURSES_DIST) $(PDCURSESW32_DIST)
	$(RM) -rf $(PDCURSESW32_DIR)/*.h $(PDCURSESW32_DIR)/*.c
	$(RM) -rf $(PDCURSES_DIR)/*.h $(PDCURSES_DIR)/*.c

