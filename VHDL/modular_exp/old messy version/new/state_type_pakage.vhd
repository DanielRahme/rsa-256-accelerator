-- Package Declaration Section
package state_type_pakage is
type state_type is (inital, calculating, finished);
type sub_state_type is (prepare, send_to_mod_prod, waiting, recieve_from_mod_prod);
end package state_type_pakage;
 
-- Package Body Section
package body state_type_pakage is
 
end package body state_type_pakage;