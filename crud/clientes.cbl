          >>source format free
       identification division.
       program-id. clientes.
       environment division.

       configuration section.

       data division.
       file section.

       working-storage section.
       01 file1-rec.
           05 fs-key.
               10 fs-fone pic 9(09) blank when zeros.
           05 fs-nome     pic x(40).
           05 fs-endereco pic x(40).
           05 filler      pic x(20).

       01 ws-modulo.
           05 filler pic x(11) value "clientes -".
           05 ws-op pic x(20) value spaces.

       77 ws-opcao pic x.
           88 e-incluir   value is "1".
           88 e-consultar value is "2".
           88 e-alterar   value is "3".
           88 e-excluir   value is "4".
           88 e-encerrar  value is "x" "x".
       77 app-stat pic 9(02).
           88 fs-ok         value zeros.
           88 app-cancela    value 99.
       77 ws-erro pic x.
           88 e-sim values are "s" "s".

       77 ws-numl pic 999.
       77 ws-numc pic 999.
       77 cor-fundo pic 9 value 1.
       77 cor-frente pic 9 value 6.

       77 ws-status pic x(30).
       77 ws-msgerro pic x(80).

       copy screenio.

       screen section.
       01 ss-cls.
           05 ss-filler.
               10 blank screen.
               10 line 01 column 01 erase eol
                  background-color cor-fundo.
               10 line ws-numl column 01 erase eol
                  background-color cor-fundo.
           05 ss-cabecalho.
               10 line 01 column 02 pic x(31) from ws-modulo
                  highlight foreground-color cor-frente
                  background-color cor-fundo.
           05 ss-status.
               10 line ws-numl column 2 erase eol pic x(30)
                  from ws-status highlight
                  foreground-color cor-frente
                  background-color cor-fundo.

       01 ss-menu foreground-color 6.
           05 line 07 column 15 value "1 - incluir".
           05 line 08 column 15 value "2 - consultar".
           05 line 09 column 15 value "3 - alterar".
           05 line 10 column 15 value "4 - excluir".
           05 line 11 column 15 value "x - encerrar".
           05 line 13 column 15 value "opção: ".
           05 line 13 col plus 1 using ws-opcao auto.

       01 ss-tela-registro.
           05 ss-chave foreground-color 2.
               10 line 10 column 10 value "telefone:".
               10 column plus 2 pic 9(09) using fs-fone
                  blank when zeros.
           05 ss-dados.
               10 line 11 column 10 value "    nome:".
               10 column plus 2 pic x(40) using fs-nome.
               10 line 12 column 10 value "endereço:".
               10 column plus 2 pic x(40) using fs-endereco.

       01 ss-erro.
           05 filler foreground-color 4 background-color 1 highlight.
               10 line ws-numl column 2 pic x(80) from ws-msgerro bell.
               10 column plus 2 to ws-erro.

       procedure division.
       inicio.
           set environment 'cob_screen_exceptions' to 'y'.
           set environment 'cob_screen_esc' to 'y'.
           set environment 'escdelay' to '25'.
           accept ws-numl from lines
           accept ws-numc from columns
           call 'start-files'.
           perform until e-encerrar
               move "menu" to ws-op
               move "escolha a opção" to ws-status
               move spaces to ws-opcao
               display ss-cls
               accept ss-menu
               evaluate true
                   when e-incluir
                       perform inclui thru inclui-fim
                   when e-consultar
                       perform consulta thru consulta-fim
                   when e-alterar
                       perform altera thru altera-fim
                   when e-excluir
                       perform exclui thru exclui-fim
               end-evaluate
           end-perform.
       finaliza.
           call 'finaliza-clientes-service'.
           stop run.

      *> -----------------------------------
       inclui.
           move "inclusão" to ws-op.
           move "esc para encerrar" to ws-status.
           display ss-cls.
           move spaces to file1-rec.
       inclui-loop.
           accept ss-tela-registro.
           if cob-crt-status = cob-scr-esc
               go inclui-fim
           end-if
           if fs-nome equal spaces or fs-endereco equal spaces
               move "favor informar nome e endereço" to ws-msgerro
               perform mostra-erro
               go inclui-loop
           end-if
           call 'salva-cliente' using file1-rec, ws-msgerro, app-stat.
           if ws-msgerro not equal to spaces
               perform mostra-erro
           end-if.
           go inclui.
       inclui-fim.

      *> -----------------------------------
       consulta.
           move "consulta" to ws-op.
           move "esc para encerrar" to ws-status.
           display ss-cls.
       consulta-loop.
           move spaces to file1-rec.
           display ss-tela-registro.
           perform le-cliente thru le-cliente-fim.
           if app-cancela
               go consulta-fim
           end-if
           if fs-ok
               display ss-dados
               move "pressione enter" to ws-msgerro
               perform mostra-erro
           end-if.
           go consulta-loop.
       consulta-fim.

      *> -----------------------------------
       altera.
           move "alteração" to ws-op.
           move "esc para encerrar" to ws-status.
           display ss-cls.
       altera-loop.
           move spaces to file1-rec.
           display ss-tela-registro.
           perform le-cliente thru le-cliente-fim.
           if app-cancela
               go to altera-fim
           end-if
           if fs-ok
               accept ss-dados
               if cob-crt-status = cob-scr-esc
                   go altera-loop
               end-if
           else
               go altera-loop
            end-if
           call 'altera-cliente' using file1-rec, ws-msgerro, app-stat.
           if ws-msgerro not equal to spaces
               perform mostra-erro
           end-if.
           go altera-loop.
       altera-fim.

      *> -----------------------------------
       exclui.
           move "exclusão" to ws-op.
           move "esc para encerrar" to ws-status.
           display ss-cls.
           move spaces to file1-rec.
           display ss-tela-registro.
           perform le-cliente thru le-cliente-fim.
           if app-cancela
               go exclui-fim
           end-if
           if not fs-ok
               go exclui
           end-if
           display ss-dados.
           move "n" to ws-erro.
           move "confirma a exclusão do cliente (s/n)?" to ws-msgerro.
           accept ss-erro.
           if not e-sim
               go exclui-fim
           end-if
           call 'deleta-cliente' using file1-rec, ws-msgerro, app-stat.
           if ws-msgerro not equal to spaces
               perform mostra-erro
           end-if.
       exclui-fim.

      *> -----------------------------------
      *> le cliente e mostra mensagem se chave não existe
       le-cliente.
           accept ss-chave.
           move cob-crt-status to ws-msgerro.
           perform mostra-erro.
           if not cob-crt-status = cob-scr-esc
               call 'busca-cliente' using file1-rec, ws-msgerro, app-stat
              if ws-msgerro not equal to spaces
                  perform mostra-erro
              end-if
           else
               move 99 to app-stat
           end-if.
       le-cliente-fim.

      *> -----------------------------------
      *> mostra mensagem, espera enter, atualiza barra status
       mostra-erro.
           display ss-erro
           accept ss-erro
           display ss-status.
