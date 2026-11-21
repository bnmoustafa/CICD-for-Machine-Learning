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
	echo '\n## Confusion Matrix Plot' >> report.md
	printf '![Confusion Matrix](data:image/png;base64,%s)\n' "$$(base64 -w 0 ./Results/confusion_matrix.png)" >> report.md
	if [ "$$GITHUB_EVENT_NAME" = "pull_request" ]; then cml comment create --pr report.md; else cml comment create report.md; fi

update-branch:
	git config --global user.name $(USER_NAME)
	git config --global user.email $(USER_EMAIL)
	git commit -am "Update with new results"
	git push --force origin HEAD:update

hf-login:
	git fetch origin update
	git checkout -B update origin/update
	pip install -U "huggingface_hub[cli]"
	huggingface-cli login --token $(HF) --add-to-git-credential

push-hub:
	huggingface-cli upload bnmoustafa/Drug-Classification ./App --repo-type=space --commit-message="Sync App files"
	huggingface-cli upload bnmoustafa/Drug-Classification ./Model /Model --repo-type=space --commit-message="Sync Model"
	huggingface-cli upload bnmoustafa/Drug-Classification ./Results /Metrics --repo-type=space --commit-message="Sync Metrics"

deploy: hf-login push-hub
