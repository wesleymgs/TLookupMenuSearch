{*******************************************************}
{                                                       }
{            Developed by Wesley Menezes                }
{               wesleymgs@yahoo.com                     }
{        Component for menu search in Delphi            }
{                  November 2023                        }
{                                                       }
{*******************************************************}

unit LookupMenuSearch;

interface

uses
  {$IF RTLVERSION > 15}
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.DBCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Forms, System.Variants,
  Vcl.Dialogs, Vcl.StdCtrls, System.StrUtils, Winapi.Windows,
  Vcl.Menus, Datasnap.DBClient, Vcl.Graphics, Winapi.Messages,
  Winapi.CommCtrl;
  {$ELSE}
  SysUtils, Classes, Controls, DBCtrls, DB, Grids, DBGrids,
  Forms, Variants, Dialogs, StdCtrls, StrUtils, Windows, Menus,
  DBClient, Graphics, Messages, CommCtrl;
  {$IFEND}

type
  RLookupMenuSearch = Record
    TextoMenu: string;
    Menu: TMainMenu;
    Edit: TEdit;
  end;

  TLookupMenuSearch = class
    private
      FGridFiltro: TDBGrid;
      FClientDataSet: TClientDataSet;
      FDataSource: TDataSource;
      FLookupMenuSearch: RLookupMenuSearch;

      procedure FGridFiltroCellDblClick(Sender: TObject);
      procedure FGridFiltroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure FGridFiltroKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
      procedure FGridFiltroExit(Sender: TObject);
      procedure FGridFiltroCellClick(Column: TColumn);

      procedure EditChange(Sender: TObject);
      procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

      procedure Execute;
      procedure PercorrerMenu(ItensMenu: TMenuItem; Menu: String = '');
      procedure ExibirHintGridFiltro;
    public
      constructor Create;
      destructor Destroy; override;
      class function New: TLookupMenuSearch;
      function SetMenu(const Value: TMainMenu): TLookupMenuSearch;
      function SetEdit(const Value: TEdit): TLookupMenuSearch;
      function Instance: TLookupMenuSearch;
  end;

implementation

{ TMenuSearch }

constructor TLookupMenuSearch.Create;
begin

end;

destructor TLookupMenuSearch.Destroy;
begin
  if (Assigned(FClientDataSet)) then
    FreeAndNil(FClientDataSet);
  if (Assigned(FDataSource)) then
    FreeAndNil(FDataSource);
  if (Assigned(FGridFiltro)) then
    FreeAndNil(FGridFiltro);

  inherited;
end;

procedure TLookupMenuSearch.EditChange(Sender: TObject);
begin
  FGridFiltro.Visible := FLookupMenuSearch.Edit.Text <> EmptyStr;
  FClientDataSet.Filtered := False;
  FClientDataSet.Filter   := 'UPPER(CAMINHO) LIKE ''%' + AnsiUpperCase(FLookupMenuSearch.Edit.Text) + '%'' OR UPPER(CAPTION) LIKE ''%' + AnsiUpperCase(FLookupMenuSearch.Edit.Text) + '%''';
  FClientDataSet.Filtered := True;

  if (FLookupMenuSearch.Edit.Parent <> TWinControl(TControl(FLookupMenuSearch.Edit.Owner))) then
  begin
    if (FLookupMenuSearch.Edit.Parent.Top + FLookupMenuSearch.Edit.Top + FGridFiltro.Height + 2 > TWinControl(TControl(FLookupMenuSearch.Edit.Owner)).Height) then
      FGridFiltro.Top := FLookupMenuSearch.Edit.Parent.Top + FLookupMenuSearch.Edit.Top - (FGridFiltro.Height + 2)
    else
      FGridFiltro.Top := FLookupMenuSearch.Edit.Parent.Top + FLookupMenuSearch.Edit.Top + FLookupMenuSearch.Edit.Height + 2;
    FGridFiltro.Left := FLookupMenuSearch.Edit.Parent.Left + FLookupMenuSearch.Edit.Left;
  end
  else
  begin
    if (FLookupMenuSearch.Edit.Top + FGridFiltro.Height + 2 > TWinControl(TControl(FLookupMenuSearch.Edit.Owner)).Height) then
      FGridFiltro.Top := FLookupMenuSearch.Edit.Top - (FGridFiltro.Height + 2)
    else
      FGridFiltro.Top := FLookupMenuSearch.Edit.Top + FLookupMenuSearch.Edit.Height + 2;
    FGridFiltro.Left := FLookupMenuSearch.Edit.Left;
  end;

  FGridFiltro.Parent := TWinControl(TControl(FLookupMenuSearch.Edit.Owner));
  FGridFiltro.Width  := FLookupMenuSearch.Edit.Width;
  SetWindowPos(FGridFiltro.Handle, HWND_TOPMOST, FGridFiltro.Left, FGridFiltro.Top, FGridFiltro.Width, FGridFiltro.Height, SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
  FGridFiltro.BringToFront;
end;

procedure TLookupMenuSearch.EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = VK_DOWN) or (Key = VK_UP) or (Key = VK_TAB)) and
     ((Assigned(FGridFiltro.DataSource)) and (FGridFiltro.DataSource.DataSet.RecordCount > 0) and (FGridFiltro.Visible)) then
    FGridFiltro.SetFocus;

  if (Key = VK_ESCAPE) then
  begin
    FLookupMenuSearch.Edit.Text := EmptyStr;
    FGridFiltro.Visible := False;
  end;
