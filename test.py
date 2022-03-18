def prettyfy_bin(a):
    q = bin(a)[2:]
    if len(q) == 1:
        return f"3'b00{q}"
    if len(q) == 2:
        return f"3'b0{q}"
    if len(q) == 3:
        return f"3'b{q}"

def prettyfy_bi(a):
    q = bin(a)[2:]
    if len(q) == 1:
        return f"2'b0{q}"
    if len(q) == 2:
        return f"2'b{q}"

def prettyfy_quad(a):
    q = bin(a)[2:]
    if len(q) == 1:
        return f"4'b000{q}"
    if len(q) == 2:
        return f"4'b00{q}"
    if len(q) == 3:
        return f"4'b0{q}"
    if len(q) == 4:
        return f"4'b{q}"

"""
for i in range(8):
    for j in range(8):
        ii = prettyfy_bin(i)
        jj = prettyfy_bin(j)
        if (i - j) > 0:
            dff = prettyfy_bi((i - j) % 3)
        else:
            dff = prettyfy_bi((3 + i - j) % 3)
        print(f"{{{ii}, {jj}}} : mod <= {dff};")
"""

for i in range(16):
    q = prettyfy_quad(i)
    r = prettyfy_bi(i % 3)
    print(f"{q} : mod <= {r};")
