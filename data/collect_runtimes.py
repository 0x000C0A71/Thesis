#!python

import pandas as pd
import numpy as np
from scipy.stats import mannwhitneyu



def data(df):
    baseline = df['baseline'].values
    optimal  = df['ours'    ].values

    # Mann Whitney U
    u_stat, p_val = mannwhitneyu(baseline, optimal, alternative='two-sided')
    print(f"Mann Whitney U = {u_stat}, p-value = {p_val}")

    # Bootstrap CI
    np.random.seed(6502)
    n_boot = 65816
    median_diffrs = []
    median_ratios = []

    for _ in range(n_boot):
        b_sample = np.random.choice(baseline, size=len(baseline), replace=True)
        o_sample = np.random.choice(optimal, size=len(optimal), replace=True)
        
        median_diffrs.append(np.median(b_sample) - np.median(o_sample))
        median_ratios.append(np.median(b_sample) / np.median(o_sample))

    diffr_ci = np.percentile(median_diffrs, [2.5, 97.5])
    ratio_ci = np.percentile(median_ratios, [2.5, 97.5])

    o_median = np.median(optimal)
    b_median = np.median(baseline)
    f_median = b_median / o_median

    print(f"Median Difference: {o_median - b_median}")
    print(f"95% CI for Median Difference: [{diffr_ci[0]}, {diffr_ci[1]}]")

    print(f"Median Ratio: {f_median}")
    print(f"95% CI for Median Ratio: [{ratio_ci[0]}, {ratio_ci[1]}]")


    o_mean = np.mean(optimal)
    b_mean = np.mean(baseline)
    f_mean = b_mean / o_mean

    o_stdev = np.std(optimal)
    b_stdev = np.std(baseline)

    return u_stat, p_val, diffr_ci, ratio_ci, (b_median, o_median, f_median), (b_mean, o_mean, f_mean), (o_stdev, b_stdev)



_, mp_val, _, (mratci_l, mratci_u), (mb_med, mo_med, mf_med), (mb_mean, mo_mean, mf_mean), (mo_std, mb_std) = data(pd.read_csv('mnist/results.csv'))
_, dp_val, _, (dratci_l, dratci_u), (db_med, do_med, df_med), (db_mean, do_mean, df_mean), (do_std, db_std) = data(pd.read_csv('diffusion-large/results.csv'))

pd.DataFrame({
    "stat_name" : ["Mean", "Median", "Std. Dev."],
    "m_baseline": [mb_mean, mb_med, mb_std],
    "m_optimal" : [mo_mean, mo_med, mo_std],
    "m_impr"    : [mf_mean, mf_med, None  ],

    "d_baseline": [db_mean, db_med, db_std],
    "d_optimal" : [do_mean, do_med, do_std],
    "d_impr"    : [df_mean, df_med, None  ],
}).to_csv("runtimes.csv", index=False)


pd.DataFrame({
    "benchmark": ["MNIST", "Diffusion (L)"],
    "p_val"    : [mp_val, dp_val],
    "miciu"    : [mratci_u, dratci_u],
    "micil"    : [mratci_l, dratci_l],
}).to_csv("relevance.csv", index=False)




