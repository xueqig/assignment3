with Ada.Characters.Latin_1;

package MyStringTokeniser with SPARK_Mode is

   type TokenExtent is record
      Start : Positive;
      Length : Natural;
   end record;

   type TokenArray is array(Positive range <>) of TokenExtent;

   function Is_Whitespace(Ch : Character) return Boolean is
     (Ch = ' ' or Ch = Ada.Characters.Latin_1.LF or
        Ch = Ada.Characters.Latin_1.HT);

   procedure Tokenise(S : in String; Tokens : in out TokenArray; Count : out Natural) with
     Pre => (if S'Length > 0 then S'First <= S'Last) and Tokens'First <= Tokens'Last,
     Post => Count <= Tokens'Length and
     (for all Index in Tokens'First..Tokens'First+(Count-1) =>
          (Tokens(Index).Start >= S'First and
          Tokens(Index).Length > 0) and then
            Tokens(Index).Length-1 <= S'Last - Tokens(Index).Start);


   -- Task 1:
      -- Count <= Tokens'Length :
        -- The number of tokens must be not greater than the length of the token arrays, otherwise the array will be overflowed.
      -- (Tokens(Index).Start >= S'First:
        -- This condition is a basis of the relationship between the first elements of both record Token(Index) and String S.
      -- Tokens(Index).Length > 0:
        -- this postcondition impose restrictions on the length of the record and is helpful to keep the precondition of the
        -- function Substring used in main program , which claiming the relation From <= To between Positive From and To. Also,
        -- it could avoid range check failure.
      -- Tokens(Index).Length-1 <= S'Last - Tokens(Index).Start):
        -- this postcondition impose restrictions on the length of the record Tokens(Index),
        -- it reflects the outcomes of the loop invariant statement.
        -- Without this condition may violate the precondition of the function Substring when called in main program,
        -- which is To <= Length(M), where M belongs to MyString. Also, it could help avoid range check failure.




end MyStringTokeniser;
