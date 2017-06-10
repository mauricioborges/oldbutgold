identification division.
program-id. principal.
environment division.

data division.
working-storage section.
    01 retorno pic x(1).
procedure division.
    call 'filho1'.
    call 'neto2' using retorno.
    display retorno.
    stop run.
end program principal.


identification division.
program-id. filho1.
environment division.
data division.
linkage section.
    01 param-out pic x(1).

procedure division.
    display 'filho1'
    goback.

    entry 'neto2' using param-out.
    display 'neto2'.
    move 'a' to param-out.
    goback.
end program filho1.
