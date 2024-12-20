unit Controller.Comparar;

interface
uses Service.Comparar, System.Classes, System.Generics.Collections, Model.Compara,
View.Processando;

type tControllerComparar = class
  private
  ServiceCompara : TServiceComparar;
  public
  constructor Create;
  destructor destroy; override;
  function ConectarBase1(Caminho:string): Boolean;
  function ConectarBase2(Caminho:string): Boolean;
  function CompararBases(ListaModel: TList<TModelCompara>; Comparar: TForm1): Boolean;

end;

implementation

{ tControllerComparar }

function tControllerComparar.ConectarBase1(Caminho: string): Boolean;
begin
   ServiceCompara.Base1 := ServiceCompara.ConectarBase(Caminho);
end;

function tControllerComparar.ConectarBase2(Caminho: string): Boolean;
begin
  ServiceCompara.Base2 := ServiceCompara.ConectarBase(Caminho);
end;

constructor tControllerComparar.Create;
begin
  ServiceCompara := TServiceComparar.Create;
end;

destructor tControllerComparar.destroy;
begin
  ServiceCompara.Free;
  inherited;
end;

function tControllerComparar.CompararBases(ListaModel: TList<TModelCompara>; Comparar: TForm1 ): Boolean;
begin
  Result := ServiceCompara.CompararBase(ListaModel, Comparar); // Chama a fun��o de compara��o
end;

end.
