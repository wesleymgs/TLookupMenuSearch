unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient, Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, LookupMenuSearch,
  JvMenus, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Relatrio1: TMenuItem;
    Marcas1: TMenuItem;
    Produto1: TMenuItem;
    Cliente1: TMenuItem;
    Marcas2: TMenuItem;
    Produtos1: TMenuItem;
    Clientes1: TMenuItem;
    Sair1: TMenuItem;
    Estabelecimentos1: TMenuItem;
    Nacionais1: TMenuItem;
    Internacionais1: TMenuItem;
    ComcdID1: TMenuItem;
    SemCdID1: TMenuItem;
    Panel1: TPanel;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Marcas1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FLookupMenuSearch: TLookupMenuSearch;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FLookupMenuSearch);
  Action := caFree;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLookupMenuSearch :=
    TLookupMenuSearch
      .New
      .SetMenu(MainMenu1)
      .SetEdit(Edit2)
      .Instance;

  ReportMemoryLeaksOnShutdown := True;
end;

procedure TForm1.Marcas1Click(Sender: TObject);
begin
  ShowMessage('Marcas');
end;

end.