end;

procedure TLookupMenuSearch.Execute;
begin
  FGridFiltro.Visible := False;
  TMenuItem(
    FLookupMenuSearch.Edit.Owner.FindComponent(
      FClientDataSet.FieldByName('Nome').AsString
    )
  ).Click;
  FLookupMenuSearch.Edit.Text := EmptyStr;
end;

procedure TLookupMenuSearch.ExibirHintGridFiltro;
begin
  if (not FGridFiltro.DataSource.DataSet.IsEmpty) then
  begin
    FGridFiltro.ShowHint := True;
    FGridFiltro.Hint := FClientDataSet.FieldByName('Caminho').AsString;
  end;
end;

procedure TLookupMenuSearch.FGridFiltroCellClick(Column: TColumn);
begin
  ExibirHintGridFiltro;
end;

procedure TLookupMenuSearch.FGridFiltroCellDblClick(Sender: TObject);
begin
  Execute;
end;

procedure TLookupMenuSearch.FGridFiltroExit(Sender: TObject);
begin
  FGridFiltro.Visible := False;
end;

procedure TLookupMenuSearch.FGridFiltroKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    Execute;

  if (Key = VK_ESCAPE) then
  begin
    FLookupMenuSearch.Edit.Text := EmptyStr;
    FGridFiltro.Visible := False;
  end;
end;

procedure TLookupMenuSearch.FGridFiltroKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key in [VK_UP, VK_DOWN]) then
    ExibirHintGridFiltro;

  if (FGridFiltro.DataSource.DataSet.Bof) and
     (Key = VK_UP) then
    FLookupMenuSearch.Edit.SetFocus;
end;

function TLookupMenuSearch.Instance: TLookupMenuSearch;
begin
  Result := Self;
  FClientDataSet := TClientDataSet.Create(FLookupMenuSearch.Edit.Owner);
  FClientDataSet.FieldDefs.Clear;
  FClientDataSet.FieldDefs.Add('Caminho', ftString, 255, False);
  FClientDataSet.FieldDefs.Add('Nome', ftString, 255, False);
  FClientDataSet.FieldDefs.Add('Caption', ftString, 255, False);
  FClientDataSet.CreateDataSet;
  FClientDataSet.Fields[1].Visible := False;
  FClientDataSet.Fields[2].Visible := False;

  FDataSource := TDataSource.Create(FLookupMenuSearch.Edit.Owner);
  FDataSource.DataSet := FClientDataSet;

  FGridFiltro              := TDBGrid.Create(FLookupMenuSearch.Edit.Owner);
  FGridFiltro.OnDblClick   := FGridFiltroCellDblClick;
  FGridFiltro.OnKeyDown    := FGridFiltroKeyDown;
  FGridFiltro.OnKeyUp      := FGridFiltroKeyUp;
  FGridFiltro.OnExit       := FGridFiltroExit;
  FGridFiltro.OnCellClick  := FGridFiltroCellClick;
  {$IF RTLVERSION > 15}
  FGridFiltro.Options := [dgColumnResize,dgTabs,dgRowSelect,dgConfirmDelete,dgCancelOnExit,dgTitleClick,dgTitleHotTrack];
  {$ELSE}
  FGridFiltro.Options := [dgColumnResize,dgTabs,dgRowSelect,dgConfirmDelete,dgCancelOnExit];
  {$IFEND}
  FGridFiltro.DataSource := FDataSource;
  PercorrerMenu(FLookupMenuSearch.Menu.Items);
  FLookupMenuSearch.TextoMenu := EmptyStr;

  FLookupMenuSearch.Edit.OnChange  := EditChange;
  FLookupMenuSearch.Edit.OnKeyDown := EditKeyDown;
