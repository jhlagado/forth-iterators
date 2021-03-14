: pair create , , does> dup cell+ @ swap @ ;
: partial create , , does> exec-partial ;
: exec-partial dup cell+ @ swap @ execute ;

VARIABLE __to-state
: TO 1 __to-state ! ;

: VALUE 
   CREATE ,
   DOES> __to-state @ IF ! ELSE @ THEN
         0 __to-state ! ;

: look bl word find ; immediate
: x look dup drop execute ;
3000 x .s
