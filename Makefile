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

istio: banner
	@echo "[istio] Installing istio"
	@./bin/istio-deploy.sh

terraform: banner terraform.init terraform.validate terraform.apply

terraform.init: banner
	@echo "[terraform] Initializing cluster infrastructure with terraform"
	@./bin/terraform-init.sh

terraform.validate: banner
	@echo "[terraform] Validate cluster infrastructure with terraform"
	@./bin/terraform-validate.sh

terraform.plan: banner
	@echo "[terraform] Plan cluster infrastructure with terraform"
	@./bin/terraform-plan.sh

terraform.apply: banner
	@echo "[terraform] Creating cluster infrastructure with terraform"
	@./bin/terraform-apply.sh

deploy: istio terraform

destroy:
	@echo "[bootstrap] Destroying cluster infrastructure"
	@cd terraform && terraform destroy -var-file="variables.tfvars"
