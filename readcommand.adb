package body ReadCommand with SPARK_Mode is

    procedure Read(C: in String; NumTokens: in out Natural; T: in out MyStringTokeniser.TokenArray)
   is
      Tokens : MyStringTokeniser.TokenArray := T;
   begin
      if Tokens'First <= Tokens'Last then 
         MyStringTokeniser.Tokenise(C, Tokens, NumTokens);
         if NumTokens /= 0 then
            T:= Tokens;
         end if;
      end if;
   end Read;
end ReadCommand;