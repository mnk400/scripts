INSTALL_DIR = "/usr/local/bin"
UTILS_BIN = "${INSTALL_DIR}/bashutils"

install : 
		@echo "Installing bashutils"
		@if ! test -d $(UTILS_BIN); \
     	then mkdir $(UTILS_BIN); \
     	fi
		@cp bashutils/echocolors.sh $(UTILS_BIN)

		@echo "Installing syncnas"
		@chmod +x syncnas/syncnas.sh
		@cp syncnas/syncnas.sh $(INSTALL_DIR)

		@echo "Installing updatedots"
		@chmod +x updatedots/updatedots.sh
		@cp updatedots/updatedots.sh $(INSTALL_DIR)

uninstall : 
		@echo "Removing syncnas"
		@rm "${INSTALL_DIR}/syncnas.sh"

		@echo "Removing updatedots"
		@rm "${INSTALL_DIR}/updatedots.sh"

uninstallutils :
		@echo "Removing bashutils"
		@rm "${INSTALL_DIR}/bashutils/echocolors.sh"