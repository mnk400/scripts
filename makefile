INSTALL_DIR = "/usr/local/bin"

install : 
		@echo "Installing bashutils"
		@cp bashutils/echocolors.sh $(INSTALL_DIR)
		@cp bashutils/utilmethods.sh $(INSTALL_DIR)

		@echo "Installing syncnas"
		@chmod +x nas/syncnas.sh
		@cp nas/syncnas.sh $(INSTALL_DIR)

		@echo "Installing updatedots"
		@chmod +x dotfiles/updatedots.sh
		@cp dotfiles/updatedots.sh $(INSTALL_DIR)

uninstall : 
		@echo "Removing syncnas"
		@rm "${INSTALL_DIR}/syncnas.sh"

		@echo "Removing updatedots"
		@rm "${INSTALL_DIR}/updatedots.sh"

uninstallutils :
		@echo "Removing bashutils"
		@rm "${INSTALL_DIR}/echocolors.sh"
		@rm "${INSTALL_DIR}/utilmethods.sh"