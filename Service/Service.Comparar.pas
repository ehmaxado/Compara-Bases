unit Service.Comparar;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Param, FireDAC.Stan.Intf,
  FireDAC.Stan.Async, FireDAC.Phys.Intf, FireDAC.DApt, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.Phys, FireDAC.Phys.IBBase, FireDAC.Phys.FB,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.FBDef, model.Compara,
  Vcl.Dialogs, System.SysUtils, System.Classes, System.Generics.Collections,
  System.Generics.Defaults, View.Processando, Forms;

type
  TServiceComparar = class
  private
  public
    Base1: TFDConnection;
    Base2: TFDConnection;
    function ConectarBase(Caminho: string): TFDConnection;
    function CompararBase(ListaModel: TList<TModelCompara>; Comparar: TForm1): Boolean;
  end;

implementation

{ TServiceComparar }

function TServiceComparar.CompararBase(ListaModel: TList<TModelCompara>; Comparar: TForm1): Boolean;
var
  TablesList1, TablesList2: TStringList;
  Query1, Query2: TFDQuery;
  Model: TModelCompara;
  i: Integer;
begin
  // Verifica se as conex�es est�o ativas
  if not (Base1.Connected and Base2.Connected) then
    raise Exception.Create('Uma ou ambas as bases de dados n�o est�o conectadas.');

  // Cria as listas de tabelas e queries para ambas as bases
  TablesList1 := TStringList.Create;
  TablesList2 := TStringList.Create;
  Query1 := TFDQuery.Create(nil);
  Query2 := TFDQuery.Create(nil);
  try
    // Conecta as queries �s conex�es
    Query1.Connection := Base1;
    Query2.Connection := Base2;

    // Obt�m as tabelas de ambas as bases
    Base1.GetTableNames('', '', '', TablesList1);
    Base2.GetTableNames('', '', '', TablesList2);

    // Percorre as tabelas da Base1
    Comparar.ProgressBar.Max := TablesList1.Count;
    for i := 0 to TablesList1.Count - 1 do
    begin
      Model := TModelCompara.Create;

      // Nome das tabelas
      Model.Base1 := TablesList1[i];
      Model.Base2 := TablesList1[i]; // Assume que as tabelas t�m o mesmo nome nas duas bases
      if Copy(TablesList1[i], 1, 2) <> 'VW' then
      begin


      // Conta registros da tabela na Base1
      Query1.SQL.Text := Format('SELECT COUNT(*) FROM %s', [TablesList1[i]]);
      Query1.Open;
      Model.RegistroB1 := Query1.Fields[0].AsInteger;

      // Conta registros da tabela na Base2
      if TablesList2.IndexOf(TablesList1[i]) <> -1 then
      begin
        Query2.SQL.Text := Format('SELECT COUNT(*) FROM %s', [TablesList1[i]]);
        Query2.Open;
        Model.RegistroB2 := Query2.Fields[0].AsInteger;
      end
      else
      begin
        Model.RegistroB2 := 0; // Se a tabela n�o existir na Base2
      end;

      // Calcula a diferen�a de registros
      Model.Diferenca := Abs(Model.RegistroB1 - Model.RegistroB2);

      // Adiciona o modelo � lista
      ListaModel.Add(Model);

      // Atualiza os labels e a barra de progresso
      Comparar.LbTabela.Caption := TablesList1[i];
      Comparar.ProgressBar.Position := i + 1;
      Application.ProcessMessages; // Atualiza a interface gr�fica a cada itera��o
      end;
    end;

    // Percorre as tabelas da Base2 para adicionar tabelas que n�o est�o na Base1
    for i := 0 to TablesList2.Count - 1 do
    begin
      if TablesList1.IndexOf(TablesList2[i]) = -1 then
      begin
        Model := TModelCompara.Create;
        Model.Base1 := ''; // N�o existe na Base1
        Model.Base2 := TablesList2[i];
        Model.RegistroB1 := 0; // N�o existe na Base1
        Query2.SQL.Text := Format('SELECT COUNT(*) FROM %s', [TablesList2[i]]);
        Query2.Open;
        Model.RegistroB2 := Query2.Fields[0].AsInteger;
        Model.Diferenca := -Model.RegistroB2; // Apenas a contagem de Base2

        // Adiciona o modelo � lista
        ListaModel.Add(Model);
      end;
    end;

    // Retorna true ap�s o preenchimento
    Result := True;

  finally
    // Libera os recursos
    TablesList1.Free;
    TablesList2.Free;
    Query1.Free;
    Query2.Free;
  end;
end;






function TServiceComparar.ConectarBase(Caminho: string): TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  try
    // Configura os par�metros da conex�o Firebird
    Result.Params.DriverID := 'FB';
    Result.Params.Database := Caminho;
    Result.Params.UserName := 'SYSDBA';
    Result.Params.Password := 'masterkey';
    Result.Params.Add('Protocol=TCPIP');
    Result.Params.Add('Port=3050');

    Result.Connected := True;

    if Result.Connected then
      ShowMessage('Conex�o estabelecida com sucesso!')
    else
      ShowMessage('Falha ao conectar.');
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar: ' + E.Message);
      FreeAndNil(Result);
    end;
  end;
end;

end.

