library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2c is
    PORT(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        clk_enable : in  std_logic;
        i2c_scl    : out std_logic;
        i2c_sda    : out std_logic
    );
end i2c;

Architecture behavior of i2c is

    signal scl_trigger  : std_logic := '0';
    signal scl_int      : std_logic := '1';
    signal sda_int      : std_logic := '1';
    signal counter      : unsigned(5 downto 0) := (others => '0');

    signal data         : std_logic_vector(7 downto 0) := (others => '0');
    signal pixel        : std_logic_vector(7 downto 0) := (others => '0');
    signal addr         : std_logic_vector(6 downto 0) := "0111100";

    signal init_counter : unsigned(4 downto 0)  := (others => '0');
    signal pix_counter  : unsigned(10 downto 0) := (others => '0');

    type element is array (0 to 24) of std_logic_vector(7 downto 0);
    signal init_sequence : element := (
       x"AE", -- DISPLAYOFF
       x"D5", -- SETDISPLAYCLOCKDIV
       x"80", -- 
       x"A8", -- SETMULTIPLEX
       x"3F", --
       x"D3", -- SETDISPLAYOFFSET
       x"00", --
       x"40", -- SETSTARTLINE
       x"8D", -- CHARGEPUMP
       x"14", --
       x"20", -- MEMORYMODE
       x"00", -- 
       x"A1", -- SEGREMAP (or A0?)
       x"C8", -- COMSCANDEC
       x"DA", -- SETCOMPINS
       x"12", --
       x"81", -- SETCONTRAST
       x"CF", -- 
       x"D9", -- SETPRECHARGE 
       x"F1", -- 
       x"DB", -- SETVCOMDETECT 
       x"40", -- 
       x"A4", -- DISPLAYALLON_RESUME
       x"A6", -- NORMALDISPLAY
       x"AF"  -- DISPLAYON
    );

    type state_t is (
        S_START,
        S_TRANSMISSION,
        S_ADDR,
        S_COMMAND,
        S_INIT,
        S_PIC_COMMAND,
        S_PIC,
        S_STOP,
        S_IDLE
    );

    type phase_t is (
        P_INIT,
        P_PIC,
        P_END
    );

    signal state : state_t := S_START;
    signal next_state : state_t := S_START;
    signal phase : phase_t := P_INIT;

