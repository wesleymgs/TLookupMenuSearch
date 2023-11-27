object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 287
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 24
    Top = 21
    Width = 366
    Height = 41
    TabOrder = 0
    object Edit2: TEdit
      Left = 5
      Top = 12
      Width = 353
      Height = 21
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 32
    Top = 96
    object Cadastro1: TMenuItem
      Caption = 'Cadastro'
      object Marcas1: TMenuItem
        Caption = 'Marcas'
        OnClick = Marcas1Click
      end
      object Produto1: TMenuItem
        Caption = 'Produtos'
        object Nacionais1: TMenuItem
          Caption = 'Nacionais'
        end
        object Internacionais1: TMenuItem
          Caption = 'Internacionais'
          object ComcdID1: TMenuItem
            Caption = 'Com C'#243'd ID'
          end
          object SemCdID1: TMenuItem
            Caption = 'Sem C'#243'd ID'
          end
        end
      end
      object Cliente1: TMenuItem
        Caption = 'Clientes'
      end
      object Estabelecimentos1: TMenuItem
        Caption = 'Acentua'#231#227'o'
      end
    end
    object Relatrio1: TMenuItem
      Caption = 'Relat'#243'rio'
      object Marcas2: TMenuItem
        Caption = 'Marcas'
      end
      object Produtos1: TMenuItem
        Caption = 'Produtos'
      end
      object Clientes1: TMenuItem
        Caption = 'Clientes'
      end
    end
    object Sair1: TMenuItem
      Caption = 'Sair'
    end
  end
end
