with PIN; use PIN;
with MyStringTokeniser;
with MyString;

package PinManager with SPARK_Mode is
   
   procedure Unlock (P1: in PIN.PIN; P2 : in PIN.PIN; isLocked : in out Boolean) with
     Pre => isLocked = True,
     Post => (if P1 = P2 then (isLocked = False));

   procedure Lock (isLocked: in out Boolean; validPin : in Boolean) with
     Pre => isLocked = False,
     Post => (if validPin then (isLocked = True));
   
   function IsPin (input : in String) return Boolean with
     pre => (if input'length > 0 then (input'First <= input'Last)),
     post =>  (if IsPin'Result = True then
                 (for all I in Input'First..Input'Last =>
                      (Input'First <= Input'Last
                       and input(I) >='0'
                       and Input(I) <= '9'))) and 
       (if IsPin'Result = True then input'Length = 4);

   
end PinManager;
