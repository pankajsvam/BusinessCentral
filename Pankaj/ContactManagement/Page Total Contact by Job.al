page 50147 "Total Contact by Job"
{
    PageType = ListPart;
    SourceTable = "Contact Buffer";
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTableView = sorting(DefaultInteger) where(Option = filter(= 'DUMPCONTACTLOGBYJOB'));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Field(Option; Rec.Option)
                {

                }
                Field("Option Choice"; Rec."Option Choice")
                {

                }
                Field("Division Code"; Rec."Division Code")
                {
                    Caption = 'Division Code';
                }
                Field("Division Description"; Rec."DefaultText250") { Caption = 'Division Description'; }
                Field("Total for Month January"; Rec."DefaultInteger_1") { Caption = 'Total for Month January'; }
                Field("Total for Month February"; Rec."DefaultInteger_2") { Caption = 'Total for Month February'; }
                Field("Total for Month March"; Rec."DefaultInteger_3") { Caption = 'Total for Month March'; }
                Field("Total for Month April"; Rec."DefaultInteger_4") { Caption = 'Total for Month April'; }
                Field("Total for Month May"; Rec."DefaultInteger_5") { Caption = 'Total for Month May'; }
                Field("Total for Month June"; Rec."DefaultInteger_6") { Caption = 'Total for Month June'; }
                Field("Total for Month July"; Rec."DefaultInteger_7") { Caption = 'Total for Month July'; }
                Field("Total for Month August"; Rec."DefaultInteger_8") { Caption = 'Total for Month August'; }
                Field("Total for Month Sepetember"; Rec."DefaultInteger_9") { Caption = 'Total for Month Sepetember'; }
                Field("Total for Month October"; Rec."DefaultInteger_10") { Caption = 'Total for Month October'; }
                Field("Total for Month November"; Rec."DefaultInteger_11") { Caption = 'Total for Month November'; }
                Field("Total for Month December"; Rec."DefaultInteger_12") { Caption = 'Total for Month December'; }
                field(DefaultTime; Rec.DefaultTime) { Caption = 'Time'; }
            }
        }
    }
    trigger OnOpenPage();
    begin
        Rec.SetRange(Option, YearVar);
    end;

    trigger OnAfterGetRecord();
    begin
        IF STRPOS(Rec.DefaultText250, 'Total') > 0 THEN
            StyleProperty := 'Strong'
        ELSE
            StyleProperty := '';
        Rec.SETRANGE("DefaultText 30_1", OptionChoiceVar);
    end;

    var
        YearVar: Text[20];
        OptionChoiceVar: Text[30];
        StyleProperty: Text[30];

    procedure SetOptionChoice(YearVarPara: Text[30])
    begin
        OptionChoiceVar := YearVarPara;
    end;
}