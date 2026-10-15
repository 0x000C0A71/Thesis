#!/bin/bash


function dump_one() {
	improve=$(   grep -oP "improvement: \K.+"                   $1/index) || exit 1
	dropout=$(   grep -oP "dropout: Just \K.+"                  $1/index) || exit 2
	pre_edges=$( grep -oP "total edges: \K.+"                   $1/index) || exit 3
	post_edges=$(grep -oP "edges after dropout: \K.+"           $1/index) || exit 4
	evals=$(     grep -oP "eval count: \K.+"                    $1/index) || exit 5
	base=$(      grep -oP "exponential base \(x\^edges\): \K.+" $1/index) || exit 6
	exp=$(       grep -oP "bits to search \(2\^x\): \K.+"       $1/index) || exit 7
	b_metric=$(  grep -oP "quality baseline: \K.+"              $1/index) || exit 8
	o_metric=$(  grep -oP "quality ours: \K.+"                  $1/index) || exit 9
	r_eval=$(    grep -oP "eval rate: \K.+"                     $1/index) || exit 10

	local i_metric=""

	case "${improve}" in
		True)
			i_metric=$(awk -v b="${b_metric}" -v o="${o_metric}" 'BEGIN { printf "%.17g\n", o/b-1 }') || exit 11
			;;
		False)
			;;
		*)
			exit 12
	esac

	echo "${2},${dropout},${pre_edges},${post_edges},${evals},${base},${exp},${b_metric},${o_metric},${i_metric},${r_eval}"
}

dump_all() {
	echo "name,dropout,pre_edges,post_edges,evals,base,exp,b_metric,o_metric,i_metric,r_eval"
	dump_one mnist           "MNIST"
	dump_one unet            "UNet"
	dump_one cifar10         "Cifar10"
	dump_one diffusion       "Diffusion (S)"
	dump_one diffusion-large "Diffusion (L)"
	dump_one gpt-small       "GPT (S)"
	dump_one gpt             "GPT (M)"
	dump_one gpt-large       "GPT (L)"
}

function runtime_one() {
	b_mean=$(csvstat -c baseline  --decimal-format "%.18f" --mean $1/results.csv)              || exit 15
	o_mean=$(csvstat -c ours      --decimal-format "%.18f" --mean $1/results.csv)              || exit 16
	i_mean=$(awk -v b="${b_mean}" -v o="${o_mean}" 'BEGIN { printf "%.17g\n", b/o-1 }') || exit 17

	b_median=$(csvstat -c baseline  --decimal-format "%.18f" --median $1/results.csv)          || exit 18
	o_median=$(csvstat -c ours      --decimal-format "%.18f" --median $1/results.csv)          || exit 19
	i_median=$(awk -v b="${b_median}" -v o="${o_median}" 'BEGIN { printf "%.17g\n", b/o-1 }') || exit 20

	b_stdev=$(csvstat -c baseline  --decimal-format "%.18f" --stdev $1/results.csv)            || exit 21
	o_stdev=$(csvstat -c ours      --decimal-format "%.18f" --stdev $1/results.csv)            || exit 22

	echo "${2},${b_mean},${o_mean},${i_mean},${b_median},${o_median},${i_median},${b_stdev},${o_stdev}"
}

runtime_all() {
	echo "name,b_mean,o_mean,i_mean,b_median,o_median,i_median,b_stdev,o_stdev"
	runtime_one mnist           "MNIST"
	runtime_one diffusion-large "Diffusion (L)"
}

dump_all > summary.csv
runtime_all > summary-runtime.csv


