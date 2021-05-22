with MyStringTokeniser;
with SimpleStack;
with OPERATION;


package ReadCommand with SPARK_Mode is
    procedure Read (C: in String; NumTokens: in out Natural; T : in out MyStringTokeniser.TokenArray) with
     Pre => (if C'Length > 0 then C'First <= C'Last)  and T'Last >= T'First,
     Post => NumTokens <= T'Length and
     (for all Index in T'First..T'First+(NumTokens -1) =>
          (T(Index).Start >= C'First and T(Index).Length>0 ) and then T(Index).Length - 1 <= C'Last - T(Index).Start
     );
end ReadCommand;