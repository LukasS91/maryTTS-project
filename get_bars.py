import numpy as np

CLEAN = True
NB_BINS = 50
MAX_DUR = 3
contexts = []
durations = []

# Loading Durations
with open("bound.feats") as f:
    for line in f:
        token = line.split()
        durations.append(float(token[0]))
        contexts.append(" ".join(token[1:]))

# Filtering
durations = np.array(durations)
if CLEAN:
    durations = np.extract(durations<MAX_DUR, durations)

# DURATIONS PART
## Histogram
hist = np.histogram(durations, NB_BINS)
with open("distribution_durations.csv", "w") as f:
    for i in range(len(hist[0])):
        f.write("%f\t%d\n" % (hist[1][i], hist[0][i]))

## Statistics
with open("statistics.csv", "w") as f:
    f.write("min\t%f\n" % np.min(durations))
    f.write("max\t%f\n" % np.max(durations))
    f.write("mean\t%f\n" % np.mean(durations))
    f.write("variance\t%f\n" % np.var(durations))
    f.write("standard deviation\t%f\n" % np.std(durations))

# Label parts
hash_ctx_count = {}
for c in contexts:
    if (c not in hash_ctx_count):
        hash_ctx_count[c] = 0
    hash_ctx_count[c] += 1

with open("distribution_labels.csv", "w") as f:
    for c in hash_ctx_count.keys():
        f.write("%d\t%s\n" % (hash_ctx_count[c], c))
