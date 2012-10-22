library verilog;
use verilog.vl_types.all;
entity lab2 is
    generic(
        PWM_length_left : vl_logic_vector(16 downto 0) := (Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        PWM_length_mid  : vl_logic_vector(16 downto 0) := (Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0);
        PWM_length_right: vl_logic_vector(16 downto 0) := (Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        pwm             : out    vl_logic;
        pwm_check       : out    vl_logic;
        left_check      : out    vl_logic;
        right_check     : out    vl_logic;
        mid_check       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PWM_length_left : constant is 2;
    attribute mti_svvh_generic_type of PWM_length_mid : constant is 2;
    attribute mti_svvh_generic_type of PWM_length_right : constant is 2;
end lab2;
