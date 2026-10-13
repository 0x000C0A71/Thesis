
.PHONY: summary clean


summary: collect_data.sh
	./collect_data.sh

runtimes: collect_runtimes.py
	./collect_runtimes.py

clean:
	rm -f summary.csv
	rm -f summary-runtime.csv
