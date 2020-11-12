import sys


def pp_bv(n, bv_size):
    s_fmt = "0{}x".format(int(bv_size / 4))
    return "#x{}".format(format(n, s_fmt))


# some constants
bvsize = int(sys.argv[1]) if len(sys.argv) > 1 else 64
limit = int(sys.argv[2]) if len(sys.argv) > 2 else 1000
one = pp_bv(1, bvsize)

print("Generating {} benchmark problems (size {})".format(limit, bvsize))

for i in range(limit):
    with open("p{}.smt2".format(i), 'w') as f:
        f.write("""
        (set-logic QF_BV)
        (declare-const a (_ BitVec {}))
        (assert (= (bvmul a {}) {}))
        (check-sat)
        (exit)
        """.format(bvsize, pp_bv(i, bvsize), one))


with open("incremental.smt2", 'w') as f:
    f.write("""
        (set-logic QF_BV)
        (declare-const a (_ BitVec {}))\n
    """.format(bvsize))
    for i in range(limit):
        f.write(
            """
            (push 1)
            (assert (= (bvmul a {}) {}))
            (check-sat)
            (pop 1)\n
            """.format(pp_bv(i, bvsize), one))
    f.write("(exit)")
