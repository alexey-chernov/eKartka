unit Karta_Pacienta;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, DBCtrls, DBGrids, Buttons;

type

  { TfrmKartkaPacienta }

  TfrmKartkaPacienta = class(TForm)
    BitBtn2: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    DBMemo3: TDBMemo;
    DBText1: TDBText;
    DBText10: TDBText;
    DBText11: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    DBText5: TDBText;
    DBText6: TDBText;
    DBText7: TDBText;
    DBText8: TDBText;
    DBText9: TDBText;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    SQLQuery_KartkaPatientTests: TSQLQuery;
    SQLQuery_KartkaPatientHistory: TSQLQuery;
    SQLQuery_KartkaPatient: TSQLQuery;
    SQLQuery_KartkaPatientHistorydateexam: TDateField;
    SQLQuery_KartkaPatientHistorydiagnosis: TStringField;
    SQLQuery_KartkaPatientHistorydoctorfullname: TStringField;
    SQLQuery_KartkaPatientHistorymedicalopinion: TMemoField;
    SQLQuery_KartkaPatientHistorymedicaments: TMemoField;
    SQLQuery_KartkaPatientid_patient: TLongintField;
    SQLQuery_KartkaPatientparentfullname: TStringField;
    SQLQuery_KartkaPatientpatientfullname: TStringField;
    SQLQuery_KartkaPatientpatient_address: TStringField;
    SQLQuery_KartkaPatientpatient_dateofbirth: TDateField;
    SQLQuery_KartkaPatientpatient_email: TStringField;
    SQLQuery_KartkaPatientpatient_telnumber: TStringField;
    SQLScript: TSQLScript;
    SQLTransaction_Script: TSQLTransaction;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure BitBtn2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmKartkaPacienta: TfrmKartkaPacienta;

implementation

{$R *.lfm}

{ TfrmKartkaPacienta }

uses main, AddVizit, addanaliz;

function Convert_Strings(LinesOfMemo : TStrings) : string;
var
  _str_memo : string;
  i : word;
begin
     _str_memo := '';
     for i := 0 to LinesOfMemo.Count - 1 do
     _str_memo := _str_memo + LinesOfMemo.Strings[i] + #13;
     result := _str_memo;
end;

procedure TfrmKartkaPacienta.FormCreate(Sender: TObject);
begin
     SQLQuery_KartkaPatient.SQL.Clear;
     SQLQuery_KartkaPatient.SQL.Add('SELECT * FROM sel_patientone(' + _idp + ');');
     SQLQuery_KartkaPatient.Active := True;

     SQLQuery_KartkaPatientHistory.SQL.Clear;
     SQLQuery_KartkaPatientHistory.SQL.Add('SELECT * FROM sel_patientexamination(' + _idp + ');');
     SQLQuery_KartkaPatientHistory.Active := True;

     SQLQuery_KartkaPatientTests.SQL.Clear;
     SQLQuery_KartkaPatientTests.SQL.Add('SELECT * FROM sel_patienttests(' + _idp + ');');
     SQLQuery_KartkaPatientTests.Active := True;
end;

procedure TfrmKartkaPacienta.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
     SQLQuery_KartkaPatientTests.Active := False;
     SQLQuery_KartkaPatientHistory.Active := False;
     SQLQuery_KartkaPatient.Active := False;
end;

procedure TfrmKartkaPacienta.Button1Click(Sender: TObject);
var
   frmVisitPatient: TfrmVisitPatient;

begin
     frmVisitPatient := TfrmVisitPatient.Create(Application);
     if frmVisitPatient.ShowModal = mrOk then
     begin
       with SQLScript.Script do
        begin
            Clear;
            Add('INSERT INTO public."Examination"(');
            Add('idp, diagnosis, medicaments, medicalopinion, idd)');
	    Add('VALUES (');
            Add('''' + _idp + ''',');
            Add('''' + frmVisitPatient.LabeledEdit1.Text + ''',');
            Add('''' + Convert_Strings(frmVisitPatient.Memo2.Lines) + ''',');
            Add('''' + Convert_Strings(frmVisitPatient.Memo1.Lines) + ''',');
            Add('''' + _idd + ''');');
        end;
        try
           try
              SQLTransaction_Script.StartTransaction;
              SQLScript.Execute;
              SQLTransaction_Script.Commit;
           finally
                  MessageDlg('Дані про огляд пацієнта успішно добавлено!', mtInformation, [mbOK], 0);
           end;
        except
              frmMain.SQLTransaction_Script.Rollback;
        end;
     end;
     frmVisitPatient.Free;
     SQLQuery_KartkaPatientHistory.Refresh;
end;

procedure TfrmKartkaPacienta.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmKartkaPacienta.Button2Click(Sender: TObject);
var
  frmAddAnalisis: TfrmAddAnalisis;

begin
     frmAddAnalisis := TfrmAddAnalisis.Create(Application);
     if frmAddAnalisis.ShowModal = mrOk then
     begin
       with SQLScript.Script do
        begin
            Clear;
            Add('INSERT INTO public."Tests"(');
            Add('idp, namelaboratory, resultanalysis, nameanalysis)');
	    Add('VALUES (');
            Add('''' + _idp + ''',');
            Add('''' + frmAddAnalisis.LabeledEdit2.Text + ''',');
            Add('''' + Convert_Strings(frmAddAnalisis.Memo1.Lines) + ''',');
            Add('''' + frmAddAnalisis.LabeledEdit1.Text + ''');');
        end;
        try
           try
              SQLTransaction_Script.StartTransaction;
              SQLScript.Execute;
              SQLTransaction_Script.Commit;
           finally
                  MessageDlg('Дані про аналіз пацієнта успішно добавлено!', mtInformation, [mbOK], 0);
           end;
        except
              frmMain.SQLTransaction_Script.Rollback;
        end;
     end;
     frmAddAnalisis.Free;
     SQLQuery_KartkaPatientTests.Refresh;
end;

end.

