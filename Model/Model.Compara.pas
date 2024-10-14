unit Model.Compara;

interface

type tModelCompara = class
  private
    FBase1: string;
    FBase2: string;
    FRegistroB1: Integer;
    FRegistroB2: Integer;
    FDiferenca: Integer;
  public
  property Base1: string read FBase1 write FBase1;
  property Base2: string read FBase2 write FBase2;
  property RegistroB1: Integer read FRegistroB1 write FRegistroB1;
  property RegistroB2: Integer read FRegistroB2 write FRegistroB2;
  property Diferenca: Integer read FDiferenca write FDiferenca;
end;

implementation

end.
