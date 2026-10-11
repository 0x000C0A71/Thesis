
.PHONY: summary clean


summary: collect_data.sh mnist/index cifar10/index unet/index diffusion/index diffusion-large/index gpt-small/index gpt/index gpt-large/index
	./collect_data.sh

clean:
	rm -f summary.csv
	rm -f summary-runtime.csv
