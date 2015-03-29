using PyCall

struc = get_structure("2HHB.pdb")

# Extremely rudimentary test, basically do we get anything back from our PyCall?
@test isa(struc,PyObject)

chains = get_chains(struc)

# Are the chains there? We expect two alpha and two beta chains
@test length(chains) == 4

# Are there enough c_alpha atoms? With enough coordinates?
@test size(chains[1]) == (141,3)
@test size(chains[2]) == (146,3)
@test size(chains[3]) == (141,3)
@test size(chains[4]) == (146,3)

# PDB export test
P = [31.132 16.439 58.160;
	 6.870 17.784 4.702
]

f = open("pdb_export_test.pdb")
pdb_expected = convert(Array{String,1},readlines(f))

pdb_handler(r::Test.Success) = rm("pdb_exported_test.pdb")

Test.with_handler(pdb_handler) do
	@test pdb_expected == export_to_pdb("VAL", "A", P, "pdb_exported_test.pdb")
end