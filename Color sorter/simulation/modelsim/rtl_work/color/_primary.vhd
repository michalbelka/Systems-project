library verilog;
use verilog.vl_types.all;
entity color is
    generic(
        PWM_length_left : vl_logic_vector(16 downto 0) := (Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        PWM_length_right: vl_logic_vector(16 downto 0) := (Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        PWM_length_red  : vl_logic_vector(16 downto 0) := (Hi1, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0);
        PWM_length_green: vl_logic_vector(16 downto 0) := (Hi1, Hi0, Hi1, Hi1, Hi1, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0);
        PWM_length_blue : vl_logic_vector(16 downto 0) := (Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        cycleAmount     : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        go              : in     vl_logic;
        pwm             : out    vl_logic;
        pwm_Pos         : out    vl_logic;
        posRed          : in     vl_logic;
        posGreen        : in     vl_logic;
        posBlue         : in     vl_logic;
        pwm_check       : out    vl_logic;
        left_check      : out    vl_logic;
        right_check     : out    vl_logic;
        posRed_check    : out    vl_logic;
        posBlue_check   : out    vl_logic;
        posGreen_check  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PWM_length_left : constant is 2;
    attribute mti_svvh_generic_type of PWM_length_right : constant is 2;
    attribute mti_svvh_generic_type of PWM_length_red : constant is 2;
    attribute mti_svvh_generic_type of PWM_length_green : constant is 2;
    attribute mti_svvh_generic_type of PWM_length_blue : constant is 2;
    attribute mti_svvh_generic_type of cycleAmount : constant is 2;
end color;
