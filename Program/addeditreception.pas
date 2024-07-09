unit addeditreception;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBCtrls, ExtCtrls, Buttons, SpinEx, DateTimePicker;

type

  { TfrmAddEditReception }

  TfrmAddEditReception = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBoxSetStatus: TCheckBox;
    DataSource1: TDataSource;
    DateTimePicker1: TDateTimePicker;
    DBLookupComboBox1: TDBLookupComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    SpinEditEx1: TSpinEditEx;
    SpinEditEx2: TSpinEditEx;
    SQLQuery_Patients: TSQLQuery;
    SQLQuery_Patientsid_patient: TLongintField;
    SQLQuery_Patientspatient: TStringField;
    SQLTransaction1: TSQLTransaction;
    procedure DBLookupComboBox1KeyPress(Sender: TObject; var Key: char);
    procedure DBLookupComboBox1Select(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmAddEditReception: TfrmAddEditReception;
  idpt : integer;

implementation

{$R *.lfm}

{ TfrmAddEditReception }

procedure TfrmAddEditReception.FormCreate(Sender: TObject);
begin
     SQLQuery_Patients.Active := True;
end;

procedure TfrmAddEditReception.FormClose(Sender: TObject;
var CloseAction: TCloseAction);
begin
     SQLQuery_Patients.Active := False;
end;

procedure TfrmAddEditReception.DBLookupComboBox1Select(Sender: TObject);
begin
  idpt := DBLookupComboBox1.KeyValue;
end;

procedure TfrmAddEditReception.DBLookupComboBox1KeyPress(Sender: TObject;
  var Key: char);
begin
  Key := #0;
end;

end.

