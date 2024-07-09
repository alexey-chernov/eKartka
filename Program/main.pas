unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, PQConnection, SQLDB, DB, Forms, Controls, Graphics,
  Dialogs, ComCtrls, inifiles, DBCtrls, DBGrids, ExtCtrls, Buttons, StdCtrls,
  Menus, DateTimePicker;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    PQConnection_Main: TPQConnection;
    Separator1: TMenuItem;
    SQLQuery_PatientKart_toEdit: TSQLQuery;
    SQLQuery_PatientKart_toEditid_patient: TLongintField;
    SQLQuery_PatientKart_toEditparentname: TStringField;
    SQLQuery_PatientKart_toEditparentsurname: TStringField;
    SQLQuery_PatientKart_toEditpatientname: TStringField;
    SQLQuery_PatientKart_toEditpatientsurname: TStringField;
    SQLQuery_PatientKart_toEditpatient_address: TStringField;
    SQLQuery_PatientKart_toEditpatient_dateofbirth: TDateField;
    SQLQuery_PatientKart_toEditpatient_email: TStringField;
    SQLQuery_PatientKart_toEditpatient_telnumber: TStringField;
    SQLQuery_Patients: TSQLQuery;
    SQLQuery_Patientsid_patient: TLongintField;
    SQLQuery_Patientspatient: TStringField;
    SQLScript: TSQLScript;
    SQLTransaction1: TSQLTransaction;
    SQLTransaction_Script: TSQLTransaction;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;
  _idp, _idd : string;

implementation

{$R *.lfm}

{ TfrmMain }

uses Karta_Pacienta, CreateKartka, grafik;

procedure TfrmMain.FormCreate(Sender: TObject);
var
   ifile, servername, database, rolename, password : string;
   ini : tinifile;
begin
     ifile := expandfilename('eKartka.ini');
     if fileexists(ifile) then
     begin
          ini := tinifile.Create(ifile);
          servername := ini.ReadString('SERVER','server',' ');
          database := ini.ReadString('SERVER','database',' ');
          rolename := ini.ReadString('SERVER','rolename',' ');
          password := ini.ReadString('SERVER','password',' ');
     end;

     PQConnection_Main.HostName := servername;
     PQConnection_Main.DatabaseName := database;
     PQConnection_Main.Role := rolename;
     PQConnection_Main.UserName := rolename;
     PQConnection_Main.Password := password;

     PQConnection_Main.Connected := True;

     SQLQuery_Patients.Active := True;

     _idd := '1';              {Поки що id лікаря 1}
end;

procedure TfrmMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    SQLQuery_Patients.Active := False;
    PQConnection_Main.Connected := False;
end;

procedure TfrmMain.DBGrid1DblClick(Sender: TObject);
var
  frmKartkaPacienta: TfrmKartkaPacienta;
begin
     _idp := SQLQuery_Patients.FieldByName('id_patient').AsString;
     frmKartkaPacienta := TfrmKartkaPacienta.Create(Application);
     frmKartkaPacienta.ShowModal;
     frmKartkaPacienta.Free;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var
   frmCreateKart: TfrmCreateKart;
   _DateStr : string;
