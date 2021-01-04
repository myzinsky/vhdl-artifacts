library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity init_1306 is
    PORT(
        clk     : in   std_logic;
        rst     : in   std_logic;
        start   : out  std_logic;
        ready   : in   std_logic;
        data    : out  std_logic_vector(7 downto 0);
        command : out  std_logic_vector(7 downto 0)
    );
end init_1306;

Architecture behavior of init_1306 is

    type state_t is (
         DOING,
         WAITING1,
         WAITING2,
         WAITING3,
         WAITING4,
         PICTURE,
         DONE
     );
     signal state : state_t := DOING;


    signal init_counter : unsigned(4 downto 0) := (others => '0');
    signal pix_counter : unsigned(9 downto 0) := (others => '0');

    type element is array (0 to 20) of std_logic_vector(15 downto 0);
    signal init_sequence : element := (
        x"00AE", -- Display Off
        x"00A8", -- Set Multiplex Ratio
        x"003F", -- 
        x"00D3", -- 
        x"0000", -- 
        x"0040", -- 
        x"00A1", -- 
        x"008C", -- 
        x"00DA", -- 
        x"0012", -- 
        x"0081", -- 
        x"00CF", -- 
        x"00A4", -- 
        x"00A6", -- 
        x"00D5", -- 
        x"0080", -- 
        x"008D", -- 
        x"0014", -- 
        x"00AF", -- 
        x"0020", -- 
        x"0000"
    );

begin

    init : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= DOING;
                init_counter <= (others => '0');
            else
                case state is
                    when DOING =>
                        if ready = '1' then
                           start    <= '1';
                           state    <= WAITING1;
                           command  <= init_sequence(to_integer(init_counter))(15 downto 8);
                           data     <= init_sequence(to_integer(init_counter))( 7 downto 0);
                           init_counter <= init_counter + 1;
                           if(init_counter = 20) then
                               state <= PICTURE;
                               start <= '0';
                           end if;
                        end if; 
                    when WAITING1 =>
                        if ready = '0' then
                            state <= WAITING2;
                        end if;
                    when WAITING2 =>
                        start <= '0';
                        if ready = '1' then
                            state <= DOING;
                        end if;
                    when PICTURE =>
                        if ready = '1' then
                           start    <= '1';
                           state    <= WAITING3;
                           command  <= x"40";
                           data     <= x"FF";
                           pix_counter <= pix_counter + 1;
                           if(pix_counter = 1023) then
                               state <= DONE;
                               start <= '0';
                           end if;
                        end if; 
                    when WAITING3 =>
                        if ready = '0' then
                            state <= WAITING4;
                        end if;
                    when WAITING4 =>
                        start <= '0';
                        if ready = '1' then
                            state <= PICTURE;
                        end if;
                    when DONE =>
                        start <= '0';
                        state <= DONE;
                        -- Stay here forever
                end case;
            end if;
        end if;
    end process;
end behavior;
