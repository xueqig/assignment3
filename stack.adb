with Ada.Text_IO; use Ada.Text_IO;
with VariableStore;
with StringToInteger;

package body Stack is
   DB : VariableStore.Database;

   procedure Init_Stack(Stack: out Stack_Type) is
   begin
      Stack.Size := 0;
      Stack.Data := (others => 0);
   end Init_Stack;


   procedure Push(Stack: in out Stack_Type; Value : in Integer) is
   begin
      Stack.Size := Stack.Size + 1;
      Stack.Data(Stack.Size) := Value;
   end Push;

   procedure Pop(Stack : in out Stack_Type; Value : out Integer) is
   begin
      Value := Stack.Data(Stack.Size);
      Stack.Size := Stack.Size - 1;
   end Pop;

   procedure Load(Stack : in out Stack_Type; Variable : in String) is
      Var : VariableStore.Variable := VariableStore.From_String(Variable);
      Val : Integer := VariableStore.Get(DB, Var);
   begin
      Push(Stack, Val);
   end Load;

   procedure Store(Stack: in out Stack_Type; Variable: in String) is
      Var : VariableStore.Variable := VariableStore.From_String(Variable);
      Val : Integer;
   begin
      Pop(Stack, Val);
      VariableStore.Put(DB, Var, Val);
   end Store;

   procedure List is
   begin
      VariableStore.Print(DB);
   end List;

   procedure Remove(Variable: in String) is
      Var : VariableStore.Variable := VariableStore.From_String(Variable);
   begin
      VariableStore.Remove(DB, Var);
   end Remove;

   function Get_Size(Stack : Stack_Type) return Integer is
   begin
      return Stack.Size;
   end Get_Size;

end Stack;
