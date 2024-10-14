program ComparaBase;

uses
  Vcl.Forms,
  View.Compar.Bases in 'View.Compar.Bases.pas' {ViewComparacaoBase},
  Model.Compara in 'Model\Model.Compara.pas',
  Service.Comparar in 'Service\Service.Comparar.pas',
  Controller.Comparar in 'Controller\Controller.Comparar.pas',
  View.Processando in 'View\View.Processando.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewComparacaoBase, ViewComparacaoBase);
  Application.Run;
end.
