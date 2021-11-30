page 50255 "Contact Feeder List"
{

    ApplicationArea = All;
    Caption = 'Contact Feeder List';
    PageType = List;
    SourceTable = "Contact Feeder Entry";
    SourceTableView = WHERE("Line No." = CONST(0));
    CardPageId = "Contact Feeder Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 Code field.';
                    ApplicationArea = All;
                }
                field("RSM Code"; Rec."RSM Code")
                {
                    ToolTip = 'Specifies the value of the RSM Code field.';
                    ApplicationArea = All;
                }
                field("ISR Code"; Rec."ISR Code")
                {
                    ToolTip = 'Specifies the value of the ISR Code field.';
                    ApplicationArea = All;
                }
                field("OSR Code"; Rec."OSR Code")
                {
                    ToolTip = 'Specifies the value of the OSR Code field.';
                    ApplicationArea = All;
                }
                field("CSR Code"; Rec."CSR Code")
                {
                    ToolTip = 'Specifies the value of the CSR Code field.';
                    ApplicationArea = All;
                }
                field(Synched; Synch)
                {
                    ToolTip = 'Specifies the value of the CSR Code field.';
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    ApplicationArea = All;
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.';
                    ApplicationArea = All;
                }
            }
        }
    }


    var
        ContactFeederEntry: Record "Contact Feeder Entry";
        Synch: Boolean;
        SynchEntryCount: Integer;

    trigger OnOpenPage()
    begin
        SynchEntryCount := 0;
        ContactFeederEntry.RESET;
        ContactFeederEntry.SETRANGE(ContactFeederEntry."Entry No.", rec."Entry No.");
        IF ContactFeederEntry.FINDSET THEN BEGIN
            REPEAT
                IF ContactFeederEntry.Synched = FALSE THEN
                    SynchEntryCount := SynchEntryCount + 1;
            UNTIL ContactFeederEntry.NEXT = 0;
        END;
        IF SynchEntryCount > 0 THEN
            Synch := FALSE
        ELSE
            Synch := TRUE;
    end;

    trigger OnAfterGetRecord()
    begin
        SynchEntryCount := 0;
        ContactFeederEntry.RESET;
        ContactFeederEntry.SETRANGE(ContactFeederEntry."Entry No.", rec."Entry No.");
        IF ContactFeederEntry.FINDSET THEN BEGIN
            REPEAT
                IF ContactFeederEntry.Synched = FALSE THEN
                    SynchEntryCount := SynchEntryCount + 1;
            UNTIL ContactFeederEntry.NEXT = 0;
        END;
        IF SynchEntryCount > 0 THEN
            Synch := FALSE
        ELSE
            Synch := TRUE;
    end;
}
