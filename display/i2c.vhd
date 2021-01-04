library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c is
    PORT(
        clk     : in     std_logic;
        rst     : in     std_logic;
        start   : in     std_logic;
        ready   : out    std_logic;
        rw      : in     std_logic;
        addr    : in     std_logic_vector(6 downto 0);
        command : in     std_logic_vector(7 downto 0);
        data    : in     std_logic_vector(7 downto 0);
        i2c_scl : out    std_logic;
        i2c_sda : out    std_logic
    );
end i2c;

Architecture behavior of i2c is

    signal scl           : std_logic := '0';
    signal idle_counter  : unsigned(25 downto 0) := (others => '0');
    signal clk_counter   : unsigned(25 downto 0) := (others => '0');
    signal data_counter  : unsigned( 3 downto 0) := (others => '0');
    signal addr_counter  : unsigned( 3 downto 0) := (others => '0');
    signal cmd_counter   : unsigned( 3 downto 0) := (others => '0');

    type state_t is (
        INITWAIT,
        IDLE,
        START_A, START_B, START_C, START_D, START_E, START_F,
        ADDR_A,  ADDR_B,  ADDR_C,  ADDR_D,
        RW_A,    RW_B,    RW_C,    RW_D, 
        ACKA_A,  ACKA_B,  ACKA_C,  ACKA_D, 
        PAUS_A,  PAUS_B,  PAUS_C,  PAUS_D, 
        CMD_A,   CMD_B,   CMD_C,   CMD_D,
        ACKC_A,  ACKC_B,  ACKC_C,  ACKC_D, 
        PAUC_A,  PAUC_B,  PAUC_C,  PAUC_D, 
        DATA_A,  DATA_B,  DATA_C,  DATA_D,
        ACKD_A,  ACKD_B,  ACKD_C,  ACKD_D, 
        STOP_A,  STOP_B,  STOP_C,  STOP_D, STOP_E, STOP_F
    );
    signal state : state_t := INITWAIT;

