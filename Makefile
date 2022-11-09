banner:
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

istio:
	@echo "[istio] Installing istio"
	@./bin/istio.sh

terraform:
	@echo "[terraform] Creating cluster system services with terraform"
	@./bin/terraform.sh

deploy: istio terraform

destroy:
	@echo "[bootstrap] Destroying cluster infrastructure"
	@cd terraform && terraform destroy -var-file="variables.tfvars"
