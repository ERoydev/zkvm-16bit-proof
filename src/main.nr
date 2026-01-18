use poseidon;

global STATE_CAPACITY: u32 = 20;

/// Takes sha256 hash converted to bn254 field
fn hash_field(one_field: Field) -> Field {
    poseidon::poseidon::bn254::hash_1([one_field])
}

fn main(
    // Public Inputs
    program_hash: Field,
    output_hash: Field,
    pub_program_state: [Field; STATE_CAPACITY],
    actual_state_len: u32,
    // Private Witness
    private_program_sha254: Field,
    private_output_sha254: Field,
    private_program_state: [Field; STATE_CAPACITY],
) {
    // Enforce program hash matches our program
    let calculated_program_hash = hash_field(private_program_sha254);
    assert(calculated_program_hash == program_hash);

    for curr_state in 0..STATE_CAPACITY {
        if curr_state < actual_state_len {
            let pub_state = pub_program_state[curr_state];
            let pos_hash_private_state = hash_field(private_program_state[curr_state]);
            assert(pub_state == pos_hash_private_state);
        }
    }

    // Final state commitment
    let calculated_output_hash = hash_field(private_output_sha254);
    assert(calculated_output_hash == output_hash);
}

#[test]
fn test_circuit_expected_behavior() {
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
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    ];

    // ===== Private witness =====
    let private_program_sh254 =
        12630064940486355474560008940412951592852515982109303420759129898107056307488;
    let private_program_state = [
        13104312851388067398452158410980007409935191118611534470130694987694392523325,
        9529981917706746317007056984476201760943194738692504998034558202249532772280,
        18654981179325678686938355387745637207498473067782124298690948001758219246857,
        18999759433657479019498956508185357286816584794271026992945844029707119334764,
        18589868827301183725254113024020713226611245982132117950491286358527976672999,
        13190984325669599884849940170655771152671914940933553896042924898286341111811,
        6074351881830694168047282561982111350499331315385337108301912210788932301654,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    ];

    let private_output_sha254 =
        8200953031481974930366339812552860190967038678546187478649906208479047754934;

    let actual_state_len: u32 = 7;

    main(
        program_hash,
        output_hash,
        pub_program_state,
        actual_state_len,
        private_program_sh254,
        private_output_sha254,
        private_program_state,
    );
}

#[test]
fn test_minimal_state() {
    let program_hash = 10299258156576067376321481439471656619278056506920354124431265275224066876462;
    let output_hash = 12403710014822892620040271914164698919015869120790648051970779227375399640613;
    let pub_program_state: [Field; STATE_CAPACITY] = [
        17334395722299672441718429218237777491516500674801380497891547466848781466880,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    ];
    let actual_state_len: u32 = 1;
    let private_program_sh254 = 12630064940486355474560008940412951592852515982109303420759129898107056307488;
    let private_output_sha254 = 8200953031481974930366339812552860190967038678546187478649906208479047754934;
    let private_program_state: [Field; STATE_CAPACITY] = [
        13104312851388067398452158410980007409935191118611534470130694987694392523325,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
    ];

    main(
        program_hash,
        output_hash,
        pub_program_state,
        actual_state_len,
        private_program_sh254,
        private_output_sha254,
        private_program_state,
    );
}

#[test]
fn test_maximal_state() {
    let program_hash = 10299258156576067376321481439471656619278056506920354124431265275224066876462;
    let output_hash = 12403710014822892620040271914164698919015869120790648051970779227375399640613;

    let temp_program_state = 17334395722299672441718429218237777491516500674801380497891547466848781466880;
    let mut pub_program_state: [Field; STATE_CAPACITY] = [0; STATE_CAPACITY];

    for i in 0..STATE_CAPACITY {
        pub_program_state[i] = temp_program_state;
    }
   
    let actual_state_len: u32 = 1;
    let private_program_sh254 = 12630064940486355474560008940412951592852515982109303420759129898107056307488;
    let private_output_sha254 = 8200953031481974930366339812552860190967038678546187478649906208479047754934;
    
    let temp_private_program_state = 13104312851388067398452158410980007409935191118611534470130694987694392523325;
    let mut private_program_state: [Field; STATE_CAPACITY] = [0; STATE_CAPACITY];

    for i in 0..STATE_CAPACITY {
        private_program_state[i] = temp_private_program_state;
    }

    main(
        program_hash,
        output_hash,
        pub_program_state,
        actual_state_len,
        private_program_sh254,
        private_output_sha254,
        private_program_state,
    );
}


#[test(should_fail)]
fn test_mismatched_state_should_fail() {
    let program_hash = 1000;
    let output_hash = 2000;
    let pub_program_state: [Field; STATE_CAPACITY] = [1,2,999,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    let actual_state_len: u32 = 5;
    let private_program_sh254 = 3000;
    let private_output_sha254 = 4000;
    let private_program_state: [Field; STATE_CAPACITY] = [6,7,888,9,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    main(
        program_hash,
        output_hash,
        pub_program_state,
        actual_state_len,
        private_program_sh254,
        private_output_sha254,
        private_program_state,
    );
}