begin

    i2c_clock_generation : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                clk_counter  <= (others => '0');
            else
                clk_counter <= clk_counter + 1;        
                if(clk_counter = 60) then
                    scl <= not scl;
                    clk_counter <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    i2c_state_machine : process(scl)
    begin
        if rising_edge(scl) then

            if rst = '1' then
                data_counter <= (others => '0');
                addr_counter <= (others => '0');
                cmd_counter  <= (others => '0');
                state <= INITWAIT;
            else 
                --i2c_scl <= '1'; -- TODO
                --i2c_sda <= '1';

                case state is
                    when INITWAIT =>
                        i2c_scl <= '1';
                        i2c_sda <= '1';
                        if(idle_counter = 1024) then
                            state <= IDLE;
                            idle_counter <= (others => '0');
                        else
                            idle_counter <= idle_counter + 1;
                        end if;
                    when IDLE =>
                        ready <= '1';
                        if (start = '1') then
                            state        <= START_A;
                            data_counter <= (others => '0');
                        end if;
                    -------------------
                    when START_A =>
                        ready <= '0';
                        state <= START_B;
                    when START_B =>
                        i2c_sda <= '0';
                        state <= START_C;
                    when START_C =>
                        i2c_sda <= '0';
                        state <= START_D;
                    when START_D =>
                        i2c_sda <= '0';
                        state <= START_E;
                    when START_E =>
                        i2c_sda <= '0';
                        state <= START_F;
                    when START_F =>
                        i2c_sda <= '0';
                        state <= ADDR_A;
                    --------------------
                    when ADDR_A =>
                        i2c_scl <= '0';
                        i2c_sda <= addr(6-to_integer(addr_counter));
                        state <= ADDR_B;
                    when ADDR_B =>
                        i2c_scl <= '0';
                        i2c_sda <= addr(6-to_integer(addr_counter));
                        state <= ADDR_C;
                    when ADDR_C =>
                        i2c_scl <= '1';
                        i2c_sda <= addr(6-to_integer(addr_counter));
                        state <= ADDR_D;
                    when ADDR_D =>
                        i2c_scl <= '1';
                        i2c_sda <= addr(6-to_integer(addr_counter));
                        if addr_counter = 6 then
                            state <= RW_A;
                            addr_counter <= (others => '0');
                        else
                            state <= ADDR_A;
                            addr_counter <= addr_counter + 1;
                        end if;
                    --------------------
                    when RW_A =>
                        i2c_scl <= '0';
                        i2c_sda <= rw;
                        state <= RW_B;
                    when RW_B =>
                        i2c_scl <= '0';
                        i2c_sda <= rw;
                        state <= RW_C;
                    when RW_C =>
                        i2c_scl <= '1';
                        i2c_sda <= rw;
                        state <= RW_D;
                    when RW_D =>
                        i2c_scl <= '1';
                        i2c_sda <= rw;
                        state <= ACKA_A;
                    --------------------
                    when ACKA_A =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= ACKA_B;
                    when ACKA_B =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= ACKA_C;
                    when ACKA_C =>
                        i2c_scl <= '1';
                        i2c_sda <= '0';
                        state <= ACKA_D;
                    when ACKA_D =>
                        i2c_scl <= '1';
                        i2c_sda <= '0';
                        state <= PAUS_A;
                    --------------------
                    when PAUS_A =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= PAUS_B;
                    when PAUS_B =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= PAUS_C;
                    when PAUS_C =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= PAUS_D;
                    when PAUS_D =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= CMD_A;
                    --------------------
                    when CMD_A =>
                        i2c_scl <= '0';
                        i2c_sda <= command(7-to_integer(cmd_counter));
                        state <= CMD_B;
                    when CMD_B =>
                        i2c_scl <= '0';
                        i2c_sda <= command(7-to_integer(cmd_counter));
                        state <= CMD_C;
                    when CMD_C =>
                        i2c_scl <= '1';
                        i2c_sda <= command(7-to_integer(cmd_counter));
                        state <= CMD_D;
                    when CMD_D =>
                        i2c_scl <= '1';
                        i2c_sda <= command(7-to_integer(cmd_counter));
                        if cmd_counter = 7 then
                            state <= ACKC_A;
                            cmd_counter <= (others => '0');
                        else
                            state <= CMD_A;
                            cmd_counter <= cmd_counter + 1;
                        end if;
                    --------------------
                    when ACKC_A =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= ACKC_B;
                    when ACKC_B =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= ACKC_C;
                    when ACKC_C =>
                        i2c_scl <= '1';
                        i2c_sda <= '0';
                        state <= ACKC_D;
                    when ACKC_D =>
                        i2c_scl <= '1';
                        i2c_sda <= '0';
                        state <= PAUC_A;
                    --------------------
                    when PAUC_A =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= PAUC_B;
                    when PAUC_B =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= PAUC_C;
                    when PAUC_C =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= PAUC_D;
                    when PAUC_D =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= DATA_A;
                    --------------------
                    when DATA_A =>
                        i2c_scl <= '0';
                        i2c_sda <= data(7-to_integer(data_counter));
                        state <= DATA_B;
                    when DATA_B =>
                        i2c_scl <= '0';
                        i2c_sda <= data(7-to_integer(data_counter));
                        state <= DATA_C;
                    when DATA_C =>
                        i2c_scl <= '1';
                        i2c_sda <= data(7-to_integer(data_counter));
                        state <= DATA_D;
                    when DATA_D =>
                        i2c_scl <= '1';
                        i2c_sda <= data(7-to_integer(data_counter));
                        if data_counter = 7 then
                            state <= ACKD_A;
                            data_counter <= (others => '0');
                        else
                            state <= DATA_A;
                            data_counter <= data_counter + 1;
                        end if;
                    --------------------
                    when ACKD_A =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= ACKD_B;
                    when ACKD_B =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= ACKD_C;
                    when ACKD_C =>
                        i2c_scl <= '1';
                        i2c_sda <= '0';
                        state <= ACKD_D;
                    when ACKD_D =>
                        i2c_scl <= '1';
                        i2c_sda <= '0';
                        state <= STOP_A;
                    --------------------
                    when STOP_A =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= STOP_B;
                    when STOP_B =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= STOP_C;
                    when STOP_C =>
                        i2c_scl <= '0';
                        i2c_sda <= '0';
                        state <= STOP_D;
                    when STOP_D =>
                        i2c_scl <= '1';
                        i2c_sda <= '0';
                        state <= STOP_E;
                    when STOP_E =>
                        i2c_scl <= '1';
                        i2c_sda <= '0';
                        state <= STOP_F;
                    when STOP_F =>
                        i2c_scl <= '1';
                        i2c_sda <= '1';
                        state <= IDLE;
                        idle_counter <= (others => '0');
                end case;
            end if;
        end if;
    end process;

end behavior;
