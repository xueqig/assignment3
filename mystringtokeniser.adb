
package body MyStringTokeniser with SPARK_Mode is



   procedure Tokenise(S : in String; Tokens : in out TokenArray; Count : out Natural) is
      Index : Positive;
      Extent : TokenExtent;
      OutIndex : Integer := Tokens'First;
   begin
      Count := 0;
      if (S'First > S'Last) then
         return;
      end if;
      Index := S'First;
      while OutIndex <= Tokens'Last and Index <= S'Last and Count < Tokens'Length loop
         pragma Loop_Invariant
           (for all J in Tokens'First..OutIndex-1 =>
              (Tokens(J).Start >= S'First and
                   Tokens(J).Length > 0) and then
            Tokens(J).Length-1 <= S'Last - Tokens(J).Start);

         pragma Loop_Invariant (OutIndex = Tokens'First + Count);

         -- Task 1:
         -- The above loop invariant specifies the relationship always holds
         -- among 'OutIndex','Token'First' and 'Count' after each loop iteration. And there are some reasons to make it necessary
         -- 1. It avoided the possibility of integer overflow in the for each loop iteration mentioned in the above loop invariant.
         -- For example, without this invariant, when OutIndex equals to Integer'First, OutIndex-1 will lead to overflow.
         -- 2. Keeping the index check in line "Tokens(OutIndex) := Extent" always true.
         -- For instance, if without this, when OutIndex equals to 0 and Token'First equals to 1, the array index check will fail.
         -- 3. Impose the postcondition of procedure Tokenise, especailly to Tokens(Index).Length > 0,
         -- a counter example will be like when the Index equals to (Positive'Last-1), Start => 1 and Length => 0, which cannot
         -- satisfy the required postcondition.


         -- look for start of next token
         while (Index >= S'First and Index < S'Last) and then Is_Whitespace(S(Index)) loop
            Index := Index + 1;
         end loop;
         if (Index >= S'First and Index <= S'Last) and then not Is_Whitespace(S(Index)) then
            -- found a token
            Extent.Start := Index;
            Extent.Length := 0;

            -- look for end of this token
            while Positive'Last - Extent.Length >= Index and then (Index+Extent.Length >= S'First and Index+Extent.Length <= S'Last) and then not Is_Whitespace(S(Index+Extent.Length)) loop
               Extent.Length := Extent.Length + 1;
            end loop;

            Tokens(OutIndex) := Extent;
            Count := Count + 1;

            -- check for last possible token, avoids overflow when incrementing OutIndex
            if (OutIndex = Tokens'Last) then
               return;
            else
               OutIndex := OutIndex + 1;
            end if;

            -- check for end of string, avoids overflow when incrementing Index
            if S'Last - Extent.Length < Index then
               return;
            else
               Index := Index + Extent.Length;
            end if;
         end if;
      end loop;
   end Tokenise;

end MyStringTokeniser;
