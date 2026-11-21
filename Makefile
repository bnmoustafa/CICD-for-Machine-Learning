install:
	python -m pip install --upgrade pip
	python -m pip install -r requirements.txt

format:
	black *.py App/*.py

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
	if [ "$${GITHUB_EVENT_NAME}" = "pull_request" ]; then cml comment create report.md --target pr; else cml comment create report.md --target commit; fi

hf-login:
	hf auth login --token $(HF) --add-to-git-credential

push-hub:
	hf upload bnmoustafa/Drug-Classification ./App --repo-type=space --commit-message="Sync App files"
	hf upload bnmoustafa/Drug-Classification ./Model Model --repo-type=space --commit-message="Sync Model"
	hf upload bnmoustafa/Drug-Classification ./Results Metrics --repo-type=space --commit-message="Sync Metrics"

deploy: hf-login push-hub
