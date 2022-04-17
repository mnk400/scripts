INSTALL_DIR = "/usr/local/bin"
UTILS_BIN = "${INSTALL_DIR}/bashutils"

install : 
		@echo "Installing bashutils"
		@if ! test -d $(UTILS_BIN); \
     	then mkdir $(UTILS_BIN); \
     	fi
		@cp bashutils/echocolors.sh $(UTILS_BIN)

		@echo "Installing syncnas"
		@cp syncnas/syncnas.sh $(INSTALL_DIR)

uninstall : 
		@echo "Removing syncnas"
		@rm "${INSTALL_DIR}/syncnas.sh"