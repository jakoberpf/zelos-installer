# https://makefiletutorial.com/
all: banner vault # tooling before vault

banner: # Typo: Allogator2 from https://manytools.org/hacker-tools/ascii-banner/
	@echo "################################################################"
	@echo "##                                                            ##"
	@echo "##    ::::::::: :::::::::: :::        ::::::::   ::::::::     ##"
	@echo "##         :+:  :+:        :+:       :+:    :+: :+:    :+:    ##"
	@echo "##        +:+   +:+        +:+       +:+    +:+ +:+           ##"
	@echo "##       +#+    +#++:++#   +#+       +#+    +:+ +#++:++#++    ##"
	@echo "##      +#+     +#+        +#+       +#+    +#+        +#+    ##"
	@echo "##     #+#      #+#        #+#       #+#    #+# #+#    #+#    ##"
	@echo "##    ######### ########## ########## ########   ########     ##"
	@echo "##                                                            ##"
	@echo "################################################################"
	@echo "                                                                "

vault: all
	@echo "[vault] Getting configuration and secrets from Vault"
	@./bin/vault.sh

terraform: all
	@echo "[terraform] Creating cluster system services with terraform"
	@./bin/terraform.sh

deploy: all terraform
	@echo "[installer] Running installer"

destroy: all
	@echo "[bootstrap] Destroying cluster infrastructure"
	@cd terraform && terraform destroy -var-file="variables.tfvars"