end;

class function TLookupMenuSearch.New: TLookupMenuSearch;
begin
  Result := Self.Create;
end;

procedure TLookupMenuSearch.PercorrerMenu(ItensMenu: TMenuItem; Menu: String);
var
  {$IF RTLVERSION > 15}
  item: TMenuItem;
  {$ELSE}
  i: integer;
  {$IFEND}
begin
  {$IF RTLVERSION > 15}
  for item in ItensMenu do
  {$ELSE}
  for i:=0 to ItensMenu.Count -1 do
  {$IFEND}
  begin
    {$IF RTLVERSION > 15}
    if (item.Visible) then
    {$ELSE}
    if (ItensMenu[i].Visible) then
    {$IFEND}
    begin
      if (Pos('>', Menu) = 0) then
        FLookupMenuSearch.TextoMenu := Menu;

      {$IF RTLVERSION > 15}
      if FLookupMenuSearch.TextoMenu = EmptyStr then
        FLookupMenuSearch.TextoMenu := StringReplace(item.Caption, '&', '',[rfReplaceAll, rfIgnoreCase])
      else FLookupMenuSearch.TextoMenu := Menu + ' > ' + StringReplace(item.Caption, '&', '',[rfReplaceAll, rfIgnoreCase]);

      if item.Count > 0 then
        PercorrerMenu(item, FLookupMenuSearch.TextoMenu)
      {$ELSE}
      if FLookupMenuSearch.TextoMenu = EmptyStr then
        FLookupMenuSearch.TextoMenu := StringReplace(ItensMenu[i].Caption, '&', '',[rfReplaceAll, rfIgnoreCase])
      else FLookupMenuSearch.TextoMenu := Menu + ' > ' + StringReplace(ItensMenu[i].Caption, '&', '',[rfReplaceAll, rfIgnoreCase]);

      if ItensMenu[i].Count > 0 then
        PercorrerMenu(ItensMenu[i], FLookupMenuSearch.TextoMenu)
      {$IFEND}
      else
      begin
        FClientDataSet.Append;
        FClientDataSet.FieldByName('Caminho').AsString := FLookupMenuSearch.TextoMenu;
        {$IF RTLVERSION > 15}
        FClientDataSet.FieldByName('Nome').AsString    := item.Name;
        FClientDataSet.FieldByName('Caption').AsString := StringReplace(item.Caption, '&', '',[rfReplaceAll, rfIgnoreCase]);
        {$ELSE}
        FClientDataSet.FieldByName('Nome').AsString    := ItensMenu[i].Name;
        FClientDataSet.FieldByName('Caption').AsString := StringReplace(ItensMenu[i].Caption, '&', '',[rfReplaceAll, rfIgnoreCase]);
        {$IFEND}
        FClientDataSet.Post;
      end;
    end;
  end;
end;

function TLookupMenuSearch.SetEdit(const Value: TEdit): TLookupMenuSearch;
begin
  Result := Self;
  FLookupMenuSearch.Edit := Value;
end;

function TLookupMenuSearch.SetMenu(const Value: TMainMenu): TLookupMenuSearch;
begin
  Result := Self;
  FLookupMenuSearch.Menu := Value;
end;

end.