begin
   frmCreateKart := TfrmCreateKart.Create(Application);
   if frmCreateKart.ShowModal = mrOk then
   begin
        DateTimeToString(_DateStr, 'dd/mm/yy', frmCreateKart.DateTimePicker1.Date);
        with SQLScript.Script do
        begin
            Clear;
            Add('INSERT INTO public."Patients"(');
            Add('name, surname, address, emailaddress, telnumber, parent_name, parent_surname, dateofbirth)');
	    Add('VALUES (');
            Add('''' + frmCreateKart.LabeledEdit1.Text + ''',');
            Add('''' + frmCreateKart.LabeledEdit2.Text + ''',');
            Add('''' + frmCreateKart.LabeledEdit3.Text + ''',');
            Add('''' + frmCreateKart.LabeledEdit7.Text + ''',');
            Add('''' + frmCreateKart.LabeledEdit6.Text + ''',');
            Add('''' + frmCreateKart.LabeledEdit5.Text + ''',');
            Add('''' + frmCreateKart.LabeledEdit4.Text + ''',');
            Add('''' + _DateStr + ''');');
        end;
//        SQLScript.Script.SaveToFile('Script.sql');
        try
           try
              frmMain.SQLTransaction_Script.StartTransaction;
              frmMain.SQLScript.Execute;
              frmMain.SQLTransaction_Script.Commit;
           finally
                  MessageDlg('Картку нового пацієнта успішно добавлено!', mtInformation, [mbOK], 0);
           end;
        except
              frmMain.SQLTransaction_Script.Rollback;
        end;
   end;
   frmCreateKart.Free;
   SQLQuery_Patients.Refresh
end;

procedure TfrmMain.Button2Click(Sender: TObject);
var
  formGrafik: TformGrafik;
begin
  formGrafik := TformGrafik.Create(Application);

  formGrafik.ShowModal;
  formGrafik.Free;
end;

procedure TfrmMain.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key = 13 then DBGrid1DblClick(Sender);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Сервер: ' + PQConnection_Main.HostName;
  StatusBar1.Panels[1].Text := 'База даних: ' + PQConnection_Main.DatabaseName;
end;

procedure TfrmMain.MenuItem2Click(Sender: TObject);
var
   frmCreateKart: TfrmCreateKart;
   _DateStr, _idpt : string;
begin
   frmCreateKart := TfrmCreateKart.Create(Application);
   frmCreateKart.Caption := 'Редагування картки пацієнта';

   SQLQuery_PatientKart_toEdit.SQL.Clear;
   SQLQuery_PatientKart_toEdit.SQL.Add('SELECT * FROM sel_patientone_foredit(' + SQLQuery_Patients.FieldByName('id_patient').AsString + ');');
   SQLQuery_PatientKart_toEdit.Active := True;

   _idpt := SQLQuery_PatientKart_toEdit.FieldByName('id_patient').AsString;
   frmCreateKart.LabeledEdit1.Text := SQLQuery_PatientKart_toEdit.FieldByName('patientname').AsString;
   frmCreateKart.LabeledEdit2.Text := SQLQuery_PatientKart_toEdit.FieldByName('patientsurname').AsString;
   frmCreateKart.LabeledEdit3.Text := SQLQuery_PatientKart_toEdit.FieldByName('patient_address').AsString;
   frmCreateKart.DateTimePicker1.Date := SQLQuery_PatientKart_toEdit.FieldByName('patient_dateofbirth').AsDateTime;
   frmCreateKart.LabeledEdit5.Text := SQLQuery_PatientKart_toEdit.FieldByName('parentname').AsString;
   frmCreateKart.LabeledEdit4.Text := SQLQuery_PatientKart_toEdit.FieldByName('parentsurname').AsString;
   frmCreateKart.LabeledEdit6.Text := SQLQuery_PatientKart_toEdit.FieldByName('patient_telnumber').AsString;
   frmCreateKart.LabeledEdit7.Text := SQLQuery_PatientKart_toEdit.FieldByName('patient_email').AsString;

   if frmCreateKart.ShowModal = mrOk then
   begin
        DateTimeToString(_DateStr, 'dd/mm/yy', frmCreateKart.DateTimePicker1.Date);
        with SQLScript.Script do
        begin
            Clear;
            Add('UPDATE public."Patients"');
            Add('SET');
            Add('	name=''' + frmCreateKart.LabeledEdit1.Text + ''',');
            Add('	surname=''' + frmCreateKart.LabeledEdit2.Text + ''',');
            Add('	address=''' + frmCreateKart.LabeledEdit3.Text + ''',');
            Add('	emailaddress=''' + frmCreateKart.LabeledEdit7.Text + ''',');
            Add('	telnumber=''' + frmCreateKart.LabeledEdit6.Text + ''',');
            Add('	parent_name=''' + frmCreateKart.LabeledEdit5.Text + ''',');
            Add('	parent_surname=''' + frmCreateKart.LabeledEdit4.Text + ''',');
            Add('	dateofbirth=''' + _DateStr + '''');
            Add('WHERE "Id"=' + _idpt + ';');
        end;
//        SQLScript.Script.SaveToFile('Script.sql');
        try
           try
              frmMain.SQLTransaction_Script.StartTransaction;
              frmMain.SQLScript.Execute;
              frmMain.SQLTransaction_Script.Commit;
           finally
                  MessageDlg('Картку пацієнта успішно відредаговано!', mtInformation, [mbOK], 0);
           end;
        except
              frmMain.SQLTransaction_Script.Rollback;
        end;
   end;
   frmCreateKart.Free;
   SQLQuery_PatientKart_toEdit.Active := False;
   SQLQuery_Patients.Refresh
end;

procedure TfrmMain.MenuItem3Click(Sender: TObject);
var
   _idpt : string;
begin
   _idpt := SQLQuery_Patients.FieldByName('id_patient').AsString;
   if MessageDlg('Ви дійсно бажаєте видалити картку пацієнта ' + #13 +
                 SQLQuery_Patients.FieldByName('patient').AsString + ' ?',
                 mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   begin
        with SQLScript.Script do
        begin
            Clear;
            Add('UPDATE public."Patients"');
            Add('SET deleted_kart=true');
	    Add('WHERE "Id"=' + _idpt + ';');
        end;
//        SQLScript.Script.SaveToFile('Script.sql');
        try
           try
              SQLTransaction_Script.StartTransaction;
              SQLScript.Execute;
              SQLTransaction_Script.Commit;
           finally
                  MessageDlg('Картку пацієнта було видолено!', mtInformation, [mbOK], 0);
           end;
        except
              SQLTransaction_Script.Rollback;
        end;
   end;
   SQLQuery_Patients.Refresh
end;

end.

