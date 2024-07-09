unit AddVizit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons;

type

  { TfrmVisitPatient }

  TfrmVisitPatient = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    LabeledEdit1: TLabeledEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
  private

  public

  end;

var
  frmVisitPatient: TfrmVisitPatient;

implementation

{$R *.lfm}

{ TfrmVisitPatient }

end.