begin

    picture_memory : entity work.i2c_picture port map (
        addr   => pix_counter,
        output => pixel
    );


    i2c_scl <= scl_int;
    i2c_sda <= sda_int;

    state_machine : process(clk)
    begin
        if rising_edge(clk) then
            if reset_n = '0' then 
                counter      <= (others => '0');
                init_counter <= (others => '0');
                pix_counter  <= (others => '0');
                state        <= S_START;
                next_state   <= S_START;
                phase        <= P_INIT;
            elsif clk_enable = '1' then
                case state is
                    -------------------
                    when S_START =>
                        scl_int <= '1';
                        sda_int <= '1';

                        if counter >= 2 then
                           sda_int <= '0';
                        end if;
                        if counter >= 4 then
                           scl_int <= '0';
                        end if;
                        if counter = 6 then
                            state <= S_ADDR;
                            counter <= (others => '0') ;
                        else
                            counter <= counter + 1;
                        end if;
                    when S_STOP =>
                        scl_int <= '0';
                        sda_int <= '0';

                        if counter >= 2 then
                           scl_int <= '1';
                        end if;
                        if counter >= 4 then
                           sda_int <= '1';
                        end if;
                        if counter = 6 then
                            counter <= (others => '0') ;
                            if phase = P_END then 
                                state <= S_IDLE;
                            else
                                state <= S_START;
                            end if;
                        else
                            counter <= counter + 1;
                        end if;
                    -------------------
                    --          _______  ______
                    --  SDA ___/       \/      \_
                    --            ___       ___
                    --  SCL _____|   |_____|   |____
                    --        0    1    2    3    0
                    --
                    when S_TRANSMISSION =>
                        scl_int <= '0';
                        sda_int <= '1';
                        counter <= counter + 1;
                        
                        if    counter =  0 then sda_int <= data(7); -- Bit 0
                        elsif counter =  1 then sda_int <= data(7); scl_int <= '1';
                        elsif counter =  2 then sda_int <= data(7); scl_int <= '1';
                        elsif counter =  3 then sda_int <= data(7); 
                        elsif counter =  4 then sda_int <= data(6); -- Bit 1
                        elsif counter =  5 then sda_int <= data(6); scl_int <= '1';
                        elsif counter =  6 then sda_int <= data(6); scl_int <= '1';
                        elsif counter =  7 then sda_int <= data(6); 
                        elsif counter =  8 then sda_int <= data(5); -- Bit 2
                        elsif counter =  9 then sda_int <= data(5); scl_int <= '1';
                        elsif counter = 10 then sda_int <= data(5); scl_int <= '1';
                        elsif counter = 11 then sda_int <= data(5); 
                        elsif counter = 12 then sda_int <= data(4); -- Bit 4
                        elsif counter = 13 then sda_int <= data(4); scl_int <= '1';
                        elsif counter = 14 then sda_int <= data(4); scl_int <= '1';
                        elsif counter = 15 then sda_int <= data(4); 
                        elsif counter = 16 then sda_int <= data(3); -- Bit 5
                        elsif counter = 17 then sda_int <= data(3); scl_int <= '1';
                        elsif counter = 18 then sda_int <= data(3); scl_int <= '1';
                        elsif counter = 19 then sda_int <= data(3); 
                        elsif counter = 20 then sda_int <= data(2); -- Bit 6
                        elsif counter = 21 then sda_int <= data(2); scl_int <= '1';
                        elsif counter = 22 then sda_int <= data(2); scl_int <= '1';
                        elsif counter = 23 then sda_int <= data(2); 
                        elsif counter = 24 then sda_int <= data(1); -- Bit 6
                        elsif counter = 25 then sda_int <= data(1); scl_int <= '1';
                        elsif counter = 26 then sda_int <= data(1); scl_int <= '1';
                        elsif counter = 27 then sda_int <= data(1); 
                        elsif counter = 28 then sda_int <= data(0); -- Bit 7 WRITE
                        elsif counter = 29 then sda_int <= data(0); scl_int <= '1';
                        elsif counter = 30 then sda_int <= data(0); scl_int <= '1';
                        elsif counter = 31 then sda_int <= data(0); 
                        elsif counter = 32 then sda_int <= 'Z';     -- Bit 8 ACK
                        elsif counter = 33 then sda_int <= 'Z';     scl_int <= '1';
                        elsif counter = 34 then sda_int <= 'Z';     scl_int <= '1';
                        elsif counter = 35 then sda_int <= 'Z';     
                        elsif counter = 36 then sda_int <= '0';     -- PAUSE
                        elsif counter = 37 then sda_int <= '0';     
                            state   <= next_state;
                            counter <= (others => '0');
                        end if;
                    -------------------
                    when S_ADDR =>
                        data(7 downto 1) <= addr;
                        data(0) <= '0'; -- Write

                        if phase = P_INIT then
                            next_state <= S_COMMAND;
                        else -- P_PIC
                            next_state <= S_PIC_COMMAND;
                        end if;
                        state <= S_TRANSMISSION;
                    -------------------
                    when S_COMMAND =>
                        data       <= "00000000";
                        next_state <= S_INIT;
                        state      <= S_TRANSMISSION;
                    -------------------
                    when S_INIT => 
                        data <= init_sequence(to_integer(init_counter));
                        if init_counter < 24 then
                            next_state   <= S_INIT;
                            init_counter <= init_counter + 1;
                        else
                            phase        <= P_PIC; 
                            next_state   <= S_STOP;
                            init_counter <= (others => '0');
                        end if;
                        state <= S_TRANSMISSION;
                    -------------------
                    when S_PIC_COMMAND =>
                        data       <= "11000000"; -- TODO FIXME HERE IS A BUG! it only works as the following:
                        data(0)    <= '0';
                        next_state <= S_PIC;
                        state      <= S_TRANSMISSION;
                    -------------------
                    when S_PIC => 
                        data <= pixel;
                        if pix_counter < 1023 then
                            phase       <= P_PIC;
                            next_state  <= S_STOP;
                            pix_counter <= pix_counter + 1;
                        else
                            phase       <= P_END;
                            next_state  <= S_STOP;
                            pix_counter <= (others => '0');
                        end if;
                        state <= S_TRANSMISSION;
                    when others =>
                        state <= S_IDLE;
               end case;
            end if;
        end if;
    end process;
end behavior;
