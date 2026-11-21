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
	echo '![Confusion Matrix](./Results/confusion_matrix.png)' >> report.md
	if [ "${{ github.event_name }}" = "pull_request" ]; then cml comment create --pr report.md; else cml comment create report.md; fi
