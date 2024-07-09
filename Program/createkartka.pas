unit CreateKartka;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DateTimePicker, DBCtrls, DBDateTimePicker;

type

  { TfrmCreateKart }

  TfrmCreateKart = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DateTimePicker1: TDateTimePicker;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmCreateKart: TfrmCreateKart;

implementation

{$R *.lfm}

{ TfrmCreateKart }

procedure TfrmCreateKart.FormCreate(Sender: TObject);
begin
     DateTimePicker1.Date := Now;
end;

procedure TfrmCreateKart.BitBtn2Click(Sender: TObject);
begin
     //Close;
end;

procedure TfrmCreateKart.BitBtn1Click(Sender: TObject);
begin
     //Close;
end;

end.

