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

deploy:
	huggingface-cli upload bnmoustafa/drug-classification . --repo-type space --commit-message "Deploy from GitHub Actions"
