import random

with open("randC1010.txt", "w") as f:
    for i in range(1, 1011):
        f.write(".word ")
        for j in range(1, 1010):
            # rand = random.randint(1, 9)
            rand = 0
            if j == 512:
                f.write(str(rand))
                break
            f.write(str(rand) + ", ")
        f.write("\n")