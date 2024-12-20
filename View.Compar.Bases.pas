unit View.Compar.Bases;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Controller.Comparar, Model.Compara,
  System.Generics.Collections, View.Processando, Vcl.Buttons, Vcl.ExtCtrls;

type
  TViewComparacaoBase = class(TForm)
    Label1: TLabel;
    ListaCompara: TStringGrid;
    EdtBase1: TEdit;
    EdtBase2: TEdit;
    BtnBase1: TButton;
    BtnBase2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    LblDiferenca: TLabel;
    procedure BtnBase1Click(Sender: TObject);
    procedure BtnBase2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListaComparaDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel1MouseEnter(Sender: TObject);
    procedure Panel1MouseLeave(Sender: TObject);
    procedure SomarDiferen�as;
  private
    ControllerComparar : tControllerComparar;
    procedure ConfigurarBase1;
    procedure ConfigurarBase2;
    procedure Cabe�alhoGrid;
    { Private declarations }
  public
    ListaModel: TList<TModelCompara>;
    { Public declarations }
  end;

var
  ViewComparacaoBase: TViewComparacaoBase;

implementation

uses
  System.Generics.Defaults;

{$R *.dfm}

procedure TViewComparacaoBase.BtnBase1Click(Sender: TObject);
begin
  ConfigurarBase1;
end;

procedure TViewComparacaoBase.BtnBase2Click(Sender: TObject);
begin
  ConfigurarBase2;
end;

procedure TViewComparacaoBase.Button1Click(Sender: TObject);
var
  Model: TModelCompara;
  i: Integer;
  form1: TForm1;
begin
  panel1.Enabled := False;
  if (EdtBase1.Text = '') or (EdtBase2.Text = '') then
  begin
  ShowMessage('Selecione as bases para compara��o.');
  Panel1.Enabled := True;
  Exit;
  end;

  // Cria uma inst�ncia de Form1 se ainda n�o existir
  form1 := TForm1.Create(nil);
  try
    form1.Show;
    Application.ProcessMessages; // Permite que a interface do usu�rio seja atualizada
    ViewComparacaoBase.Enabled := False;
    ListaModel.Clear;

    // Chama a fun��o para comparar as bases
    if ControllerComparar.CompararBases(ListaModel, form1) then
    begin
      // Limpa a TStringGrid antes de preencher com novos dados
      ListaCompara.RowCount := 1;
      Cabe�alhoGrid;

      // Percorre a lista de modelos e preenche a TStringGrid
    ListaModel.Sort(
    TComparer<TModelCompara>.Construct(
    function(const Left, Right: TModelCompara): Integer
    begin
      // Ordena do maior para o menor pela diferen�a
      Result := Right.Diferenca - Left.Diferenca; // Troca para 'Right - Left' para ordem decrescente
    end
     )
    );
    // Agora, percorre a lista de modelos e preenche a TStringGrid
    for i := 0 to ListaModel.Count - 1 do
    begin
      Model := ListaModel[i];
      ListaCompara.RowCount := ListaCompara.RowCount + 1; // Adiciona uma nova linha
      ListaCompara.Cells[0, i + 1] := Model.Base1;
      ListaCompara.Cells[1, i + 1] := IntToStr(Model.RegistroB1);
      ListaCompara.Cells[2, i + 1] := Model.Base2;
      ListaCompara.Cells[3, i + 1] := IntToStr(Model.RegistroB2);
      ListaCompara.Cells[4, i + 1] := IntToStr(Model.Diferenca);
    end;
      Form1.Close;
    end
    else
    begin
      ShowMessage('As bases de dados n�o foram comparadas corretamente.');
    end;

  finally
    ViewComparacaoBase.Enabled := True;
    panel1.Enabled := True;
    form1.Free; // Libera o Form1 ap�s o uso
  end;
end;



