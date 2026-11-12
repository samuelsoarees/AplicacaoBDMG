unit AplicacaoBDMG.Utils.Async;

interface

uses
  System.SysUtils;

type
  TAplicacaoBDMGAsyncErro = reference to procedure(AErro: Exception);

  TAplicacaoBDMGAsync = class
  public
    class procedure Executar<T>(const ATarefa: TFunc<T>; const AAoConcluir: TProc<T>;
      const AAoFalhar: TAplicacaoBDMGAsyncErro; const AAoFinalizar: TProc); static;

    class procedure ExecutarProc(const ATarefa: TProc; const AAoConcluir: TProc;
      const AAoFalhar: TAplicacaoBDMGAsyncErro; const AAoFinalizar: TProc); static;
  end;

implementation

uses
  System.Classes,
  System.Threading;

class procedure TAplicacaoBDMGAsync.Executar<T>(const ATarefa: TFunc<T>; const AAoConcluir: TProc<T>;
  const AAoFalhar: TAplicacaoBDMGAsyncErro; const AAoFinalizar: TProc);
begin
  TTask.Run(
    procedure
    var
      LResultado: T;
      LErro: TObject;
    begin
      LErro := nil;
      LResultado := Default(T);
      try
        LResultado := ATarefa();
      except
        LErro := AcquireExceptionObject;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if Assigned(AAoFinalizar) then
              AAoFinalizar();

            if Assigned(LErro) then
              AAoFalhar(Exception(LErro))
            else
              AAoConcluir(LResultado);
          finally
            LErro.Free;
          end;
        end);
    end);
end;

class procedure TAplicacaoBDMGAsync.ExecutarProc(const ATarefa: TProc; const AAoConcluir: TProc;
  const AAoFalhar: TAplicacaoBDMGAsyncErro; const AAoFinalizar: TProc);
begin
  Executar<Boolean>(
    function: Boolean
    begin
      ATarefa();
      Result := True;
    end,
    procedure(AValor: Boolean)
    begin
      AAoConcluir();
    end,
    AAoFalhar,
    AAoFinalizar);
end;

end.
