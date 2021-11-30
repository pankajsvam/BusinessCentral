page 50256 "Contact Feeder Lines"
{

    Caption = 'Contact Feeder Lines';
    PageType = ListPart;
    SourceTable = "Contact Feeder Entry";
    DelayedInsert = false;
    AutoSplitKey = true;


    layout

    {
        area(content)
        {
            repeater(General)
            {
                field("Job Responsibility"; Rec."Job Responsibility")
                {
                    ToolTip = 'Specifies the value of the Job Responsibility field.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Enabled = RecEditable;
                    trigger OnValidate()
                    begin
                        IF rec."Job Responsibility" <> '' THEN BEGIN
                            JobResponsibility.RESET;
                            JobResponsibility.SETRANGE(Description, rec."Job Responsibility");
                            IF NOT JobResponsibility.FINDFIRST THEN
                                ERROR(JobRespError, rec."Job Responsibility");
                        END;
                    end;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ToolTip = 'Specifies the value of the Ship-to Code field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                }
                field(Pricing; Rec.Pricing)
                {
                    ToolTip = 'Specifies the value of the Pricing field.';
                    ApplicationArea = All;
                }
                field(Marketing; Rec.Marketing)
                {
                    ToolTip = 'Specifies the value of the Marketing field.';
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the value of the First Name field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                    trigger OnValidate()
                    begin
                        IF Rec.Type = rec.Type::Prospect THEN BEGIN
                            rec."Customer Name" := rec."First Name" + ' ' + rec."Last Name";
                            CurrPage.UPDATE;
                        End;
                    END;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the value of the Last Name field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                    trigger OnValidate()
                    begin
                        IF Rec.Type = rec.Type::Prospect THEN BEGIN
                            rec."Customer Name" := rec."First Name" + ' ' + rec."Last Name";
                            CurrPage.UPDATE;
                        End;
                    END;
                }
                field("Prospect Company Name"; Rec."Prospect Company Name")
                {
                    ToolTip = 'Specifies the value of the Prospect Company Name field.';
                    ApplicationArea = All;
                }
                field("E-Mail Address"; Rec."E-Mail Address")
                {
                    ToolTip = 'Specifies the value of the E-Mail Address field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                }
                field("Phone Number"; Rec."Phone Number")
                {
                    ToolTip = 'Specifies the value of the Phone Number field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                }
                field("Mobie Phone Number"; Rec."Mobie Phone Number")
                {
                    ToolTip = 'Specifies the value of the Mobie Phone Number field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                }
                field(County; Rec.County)
                {
                    ToolTip = 'Specifies the value of the County field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field.';
                    ApplicationArea = All;
                    Enabled = RecEditable;
                }
                field(Synched; Rec.Synched)
                {
                    ToolTip = 'Specifies the value of the Synched field.';
                    ApplicationArea = All;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ToolTip = 'Specifies the value of the Contact No. field.';
                    ApplicationArea = All;
                }
                field("Email Exist as Customer"; Rec."Email Exist as Customer")
                {
                    ToolTip = 'Specifies the value of the Email Exist as Customer field.';
                    ApplicationArea = All;
                }
                field("Email Exist as Prospect"; Rec."Email Exist as Prospect")
                {
                    ToolTip = 'Specifies the value of the Email Exist as Prospect field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        IF Rec.Synched THEN
            RecEditable := FALSE
        ELSE
            RecEditable := TRUE;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec.Synched THEN
            RecEditable := FALSE
        ELSE
            RecEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        IF Rec.Synched THEN
            RecEditable := FALSE
        ELSE
            RecEditable := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        IF Rec.Synched THEN
            RecEditable := FALSE
        ELSE
            RecEditable := TRUE;
    end;

    VAR
        RecEditable: Boolean;
        JobResponsibility: Record "Job Responsibility";
        JobRespError: TextConst ENU = '%1 Job Responsibility not available in Job Responsibility master, please select valid Job Responsibility from drop down.';

}