procedure TViewComparacaoBase.ConfigurarBase1;
begin
  with TOpenDialog.Create(nil) do
    try
      Options := [ofFileMustExist];
      Filter := 'Firebird Database Files (*.fdb)|*.fdb';
      InitialDir := ExtractFilePath(ParamStr(0));
      if Execute then
      begin
        EdtBase1.Text := FileName;
        ControllerComparar.ConectarBase1(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TViewComparacaoBase.ConfigurarBase2;
begin
  with TOpenDialog.Create(nil) do
    try
      Options := [ofFileMustExist];
      Filter := 'Firebird Database Files (*.fdb)|*.fdb';
      InitialDir := ExtractFilePath(ParamStr(0));
      if Execute then
      begin
        EdtBase2.Text := FileName;
        ControllerComparar.ConectarBase2(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TViewComparacaoBase.Cabe�alhoGrid;
begin
  // Define os cabe�alhos da TStringGrid
  ListaCompara.Cells[0, 0] := 'Tabelas da base Original';
  ListaCompara.ColWidths[0] := 240;
  ListaCompara.Cells[1, 0] := 'QTD Registros';
  ListaCompara.ColWidths[1] := 100;
  ListaCompara.Cells[2, 0] := 'Tabelas da base Ajustada';
  ListaCompara.ColWidths[2] := 240;
  ListaCompara.Cells[3, 0] := 'QTD Registros';
  ListaCompara.ColWidths[3] := 100;
  ListaCompara.Cells[4, 0] := 'Diferen�a:';
  ListaCompara.ColWidths[4] := 75;
end;

procedure TViewComparacaoBase.FormCreate(Sender: TObject);
begin
  ControllerComparar := tControllerComparar.Create;
  ListaModel:= TList<TModelCompara>.Create;
  Panel1.Color := RGB(245, 130, 32);
end;

procedure TViewComparacaoBase.FormDestroy(Sender: TObject);
begin
ControllerComparar.Free;
ListaModel.Free;
end;

procedure TViewComparacaoBase.FormShow(Sender: TObject);
begin
Cabe�alhoGrid;
end;

procedure TViewComparacaoBase.ListaComparaDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  CellValue: Double;
begin
  with ListaCompara.Canvas do
  begin
    if ARow = 0 then
    begin
      // Aplica estilo personalizado apenas para a primeira linha (cabe�alhos)
      Brush.Color := clScrollBar;
      Font.Color := clBlack;
    end
    else
    begin
      // Alterna as cores para linhas pares e �mpares
      if ARow mod 2 = 0 then
        Brush.Color := clWhite  // Linhas pares com fundo branco
      else
        Brush.Color := cl3DLight;  // Linhas �mpares com fundo cinza claro

      // Verifica se estamos na coluna 4 (�ndice 3, pois come�a em 0)
      if ACol = 4 then
      begin
        // Tenta converter o valor da c�lula para n�mero
        if TryStrToFloat(ListaCompara.Cells[ACol, ARow], CellValue) and (CellValue > 0) then
          Font.Color := clRed  // Define a cor da fonte para vermelho se o valor for maior que 0
        else
          Font.Color := clWindowText;  // Caso contr�rio, mant�m a cor padr�o
      end
      else
        Font.Color := clWindowText;  // Cor padr�o para outras colunas
    end;

    // Preenche a c�lula com a cor definida
    FillRect(Rect);
    // Desenha o texto da c�lula
    TextRect(Rect, Rect.Left + 2, Rect.Top + 2, ListaCompara.Cells[ACol, ARow]);
  end;
end;






procedure TViewComparacaoBase.Panel1Click(Sender: TObject);
var
  Model: TModelCompara;
  i: Integer;
  Comparar: TForm1;
begin
  Panel1.Enabled := False;
  if (EdtBase1.Text = '') or (EdtBase2.Text = '') then
  begin
    ShowMessage('Selecione as bases para compara��o.');
    Panel1.Enabled := True;
    Exit;
  end;

  // Cria uma inst�ncia de Form1 e mostra como n�o-modal para indicar processamento
  Comparar := TForm1.Create(nil);
  try
    Comparar.Show;  // Mostra o Form1 para indicar que est� processando
    Application.ProcessMessages; // Permite atualiza��o da interface
    ViewComparacaoBase.Enabled := False;
    ListaModel.Clear;

    // Chama a fun��o para comparar as bases
    if ControllerComparar.CompararBases(ListaModel, Comparar) then
    begin
      // Limpa a TStringGrid antes de preencher com novos dados
      ListaCompara.RowCount := 1;
      Cabe�alhoGrid;

      // Ordena e preenche a TStringGrid
      ListaModel.Sort(
        TComparer<TModelCompara>.Construct(
          function(const Left, Right: TModelCompara): Integer
          begin
            Result := Right.Diferenca - Left.Diferenca; // Ordem decrescente
          end
        )
      );

      // Preenche a TStringGrid com os resultados
      for i := 0 to ListaModel.Count - 1 do
      begin
        Model := ListaModel[i];
        ListaCompara.RowCount := ListaCompara.RowCount + 1; // Adiciona uma nova linha
        ListaCompara.Cells[0, i + 1] := Model.Base1;
        ListaCompara.Cells[1, i + 1] := IntToStr(Model.RegistroB1);
        ListaCompara.Cells[2, i + 1] := Model.Base2;
        ListaCompara.Cells[3, i + 1] := IntToStr(Model.RegistroB2);
        ListaCompara.Cells[4, i + 1] := IntToStr(Model.Diferenca);
      end;
    end
    else
    begin
      ShowMessage('As bases de dados n�o foram comparadas corretamente.');
    end;

    SomarDiferen�as;
  finally
    ViewComparacaoBase.Enabled := True;
    Panel1.Enabled := True;
    Comparar.Close; // Fecha o Form1 ap�s o processo
  end;
end;


procedure TViewComparacaoBase.Panel1MouseEnter(Sender: TObject);
begin
 Panel1.Color := RGB(196, 90, 32);
end;

procedure TViewComparacaoBase.Panel1MouseLeave(Sender: TObject);
begin
Panel1.Color := RGB(245, 130, 32);
end;

procedure TViewComparacaoBase.SomarDiferen�as;
var i: Integer;
    Soma: Double;
    model : TModelCompara;
begin
  Soma := 0;

  for i := 0 to ListaModel.Count - 1 do
  begin
    model := ListaModel[i];
    Soma := soma + model.Diferenca;
  end;

  if Soma > 0 then
  begin
    LblDiferenca.Font.Color := clRed;
    LblDiferenca.Caption := 'Diferen�a de '+ FloatToStr(soma) + ' registros.';
  end
  else
  begin
    LblDiferenca.Font.Color := clGreen;
    LblDiferenca.Caption := 'Nenhuma diferen�a encontrada.';
  end;


end;

end.
