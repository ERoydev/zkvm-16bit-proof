use poseidon;

fn hash_field(one_field: Field) -> Field {
    // Typically this takes a bn254 compatible field of Sha256 and hashes it using Poseidon
    poseidon::poseidon::bn254::hash_1([one_field])
}

// Each public input must be hashed with poseidon before being passed to the circuit
// Each private witness must be hashed using sha254

// sha254 represent raw data it is just compressed into a single field element
// poseidon represent public data, hidden that need to be used for proof generation

fn main(
    // Public Inputs
    program_hash: Field, // bn254 hash of the sha254 field
    output_hash: Field,
    pub_program_state: [Field; 7], // sha254 of the program state at each step
    // Private Witness
    raw_program: Field, // sha256 hash of the program, converted to bn254 field
    private_program_state: [Field; 7], // sha254 of the program state at each step
    private_output_state: Field, // sha254 of the final program state
) {
    // Enforce program hash matches our program
    let calculated_program_hash = hash_field(raw_program);
    assert(calculated_program_hash == program_hash);

    for curr_state in 0..7 {
        let pub_state = pub_program_state[curr_state];
        let pos_hash_private_state = hash_field(private_program_state[curr_state]);
        // Should validate that the state of (pc, registers, opcode, memory_subset) at each step matches
        assert(pub_state == pos_hash_private_state);
    }

    // Final state commitment
    let calculated_output_hash = hash_field(private_output_state);
    assert(calculated_output_hash == output_hash);
}

#[test]
fn test_circuit() {
    // ===== Public inputs =====
    let program_hash =
        10299258156576067376321481439471656619278056506920354124431265275224066876462;
    let output_hash = 12403710014822892620040271914164698919015869120790648051970779227375399640613;
    // Each hash is a combination of program state on each step (registers, pc, opcode, memory_subset)
    let pub_program_state = [
        17334395722299672441718429218237777491516500674801380497891547466848781466880,
        16665548319750628604219208683108605982529051533049782524124833339024484818570,
        19181372984671214253406088454799230807685453844665209980902419453551724694401,
        8409197684857838227183114338823273774417981650111201492890956757892432304134,
        8517350381380768011872193244691483077580564583972207126060806388957788747562,
        11414260848879985282266523951173779991216026823492290401607367610693283650825,
        12360729685463105665094322618100102879896613675529548458250874453564220012259,
    ];

    // ===== Private witness =====
    let raw_program = 12630064940486355474560008940412951592852515982109303420759129898107056307488;
    let private_program_state = [
        13104312851388067398452158410980007409935191118611534470130694987694392523325,
        9529981917706746317007056984476201760943194738692504998034558202249532772280,
        18654981179325678686938355387745637207498473067782124298690948001758219246857,
        18999759433657479019498956508185357286816584794271026992945844029707119334764,
        18589868827301183725254113024020713226611245982132117950491286358527976672999,
        13190984325669599884849940170655771152671914940933553896042924898286341111811,
        6074351881830694168047282561982111350499331315385337108301912210788932301654,
    ];
    let private_output_state =
        8200953031481974930366339812552860190967038678546187478649906208479047754934;

    main(
        program_hash,
        output_hash,
        pub_program_state,
        raw_program,
        private_program_state,
        private_output_state,
    );
}
