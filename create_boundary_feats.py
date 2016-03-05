with open("dur.feats") as f:
    with open("bound.feats", "a") as g:
        for line in f:
            token = line.split()
            if token[1] == "_":
                g.write(line)
