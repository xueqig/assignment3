with PIN; use PIN;
with MyStringTokeniser;
with MyString;




package passwordmanager with SPARK_Mode is
   

   procedure ReadCommand (C: in String; NumTokens: in out Natural; T : in out MyStringTokeniser.TokenArray) with
     Pre => (if C'Length > 0 then C'First <= C'Last)  and T'Last >= T'First,
     Post => NumTokens <= T'Length and
     (for all Index in T'First..T'First+(NumTokens -1) =>
          (T(Index).Start >= C'First and T(Index).Length>0 ) and then T(Index).Length - 1 <= C'Last - T(Index).Start
     );
   
   procedure Unlock (P1: in PIN.PIN; P2 : in PIN.PIN; isLocked : in out Boolean) with
     Pre => isLocked = True,
     Post => (if P1 = P2 then (isLocked = False));

   procedure Lock (isLocked: in out Boolean) with
     Pre => isLocked = False,
     Post => isLocked = True;
   
   function IsPin (input : in String) return Boolean with
     pre => (input'Length = 4 and input'First <= input'Last),
     post =>  (if IsPin'Result = True then
                (for all I in Input'First..Input'Last =>
                     (Input'First <= Input'Last
                      and input(I) >='0'
                      and Input(I) <= '9')));

   
end passwordmanager;
