          >>source format free
identification division.
program-id. cliente-service.

environment division.
    input-output section.
    file-control.
       select file2 assign to disk
           organization is indexed
           access mode is random
           file status is fs-stat
           record key is fs-key.

data division.
    file section.
        fd file2 value of file-id is "clientes2.dat".
        01 file2-rec.
           05 fs-key.
               10 fs-fone pic 9(09) blank when zeros.
           05 fs-nome     pic x(40).
           05 fs-endereco pic x(40).
           05 filler      pic x(20).
    working-storage section.
       77 fs-stat pic 9(02).
           88 fs-ok         value zeros.
           88 fs-cancela    value 99.
           88 fs-nao-existe value 35.

    linkage section.
        01 file2-param  pic x(109).
        77 file-err-msg pic x(80).

procedure division.

entry 'start-files'.
    move spaces to file2-rec.
    open i-o file2
    if fs-nao-existe then
        open output file2
        close file2
        open i-o file2
    end-if.
    goback.

entry 'salva-cliente' using file2-param, file-err-msg.
    move spaces to file-err-msg
    move file2-param to file2-rec.
    write file2-rec
    invalid key
       move "cliente já existe" to file-err-msg
       move zeros to fs-key
    end-write.

    move spaces to file2-rec.
    goback.

end program cliente-service.
